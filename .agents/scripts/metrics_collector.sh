#!/usr/bin/env bash
# ============================================================================
# Antigravity Metrics Collector
# ============================================================================
# 用途：采集 Agent 效能度量指标，输出结构化 JSON 供 metrics-report Skill 消费
# 触发：心跳巡逻中调用 / 用户手动 /metrics
# 数据源：brain/ 目录 + HEARTBEAT_STATE.json + PROMOTE_STATE.json
#
# 约束：纯只读操作，不修改任何数据源
# ============================================================================

set -euo pipefail

# === 配置 ===
WORKSPACE_ROOT="${1:-.}"
AGENTS_DIR="${WORKSPACE_ROOT}/.agents"
BRAIN_DIR="${HOME}/.gemini/antigravity/brain"
KNOWLEDGE_DIR="${HOME}/.gemini/antigravity/knowledge"
HEARTBEAT_STATE="${AGENTS_DIR}/HEARTBEAT_STATE.json"
PROMOTE_STATE="${AGENTS_DIR}/PROMOTE_STATE.json"
OUTPUT_FILE="${AGENTS_DIR}/tmp/metrics_latest.json"

# === 函数 ===

# 统计会话总数（brain 目录下子目录数）
count_sessions() {
  if [ -d "$BRAIN_DIR" ]; then
    find "$BRAIN_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' '
  else
    echo "0"
  fi
}

# 统计 walkthrough 存在的会话数（有产出）
count_walkthroughs() {
  if [ -d "$BRAIN_DIR" ]; then
    find "$BRAIN_DIR" -name "walkthrough.md" 2>/dev/null | wc -l | tr -d ' '
  else
    echo "0"
  fi
}

# 统计 Skills 数量
count_skills() {
  if [ -d "${AGENTS_DIR}/skills" ]; then
    find "${AGENTS_DIR}/skills" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' '
  else
    echo "0"
  fi
}

# 统计 Workflows 数量
count_workflows() {
  if [ -d "${AGENTS_DIR}/workflows" ]; then
    find "${AGENTS_DIR}/workflows" -name "*.md" ! -name "_TEMPLATE*" 2>/dev/null | wc -l | tr -d ' '
  else
    echo "0"
  fi
}

# 统计 Knowledge 条目数
count_knowledge() {
  if [ -d "$KNOWLEDGE_DIR" ]; then
    find "$KNOWLEDGE_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' '
  else
    echo "0"
  fi
}

# 读取心跳状态
get_heartbeat_stats() {
  if [ -f "$HEARTBEAT_STATE" ]; then
    local total_runs last_result issues_found
    total_runs=$(python3 -c "import json; d=json.load(open('$HEARTBEAT_STATE')); print(d.get('total_runs', 0))" 2>/dev/null || echo "0")
    last_result=$(python3 -c "import json; d=json.load(open('$HEARTBEAT_STATE')); print(d.get('last_result', 'unknown'))" 2>/dev/null || echo "unknown")
    issues_found=$(python3 -c "import json; d=json.load(open('$HEARTBEAT_STATE')); print(d.get('issues_found', 0))" 2>/dev/null || echo "0")
    echo "${total_runs}|${last_result}|${issues_found}"
  else
    echo "0|no_state|0"
  fi
}

# 读取晋升状态
get_promote_stats() {
  if [ -f "$PROMOTE_STATE" ]; then
    local items_promoted items_merged sessions_scanned
    items_promoted=$(python3 -c "import json; d=json.load(open('$PROMOTE_STATE')); print(d.get('items_promoted', 0))" 2>/dev/null || echo "0")
    items_merged=$(python3 -c "import json; d=json.load(open('$PROMOTE_STATE')); print(d.get('items_merged', 0))" 2>/dev/null || echo "0")
    sessions_scanned=$(python3 -c "import json; d=json.load(open('$PROMOTE_STATE')); print(len(d.get('sessions_scanned', [])))" 2>/dev/null || echo "0")
    echo "${items_promoted}|${items_merged}|${sessions_scanned}"
  else
    echo "0|0|0"
  fi
}

