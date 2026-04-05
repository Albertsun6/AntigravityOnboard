# Antigravity 团队协作指南

> **面向**：新加入使用 Antigravity IDE 的团队成员
> **前提**：已完成 `/onboard` Workflow 配置

---

## 什么是 Antigravity？

Google Antigravity 是一个 **Agent-First IDE**。与传统 IDE 不同，你不是在"写代码+AI补全"，而是作为**架构师**，指挥 AI Agent 执行工程任务。

**核心范式转变**：
- 传统：人类 → 逐行写代码 → AI 补全
- Antigravity：人类 → 描述意图 → Agent 编码/测试/验证 → 人类审阅

---

## 快速上手 5 分钟

### 1. 首先了解目录结构

```
项目根/
├── GEMINI.md              ← 项目级 AI 行为规则
├── .agents/               ← AI 能力层（核心）
│   ├── skills/            ← 技能（自动匹配触发）
│   ├── workflows/         ← 工作流（/slash 命令触发）
│   ├── templates/         ← 模板文件
│   ├── scripts/           ← 辅助脚本
│   ├── docs/              ← 持久化报告
│   └── tmp/               ← 💣 临时文件必须放这里
└── ~/.gemini/
    ├── GEMINI.md           ← 全局 AI 人格
    └── antigravity/
        ├── knowledge/      ← 长期知识库
        └── brain/          ← 会话 Artifacts
```

### 2. 记住核心命令

| 命令 | 含义 | 使用场景 |
|---|---|---|
| `直接做` | 跳过确认，立即执行 | 简单任务 |
| `全做` | 执行所有建议步骤 | 批量操作 |
| `验收` | 触发 5 项检查清单 | 功能完成后 |
| `记住 <内容>` | 持久化规则/知识 | 沉淀经验 |
| `开新局` | 标准化换会话 | Context 过长 |
| `深挖` | 纵向展开细节 | 需要深入理解 |
| `拉远` | 缩到更高抽象层 | 需要全局视角 |

### 3. 心跳巡逻

Agent 会在每次新会话时**自动执行**环境健康巡检（如果距上次超过 4 小时）。

你也可以手动触发：`/heartbeat`

### 4. Planning Mode

对于超过 3 个文件的变更，Agent 会自动进入 Planning Mode：
1. 📋 `implementation_plan.md` — 设计方案（需你审批）
2. 📝 `task.md` — 执行追踪
3. 📊 `walkthrough.md` — 完成总结

### 5. Context 健康度

Agent 会在每条回复末尾附上 Context 健康状态：
- 🟢 **Healthy**：< 15 轮对话，正常
- 🟡 **Warn**：15-25 轮，开始注意
- 🔴 **Critical**：> 25 轮，应该换新会话

---

## 黄金法则

1. **不要把临时文件放在 `/tmp/`** → 用 `.agents/tmp/`
2. **不要让 GEMINI.md 超过 200 行** → 细节放 Skills 和 Knowledge
3. **重复操作超过 3 次** → 考虑固化为 Skill
4. **超过 3 个文件的变更** → 走 Planning Mode
5. **Agent 说完成后** → 用 `验收` 检查一下

---

## 遇到问题？

1. Agent 行为异常 → 检查 `~/.gemini/GEMINI.md` 是否正确
2. Skill 不触发 → 确认 `description` 字段包含触发关键词
3. 会话太长变慢 → 执行 `开新局`
4. 想了解更多 → 阅读 `ANTIGRAVITY_BEST_PRACTICES.md`（完整手册，641+ 行）

---

> **维护者**：峰哥团队 | **最后更新**：2026-04-04
