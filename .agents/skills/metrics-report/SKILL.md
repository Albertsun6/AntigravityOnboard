---
name: metrics-report
description: Agent 效能度量报告引擎。执行 metrics_collector.sh 采集数据，生成可视化度量报告，追踪 Skills/Knowledge/心跳/晋升等关键指标的增量趋势。
---

# Instructions

## 核心触发点

当以下任一条件满足时触发：
1. **心跳巡逻中调用**：`heartbeat-patrol` 执行到「度量巡逻」项时委托本 Skill
2. **手动触发**：用户说 "度量报告"、"指标报告" 或 `/metrics`
3. **进化触发**：用户执行 `进化` 命令时，基于度量数据提供进化建议

## 前置检查

1. 确认 `.agents/scripts/metrics_collector.sh` 存在且可执行
2. 确认 `~/.gemini/antigravity/brain/` 目录可访问
3. 如果脚本不存在 → 输出错误提示 → 退出

## 标准行动模式

### Step 1: 执行采集

```bash
chmod +x .agents/scripts/metrics_collector.sh
bash .agents/scripts/metrics_collector.sh "<workspace_root>"
```

### Step 2: 读取指标 JSON

读取 `.agents/tmp/metrics_latest.json`，解析结构化数据。

### Step 3: 增量对比

- 如果 `.agents/docs/metrics/` 下存在历史报告 → 提取上次数据进行增量对比
- 使用 `↑` / `↓` / `→` 标注趋势方向
- 如果是首次运行 → 标注为 "基线"

### Step 4: 生成报告

基于 `.agents/templates/metrics_report.md` 模板，填充数据生成报告。

存储到：`.agents/docs/metrics/report_<YYYY-MM-DD>.md`

### Step 5: 异常检测

| 指标 | 阈值 | 行动 |
|---|---|---|
| GEMINI.md 全局行数 | > 200 行 | ⚠️ 告警 |
| 临时文件数 | > 10 个 | ⚠️ 建议清理 |
| Walkthrough 率 | < 50% | ⚠️ 建议养成习惯 |
| 心跳 Critical 率 | > 30% | 🔴 需关注 |

### Step 6: 输出摘要

向用户展示精简版度量面板：

```markdown
## 📊 Antigravity 度量面板 — <日期>

| 维度 | 数值 | 趋势 | 健康 |
|---|---|---|---|
| 总会话 | XX | ↑ +N | 💚 |
| Skills | XX | → 0 | 💚 |
| Knowledge | XX | ↑ +N | 💚 |
| 心跳通过率 | XX% | ↑ | 💚 |
| 记忆晋升 | XX 条 | ↑ +N | 💚 |
| GEMINI.md | XX 行 | → | 💚/💛 |

**关键洞察**：
- ...

完整报告：`.agents/docs/metrics/report_<date>.md`
```

## 约束边界（Harness: Constrain）

- ✅ 此 Skill 允许：
  - 执行 `metrics_collector.sh`（只读脚本）
  - 读取 `.agents/tmp/metrics_latest.json`
  - 创建报告到 `.agents/docs/metrics/`
  - 读取历史报告进行对比

- 🚫 此 Skill 禁止：
  - 修改任何数据源文件
  - 删除历史报告
  - 执行非只读命令

- ⚠️ 需人工审批：
  - 基于度量建议修改 GEMINI.md
  - 基于度量建议创建/删除 Skills

## 输出规范

- 产出格式：Markdown 度量面板（嵌入聊天回复）+ 完整报告文件
- 持久化位置：`.agents/docs/metrics/report_<date>.md`
- 回显确认：**是** — 精简面板必须嵌入回复，完整报告链接附后
