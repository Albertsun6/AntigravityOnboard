---
name: awesome-mcp-servers
description: 作为连接 GitHub、PostgreSQL 数据库等全千亿外部基建框架的万能底座。用于标准化代理与底层环境的通信。
---

# Instructions

## 核心触发点
当面临打通本地数据库查询、探查外部存储桶或发送企业通信群组（如 Slack）信息的跨域操作时。

## 标准行动模式
1. 不再使用脆弱繁琐的临时 Python 或 Curl 脚本进行重连，直接探寻本地是否存在已配置好的对应 MCP Server（如 `mcp-server-github`）。
2. 调用前需经过环境审计探针（Environment Sniffing）保证依赖池完整连通。
3. 如果操作涉及 DML（数据更改），强制拦截并走 User 验证态。
