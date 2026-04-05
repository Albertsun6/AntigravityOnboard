# 📊 Antigravity 度量报告 — {{DATE}}

> 自动生成 by `metrics-report` Skill | 采集时间: {{COLLECTED_AT}}

---

## Executive Summary

| 指标 | 数值 | 趋势 | 健康 |
|---|---|---|---|
| 📝 总会话数 | {{SESSIONS_TOTAL}} | {{SESSIONS_TREND}} | {{SESSIONS_HEALTH}} |
| 📄 Walkthrough 率 | {{WALKTHROUGH_RATE}}% | {{WALKTHROUGH_TREND}} | {{WALKTHROUGH_HEALTH}} |
| 🧩 Skills | {{SKILLS_COUNT}} | {{SKILLS_TREND}} | {{SKILLS_HEALTH}} |
| 📋 Workflows | {{WORKFLOWS_COUNT}} | {{WORKFLOWS_TREND}} | {{WORKFLOWS_HEALTH}} |
| 📚 Knowledge 条目 | {{KNOWLEDGE_COUNT}} | {{KNOWLEDGE_TREND}} | {{KNOWLEDGE_HEALTH}} |
| 💓 心跳巡逻次数 | {{HEARTBEAT_RUNS}} | {{HEARTBEAT_TREND}} | {{HEARTBEAT_HEALTH}} |
| 📚 记忆晋升 | {{PROMOTE_TOTAL}} 条 | {{PROMOTE_TREND}} | {{PROMOTE_HEALTH}} |
| 📏 GEMINI.md 行数 | {{GEMINI_LINES}} | {{GEMINI_TREND}} | {{GEMINI_HEALTH}} |
| 🗑️ 临时文件 | {{TMP_COUNT}} ({{TMP_SIZE}}) | — | {{TMP_HEALTH}} |

---

## 详细指标

### 会话统计

```mermaid
pie title 会话产出率
    "有 Walkthrough" : {{WALKTHROUGHS}}
    "无 Walkthrough" : {{NO_WALKTHROUGHS}}
```

- 总会话数: **{{SESSIONS_TOTAL}}**
- 有 Walkthrough 产出: **{{WALKTHROUGHS}}**
- 产出率: **{{WALKTHROUGH_RATE}}%**

### 能力资产

| 资产类型 | 当前数量 | 增量 |
|---|---|---|
| Skills | {{SKILLS_COUNT}} | {{SKILLS_DELTA}} |
| Workflows | {{WORKFLOWS_COUNT}} | {{WORKFLOWS_DELTA}} |
| Knowledge | {{KNOWLEDGE_COUNT}} | {{KNOWLEDGE_DELTA}} |

### 心跳健康

- 总巡逻次数: **{{HEARTBEAT_RUNS}}**
- 最近状态: **{{HEARTBEAT_LAST}}**
- 累计发现问题: **{{HEARTBEAT_ISSUES}}**

### 记忆晋升

- 已晋升条目: **{{PROMOTE_PROMOTED}}**
- 已合并条目: **{{PROMOTE_MERGED}}**
- 已扫描会话: **{{PROMOTE_SCANNED}}**

---

## 异常告警

{{#IF_ALERTS}}
> [!WARNING]
> {{ALERT_CONTENT}}
{{/IF_ALERTS}}

{{#IF_NO_ALERTS}}
> [!TIP]
> 所有指标健康，无异常告警。
{{/IF_NO_ALERTS}}

---

## 建议行动

{{RECOMMENDATIONS}}

---

## 与上期对比

| 指标 | 上期 | 本期 | 变化 |
|---|---|---|---|
| 会话数 | {{PREV_SESSIONS}} | {{SESSIONS_TOTAL}} | {{SESSIONS_DELTA}} |
| Skills | {{PREV_SKILLS}} | {{SKILLS_COUNT}} | {{SKILLS_DELTA}} |
| Knowledge | {{PREV_KNOWLEDGE}} | {{KNOWLEDGE_COUNT}} | {{KNOWLEDGE_DELTA}} |
| 心跳次数 | {{PREV_HEARTBEAT}} | {{HEARTBEAT_RUNS}} | {{HEARTBEAT_DELTA}} |

---

> **下次采集**：下次心跳巡逻时自动执行 | **完整数据**：`.agents/tmp/metrics_latest.json`
