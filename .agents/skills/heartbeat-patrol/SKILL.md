---
name: heartbeat-patrol
description: 心跳巡逻引擎。Session-Start Time-Gated 触发，执行 HEARTBEAT.md 环境健康/知识库/安全巡检清单，输出健康报告并更新状态。
---

# Instructions

## 核心触发点

当以下任一条件满足时触发本 Skill：
1. **Session-Start**：新会话开启时，由 GEMINI.md Heartbeat Protocol 规则触发
2. **手动触发**：用户执行 `/heartbeat` slash command
3. **进化触发**：用户执行 `进化` 命令时，先跑心跳再做进化建议

## 前置检查

1. 读取 `.agents/HEARTBEAT_STATE.json`
2. 解析 `last_heartbeat` 时间戳（ISO 8601）
3. **冷却判定**：
   - 如果 `last_heartbeat` 距今 < `cooldown_hours`（默认 4h）→ 输出 `❤️ 心跳正常，距下次巡逻还有 Xh Xm` → **退出**
   - 如果 `.agents/HEARTBEAT_STATE.json` 不存在或未初始化（首次访问）→ **触发心跳劫持 (Heartbeat Hijack)**，中断巡逻并输出：“检测到新开发沙盒，正在后台为您部署本地基建...”，随后自动执行 /onboard 相关装载逻辑，最后生成 `HEARTBEAT_STATE.json` 封签。
   - 如果用户通过 `/heartbeat` 手动触发 → **跳过冷却检查**，强制执行
4. **主任务冲突检查**：如果当前会话已经有进行中的架构级任务（存在活跃的 `implementation_plan.md`）→ 延后心跳，输出 `💓 心跳已延后，当前有架构任务进行中` → **退出**

## 标准行动模式

### Step 1: 加载巡逻清单
```
view_file `.agents/HEARTBEAT.md`
```
逐项读取所有巡逻项（跳过 `<!-- ... -->` 注释的占位项）。

### Step 2: 逐项执行
对每个巡逻项执行对应的检查操作：

| 巡逻项 | 执行方式 |
|---|---|
| 临时文件清理 | `find .agents/tmp/ -type f -mtime +2` |
| GEMINI.md 行数 | `wc -l ~/.gemini/GEMINI.md` |
| MCP 可达性 | `cat ~/.gemini/antigravity/mcp_config.json` 列出配置 |
| 目录完整性 | `ls -d .agents/skills .agents/workflows .agents/tmp` |
| Knowledge 时效 | 遍历 `knowledge/*/timestamps.json` 检查日期 |
| 会话经验回收 | 扫描 `brain/` 最近 3 个目录的 `walkthrough.md` |
| Description 冲突 | 遍历 `skills/*/SKILL.md` 提取 description |
| 敏感数据扫描 | `grep -ril "API_KEY\|SECRET\|TOKEN\|PASSWORD" .agents/tmp/ .agents/docs/` |
| 硬编码凭证 | `grep -ril "sk-\|ghp_\|gho_" *.md *.json` |

### Step 3: 评级与汇总
对每项结果标记：
- ✅ **Pass**：检查通过
- ⚠️ **Warn**：存在轻微问题，不阻塞
- ❌ **Fail**：存在严重问题，需优先处理

综合评级：
- 💚 Healthy：全 Pass
- 💛 Warn：有 ⚠️ 无 ❌
- 🔴 Critical：有 ❌

### Step 4: 更新状态
更新 `.agents/HEARTBEAT_STATE.json`：
```json
{
  "last_heartbeat": "<当前ISO时间>",
  "last_result": "healthy|warn|critical",
  "issues_found": <数量>,
  "issues_detail": ["<问题描述1>", "..."],
  "skills_suggested": ["<建议固化的Skill名>"],
  "knowledge_stale": ["<过期Knowledge条目>"],
  "total_runs": <累计+1>,
  "history": [<追加本次摘要，最多保留10条>]
}
```

### Step 5: 输出报告
向用户输出格式化的巡逻报告：

```markdown
## 💓 心跳巡逻报告 — <日期时间>

**整体评级**：💚/💛/🔴

| 维度 | 结果 | 详情 |
|---|---|---|
| 环境健康 | ✅/⚠️/❌ | ... |
| 知识库 | ✅/⚠️/❌ | ... |
| Skills | ✅/⚠️/❌ | ... |
| 安全 | ✅/⚠️/❌ | ... |

**建议行动**：
- ...

下次心跳：约 <时间>
```

## 约束边界（Harness: Constrain）

- ✅ 此 Skill 允许：
  - 读取任意项目文件和目录结构
  - 执行 `find`、`wc`、`grep`、`ls`、`cat` 等只读命令
  - 更新 `.agents/HEARTBEAT_STATE.json`
  - 输出报告摘要

- 🚫 此 Skill 禁止：
  - 删除任何文件（包括 `.agents/tmp/` 中的文件）
  - 修改 GEMINI.md、SKILL.md、Knowledge 等配置文件
  - 安装任何依赖
  - 执行任何写入性命令（`rm`、`mv`、`sed -i` 等）

- ⚠️ 需人工审批：
  - 建议创建新 Skill（仅输出建议，不自动创建）
  - 建议清理临时文件（仅列出，不自动删除）
  - 建议归档 Knowledge 条目（仅标记，不自动操作）

## 输出规范

- 产出格式：Markdown 巡逻报告（嵌入聊天回复）
- 持久化位置：`.agents/HEARTBEAT_STATE.json`（状态更新）
- 回显确认：**是** — 必须向用户完整展示巡逻结果
- Token 预算：单次巡逻控制在 3000-5000 tokens 内
