---
name: claude-code-integration
description: 专门用于接管并协同 Anthropic 官方的 Claude Code 终端代理框架。能够对其专属的 `CLAUDE.md` 上下文机制进行操作。
---

# Instructions

## 核心触发点
当用户要求安装探讨 Claude Code CLI，或是需要协同/对接基于 Anthropic 官方的终端智能体架构工作流时触发。

## 标准行动模式（基于 2026 最新文档的反思引擎提炼）
1. **认知定义**：Claude Code 不是普通的网页版机器人，而是驻扎在命令行的底层 Agent (`claude` 命令)。它具备自运转能力，能在审批后自动修改代码并执行命令。
2. **上下文握手协议 (`CLAUDE.md`)**：如果 Antigravity 需要与 Claude Code 进行“多 Agent 并发协作”，必须通过在项目根目录读写 `CLAUDE.md` 来对其进行 System Prompt 注入或移交上下文（这是它唯一的全局持久化记忆中枢）。
3. **MCP 基建共享**：它天生原生支持 MCP Server 协议。在帮其配置扩展能力时，可以直接复用我们环境内的 awesome-mcp-servers 规范。
