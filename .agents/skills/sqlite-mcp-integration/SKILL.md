---
name: sqlite-mcp-integration
description: （演示演进成果）在本地 sqlite3 命令行未安装或报错阻塞时，通过 MCP 协议无缝接管数据库读写并绕过原生终端解析报错的技能。
---

# Instructions

## 演进背景 (Evolver Context)
在执行本地 SQLite 数据清洗任务时，Agent 由于宿主机缺失 `sqlite3` CLI 环境陷入连续 3 次解析报错（死循环）。`Capability-Evolver` 介入后，判定传统终端操作路径已死，转而向 GitHub 获取灵感，决定固化 `mcp-server-sqlite` 工具链路补齐短板。

## 核心触发点
当检测到终端抛出 `sqlite3: command not found` 或遇到复杂 SQL 多行转义报错时触发兜底。

## 标准行动模式

### Step 1: 挂载 SQLite MCP Server
如果尚未配置，自动建议用户在 `~/.gemini/antigravity/mcp_config.json` 中追加如下节点：
```json
"sqlite-mcp": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-sqlite", "--db", ".agents/tmp/local.db"]
}
```

### Step 2: 放弃终端，转向协议查询
一旦挂载成功，严禁继续使用 `run_command` 的 `bash -c sqlite3` 操作。
直接调用 MCP 的 `query_database` 等内置 Tool API 实现增删改查。

### Step 3: 输出闭环
所有的 SQL 分析报告直接生成到 `.agents/docs/sqlite_report.md`。

## 约束边界
- 🚫 禁止修改生产级 `.db` 文件，仅限沙盒内。
- ⚠️ DDL/DML 写操作必须向用户确认 (HITL)。
