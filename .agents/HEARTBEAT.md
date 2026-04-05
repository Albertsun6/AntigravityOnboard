# 💓 Antigravity 心跳巡逻清单

> **用途**：Agent 在 Session-Start 或 `/heartbeat` 手动触发时，逐项执行此清单进行环境巡检。
> **执行引擎**：`heartbeat-patrol` Skill
> **状态记录**：`.agents/HEARTBEAT_STATE.json`
> **冷却时间**：默认 4 小时（防止频繁执行浪费 Token）

---

## 环境健康检查

- [ ] **临时文件清理**：扫描 `.agents/tmp/` 中超过 48 小时的文件 → 列出并提醒用户清理
- [ ] **GEMINI.md 行数审计**：
  - `~/.gemini/GEMINI.md` 行数 > 200 → ⚠️ 告警，建议拆分到 Skills/Knowledge
  - 项目根 `GEMINI.md`（如存在）行数 > 150 → ⚠️ 告警
- [ ] **MCP Server 可达性**：读取 `~/.gemini/antigravity/mcp_config.json`，列出已配置 Server，标注当前生效状态
- [ ] **目录结构完整性**：确认以下目录存在：
  - `.agents/skills/`
  - `.agents/workflows/`
  - `.agents/tmp/`

## 知识库维护

- [ ] **Knowledge 时效性**：扫描 `~/.gemini/antigravity/knowledge/` 各条目的 `timestamps.json`，标记超过 30 天未更新的条目 → 提醒归档或更新
- [ ] **会话经验回收**：扫描最近 3 个会话的 `walkthrough.md`，提取可复用模式关键词（如果 `memory-promote` Skill 已就绪，委托执行）

## Skills 健康

- [ ] **Description 冲突检测**：遍历所有 `SKILL.md` 的 `description` 字段，检查是否存在相似度过高的描述 → 提醒修改
- [ ] **高频模式固化建议**：基于最近 5 个会话的交互模式，识别重复操作 → 如果没有对应 Skill，建议固化

## 安全审计

- [ ] **敏感数据扫描**：快速检查 `.agents/tmp/` 和 `.agents/docs/` 中是否有包含 `API_KEY`、`SECRET`、`TOKEN`、`PASSWORD` 等关键词的文件
- [ ] **硬编码凭证检查**：扫描项目根目录下 `.md` 和 `.json` 文件，检查是否有硬编码的 API Key 或密码

## 记忆晋升巡逻

- [ ] **增量会话扫描**：对比 `PROMOTE_STATE.json` 中 `sessions_scanned` 与 `brain/` 实际会话列表 → 识别未处理的新会话
- [ ] **模式提取**：读取未扫描会话的 `walkthrough.md`，提取可复用模式/踩坑教训/最佳实践
- [ ] **晋升提议**：与现有 Knowledge 条目去重对比 → 输出 新建/合并/跳过 提议清单（委托 `memory-promote` Skill 执行）
- [ ] **状态更新**：晋升完成后更新 `PROMOTE_STATE.json`

## 度量巡逻

- [ ] **采集指标**：执行 `.agents/scripts/metrics_collector.sh` 采集最新度量数据
- [ ] **生成报告**：基于 `.agents/templates/metrics_report.md` 模板生成报告到 `.agents/docs/metrics/`（委托 `metrics-report` Skill 执行）
- [ ] **异常检测**：检查关键指标是否触发告警阈值（GEMINI.md >200行 / 临时文件 >10 / Walkthrough率 <50% / 心跳Critical率 >30%）

---

## 巡逻结果评级

| 评级 | 条件 | 行动 |
|---|---|---|
| 💚 **Healthy** | 全部 Pass，无 Warn/Fail | 记录时间戳，正常继续 |
| 💛 **Warn** | 存在 ⚠️ 但无 ❌ | 输出建议清单，不阻塞 |
| 🔴 **Critical** | 存在 ❌ Fail 项 | 优先处理，阻塞提醒 |

> **维护守则**：巡逻清单总项控制在 **15 项以内**。新增项需评估 Token 成本。
