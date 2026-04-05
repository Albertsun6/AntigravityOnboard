---
description: 团队成员 Onboarding 一键配置流程。用于新成员快速接入 Antigravity 协作体系。
---

# /onboard — 团队成员 Onboarding Workflow

> 为新团队成员一键配置 Antigravity 协作环境，确保 GEMINI.md / Skills / MCP / 心跳 全链路就绪。

## 前置条件
- 新成员已安装 Google Antigravity IDE
- 已 clone 项目仓库到本地
- 有 `~/.gemini/` 目录写入权限

---

## Step 1: 环境探测

检查新成员环境现状：

```bash
echo "=== Antigravity Onboarding Probe ==="
echo "1. Global GEMINI.md:" && ls -la ~/.gemini/GEMINI.md 2>/dev/null || echo "   ❌ 不存在"
echo "2. Project GEMINI.md:" && ls -la GEMINI.md 2>/dev/null || echo "   ⚠️ 不存在（可选）"
echo "3. Skills 目录:" && ls .agents/skills/ 2>/dev/null || echo "   ❌ 不存在"
echo "4. MCP 配置:" && ls ~/.gemini/antigravity/mcp_config.json 2>/dev/null || echo "   ⚠️ 不存在"
echo "5. .agents/tmp/:" && ls -d .agents/tmp/ 2>/dev/null || echo "   ❌ 不存在"
```

// turbo

## Step 2: 全局 GEMINI.md 配置

检查 `~/.gemini/GEMINI.md` 是否存在：
- **不存在** → 从 `.agents/templates/GEMINI_TEAM.md` 复制过去
- **已存在** → 跳过（提示用户手动对比合并）

```bash
if [ ! -f ~/.gemini/GEMINI.md ]; then
  cp .agents/templates/GEMINI_TEAM.md ~/.gemini/GEMINI.md
  echo "✅ 已创建全局 GEMINI.md"
else
  echo "⚠️ 全局 GEMINI.md 已存在，请手动对比 .agents/templates/GEMINI_TEAM.md"
fi
```

## Step 3: 目录结构确认

确保核心目录存在：

```bash
mkdir -p .agents/tmp .agents/docs/metrics
echo "✅ 目录结构已就绪"
```

// turbo

## Step 4: MCP 配置检查

检查 MCP 配置文件：
- 如果不存在 → 提醒用户配置
- 如果存在 → 列出已配置的 Server

```bash
if [ -f ~/.gemini/antigravity/mcp_config.json ]; then
  echo "✅ MCP 配置已找到，已配置 Server:"
  python3 -c "import json; [print(f'  - {k}') for k in json.load(open('$HOME/.gemini/antigravity/mcp_config.json')).get('mcpServers', {})]" 2>/dev/null || echo "  ⚠️ 解析失败"
else
  echo "⚠️ MCP 配置不存在，如需 PDF 阅读等功能请配置 ~/.gemini/antigravity/mcp_config.json"
fi
```

## Step 5: 知识库初始化

确认 Knowledge 目录可访问：

```bash
mkdir -p ~/.gemini/antigravity/knowledge
echo "✅ Knowledge 目录已就绪"
ls ~/.gemini/antigravity/knowledge/ 2>/dev/null | head -5
```

// turbo

## Step 6: 首次心跳

运行首次心跳巡逻验证全链路：

```
触发 /heartbeat 命令
```

⚠️ 首次心跳会强制执行（因为 HEARTBEAT_STATE.json 中 last_heartbeat 为 null）。

## Step 7: 验证总结

运行 `onboard-verify` Skill 进行最终验证，输出 Onboarding 报告。

---

## 完成标准

| 检查项 | 说明 |
|---|---|
| ✅ 全局 GEMINI.md | 存在且 < 200 行 |
| ✅ Skills 加载 | 至少 3 个 Skill 可被发现 |
| ✅ 目录结构 | `.agents/tmp/` 和 `.agents/docs/` 存在 |
| ✅ 心跳通过 | 首次 `/heartbeat` 结果为 💚 或 💛 |
| ✅ 了解命令 | 新成员知道 `直接做/验收/开新局` 等核心命令 |
