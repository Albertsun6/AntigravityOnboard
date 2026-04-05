---
name: onboard-verify
description: 团队 Onboarding 验证引擎。检查新成员的 GEMINI.md/Skills/MCP/心跳配置完整性，确保 Antigravity 协作环境全链路就绪。
---

# Instructions

## 核心触发点

当以下任一条件满足时触发：
1. `/onboard` Workflow 的 Step 7 中调用
2. 用户说 "验证 onboarding" 或 "检查配置"

## 前置检查

确认当前在项目根目录（`.agents/` 目录存在）。

## 标准行动模式

### Step 1: 执行验证矩阵

逐项检查以下清单并标记结果：

| # | 检查项 | 验证方式 | 通过标准 |
|---|---|---|---|
| 1 | 全局 GEMINI.md 存在 | `ls ~/.gemini/GEMINI.md` | 文件存在 |
| 2 | GEMINI.md 行数 | `wc -l ~/.gemini/GEMINI.md` | ≤ 200 行 |
| 3 | Skills 目录非空 | `ls .agents/skills/` | ≥ 3 个 Skill |
| 4 | Skill descriptions 无冲突 | 遍历 SKILL.md frontmatter | 无重复 |
| 5 | `.agents/tmp/` 存在 | `ls -d .agents/tmp/` | 目录存在 |
| 6 | `.agents/workflows/` 非空 | `ls .agents/workflows/` | ≥ 1 个 Workflow |
| 7 | HEARTBEAT.md 存在 | `ls .agents/HEARTBEAT.md` | 文件存在 |
| 8 | HEARTBEAT_STATE.json 存在 | `ls .agents/HEARTBEAT_STATE.json` | 文件存在 |
| 9 | MCP 配置（可选） | `ls ~/.gemini/antigravity/mcp_config.json` | 存在或标注可选 |
| 10 | Knowledge 目录 | `ls ~/.gemini/antigravity/knowledge/` | 目录存在 |

### Step 2: 生成验证报告

```markdown
## 🎯 Onboarding 验证报告

**时间**：<日期时间>
**总评**：✅ 通过 / ⚠️ 部分通过 / ❌ 未通过

| # | 检查项 | 结果 | 备注 |
|---|---|---|---|
| 1 | 全局 GEMINI.md | ✅/❌ | ... |
| 2 | GEMINI.md 行数 | ✅/⚠️ | XX 行 |
| ... | ... | ... | ... |

**通过项**: X/10
**待修复项**:
- ...

**建议下一步**:
- ...
```

### Step 3: 如有失败项，提供修复指引

对每个 ❌ 项，提供 1-2 行具体修复命令或操作说明。

## 约束边界（Harness: Constrain）

- ✅ 此 Skill 允许：
  - 读取文件和目录结构
  - 执行只读检查命令
  - 输出验证报告

- 🚫 此 Skill 禁止：
  - 自动修复任何配置问题
  - 修改用户的 GEMINI.md
  - 创建或删除文件

- ⚠️ 需人工审批：
  - 建议修复操作（仅输出建议，不自动执行）

## 输出规范

- 产出格式：Markdown 验证报告（嵌入聊天回复）
- 持久化位置：无（一次性报告）
- 回显确认：**是** — 必须向用户展示完整验证结果
