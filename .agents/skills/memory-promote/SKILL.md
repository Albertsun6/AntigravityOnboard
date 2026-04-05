---
name: memory-promote
description: 记忆晋升引擎。扫描近期会话 walkthrough 提取可复用模式，自动提议创建或合并 Knowledge 条目，实现会话经验到长期记忆的晋升。
---

# Instructions

## 核心触发点

当以下任一条件满足时触发：
1. **心跳巡逻中调用**：`heartbeat-patrol` 执行到「记忆晋升巡逻」项时委托本 Skill
2. **手动触发**：用户说 "记忆晋升" 或 "晋升检查"
3. **会话结束前**：用户说 `开新局` 时，可选触发快速晋升扫描

## 前置检查

1. 读取 `.agents/PROMOTE_STATE.json`
2. 列出 `~/.gemini/antigravity/brain/` 下所有会话目录
3. 对比 `sessions_scanned` 列表，过滤出未扫描的会话
4. 如果无新会话可扫描 → 输出 "📚 无新增会话需要晋升" → 退出

## 标准行动模式

### Step 1: 增量扫描

基于**数据增量**而非时间窗口进行扫描：
- 读取 `PROMOTE_STATE.json` 中的 `sessions_scanned` 列表
- 遍历 `brain/` 目录，找出 **未曾扫描过的** 会话 ID
- 对每个未扫描会话，读取其 `walkthrough.md`（如存在）

> **增量原则**：只处理上次扫描后新增的数据，不重复处理已扫描的会话。

### Step 2: 模式提取

对每个 walkthrough 内容进行分析，提取：
- **可复用模式**：通用的解决方案、架构决策、工作流优化
- **踩坑教训**：错误排查路径、避坑策略
- **最佳实践**：被验证有效的操作方式
- **工具发现**：新的 MCP Server、Shell 技巧、API 用法

输出格式：
```markdown
## 晋升候选项

### 候选 1: [模式标题]
- **来源会话**: <conv-id>
- **核心内容**: <1-3 句话摘要>
- **建议 Knowledge 路径**: `knowledge/<topic_name>/`
- **操作**: 创建新条目 / 合并到 `knowledge/<existing>/`
```

### Step 3: 去重对比

- 遍历现有 `~/.gemini/antigravity/knowledge/` 条目
- 读取每个条目的 `metadata.json`（title, description）
- 与候选项进行语义对比
- 标记：**新建** / **合并** / **跳过（已存在）**

### Step 4: 人工确认

> [!IMPORTANT]
> 所有写操作必须经过用户确认（HITL）。

向用户展示晋升提议清单：
```markdown
## 📚 记忆晋升提议

| # | 操作 | 标题 | 来源 | 目标路径 |
|---|---|---|---|---|
| 1 | 🆕 新建 | ... | conv-xxx | knowledge/new_topic/ |
| 2 | 🔄 合并 | ... | conv-yyy | knowledge/existing/ |
| 3 | ⏭️ 跳过 | ... | conv-zzz | 已存在 |

确认晋升？(y/n/选择性执行)
```

### Step 5: 执行晋升

用户确认后：
- **新建**：创建 `knowledge/<topic>/` 目录 + `metadata.json` + `artifacts/<content>.md`
- **合并**：追加内容到现有 Knowledge 条目的 artifacts
- 更新 `PROMOTE_STATE.json`

### Step 6: 更新状态

```json
{
  "last_promote": "<当前ISO时间>",
  "sessions_scanned": ["<追加新扫描的conv-id>"],
  "items_promoted": <累加>,
  "items_merged": <累加>
}
```

## 约束边界（Harness: Constrain）

- ✅ 此 Skill 允许：
  - 读取 `brain/` 下所有会话 Artifacts
  - 读取 `knowledge/` 下所有条目 metadata
  - 更新 `PROMOTE_STATE.json`

- 🚫 此 Skill 禁止：
  - 未经确认直接创建/修改 Knowledge 条目
  - 删除任何会话 Artifacts
  - 删除任何 Knowledge 条目
  - 修改 GEMINI.md 或 SKILL.md

- ⚠️ 需人工审批：
  - 创建新 Knowledge 条目
  - 合并更新既有 Knowledge 条目
  - 跳过标记为"可能有价值"的候选项

## 输出规范

- 产出格式：Markdown 晋升提议表 + 执行报告
- 持久化位置：`PROMOTE_STATE.json`（状态）+ `knowledge/`（晋升内容）
- 回显确认：**是** — 必须展示完整晋升提议供用户审批