# 统计 .agents/tmp/ 文件数和总大小
get_tmp_stats() {
  if [ -d "${AGENTS_DIR}/tmp" ]; then
    local count size
    count=$(find "${AGENTS_DIR}/tmp" -type f 2>/dev/null | wc -l | tr -d ' ')
    size=$(du -sh "${AGENTS_DIR}/tmp" 2>/dev/null | cut -f1 || echo "0B")
    echo "${count}|${size}"
  else
    echo "0|0B"
  fi
}

# GEMINI.md 行数
get_gemini_lines() {
  local global_lines=0 project_lines=0
  if [ -f "${HOME}/.gemini/GEMINI.md" ]; then
    global_lines=$(wc -l < "${HOME}/.gemini/GEMINI.md" | tr -d ' ')
  fi
  if [ -f "${WORKSPACE_ROOT}/GEMINI.md" ]; then
    project_lines=$(wc -l < "${WORKSPACE_ROOT}/GEMINI.md" | tr -d ' ')
  fi
  echo "${global_lines}|${project_lines}"
}

# === 主采集流程 ===

echo "📊 Antigravity Metrics Collector — $(date '+%Y-%m-%d %H:%M:%S')"
echo "=================================================="

SESSIONS=$(count_sessions)
WALKTHROUGHS=$(count_walkthroughs)
SKILLS=$(count_skills)
WORKFLOWS=$(count_workflows)
KNOWLEDGE=$(count_knowledge)

IFS='|' read -r HB_RUNS HB_RESULT HB_ISSUES <<< "$(get_heartbeat_stats)"
IFS='|' read -r PM_PROMOTED PM_MERGED PM_SCANNED <<< "$(get_promote_stats)"
IFS='|' read -r TMP_COUNT TMP_SIZE <<< "$(get_tmp_stats)"
IFS='|' read -r GEMINI_GLOBAL GEMINI_PROJECT <<< "$(get_gemini_lines)"

# 输出摘要
echo ""
echo "📈 会话统计"
echo "  总会话数: ${SESSIONS}"
echo "  有 Walkthrough: ${WALKTHROUGHS}"
echo "  Walkthrough 率: $(( WALKTHROUGHS * 100 / (SESSIONS > 0 ? SESSIONS : 1) ))%"
echo ""
echo "🧩 能力资产"
echo "  Skills: ${SKILLS}"
echo "  Workflows: ${WORKFLOWS}"
echo "  Knowledge 条目: ${KNOWLEDGE}"
echo ""
echo "💓 心跳统计"
echo "  总巡逻次数: ${HB_RUNS}"
echo "  最近状态: ${HB_RESULT}"
echo "  累计问题: ${HB_ISSUES}"
echo ""
echo "📚 记忆晋升"
echo "  已晋升条目: ${PM_PROMOTED}"
echo "  已合并条目: ${PM_MERGED}"
echo "  已扫描会话: ${PM_SCANNED}"
echo ""
echo "🛡️ 安全指标"
echo "  临时文件数: ${TMP_COUNT} (${TMP_SIZE})"
echo "  GEMINI.md 全局行数: ${GEMINI_GLOBAL}"
echo "  GEMINI.md 项目行数: ${GEMINI_PROJECT}"
echo ""

# 输出 JSON（供 Skill 消费）
mkdir -p "$(dirname "$OUTPUT_FILE")"
cat > "$OUTPUT_FILE" << EOF
{
  "collected_at": "$(date -u '+%Y-%m-%dT%H:%M:%SZ')",
  "sessions": {
    "total": ${SESSIONS},
    "with_walkthrough": ${WALKTHROUGHS}
  },
  "assets": {
    "skills": ${SKILLS},
    "workflows": ${WORKFLOWS},
    "knowledge_entries": ${KNOWLEDGE}
  },
  "heartbeat": {
    "total_runs": ${HB_RUNS},
    "last_result": "${HB_RESULT}",
    "issues_found": ${HB_ISSUES}
  },
  "memory_promote": {
    "items_promoted": ${PM_PROMOTED},
    "items_merged": ${PM_MERGED},
    "sessions_scanned": ${PM_SCANNED}
  },
  "hygiene": {
    "tmp_file_count": ${TMP_COUNT},
    "tmp_size": "${TMP_SIZE}",
    "gemini_global_lines": ${GEMINI_GLOBAL},
    "gemini_project_lines": ${GEMINI_PROJECT}
  }
}
EOF

echo "✅ 指标已写入 ${OUTPUT_FILE}"
