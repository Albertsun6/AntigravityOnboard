---
description: 团队成员 Onboarding 一键配置。由用户提示词中的 clone 意图直接触发。
---

# /onboard — 团队一键挂载工作流

> **触发方式**：用户发送含 "初始化团队项目" + clone 的提示词，AI 识别意图后：
> 1. 执行 `git clone <url> ./`
> 2. 直接执行本 Workflow
>
> **前提**：当前打开的是空文件夹。

## Step 1: 沙盒目录建立

// turbo

```bash
mkdir -p .agents/tmp .agents/docs/metrics
echo "✅ 沙盒目录就绪"
```

## Step 2: 全局 Soul Rules 部署

检测 `~/.gemini/GEMINI.md` 是否已有 Soul 内容（IDE 安装后会生成空文件，所以检查内容而非存在性）：

```bash
if ! grep -q 'Antigravity OS Kernel' ~/.gemini/GEMINI.md 2>/dev/null; then
  cp .agents/templates/global_rules_template_generic.md ~/.gemini/GEMINI.md
  echo "✅ 全局 Soul Rules 已部署至 ~/.gemini/GEMINI.md"
  echo "⏳ 接下来请回答两个问题以个性化配置..."
else
  echo "⏭️ ~/.gemini/GEMINI.md 已有 Soul 配置，跳过部署"
fi
```

**如果部署了新模板**，Agent 须立即向用户提问并执行替换：

1. 问用户："你希望 AI 叫你什么？（如：小明、Boss、峰哥）"
2. 问用户："偏好 AI 输出什么语言？（如：中文、English、日本語）"
3. 执行替换：
```bash
sed -i '' "s/{{YOUR_NAME}}/用户回答1/g" ~/.gemini/GEMINI.md
sed -i '' "s/{{LANGUAGE}}/用户回答2/g" ~/.gemini/GEMINI.md
echo "✅ 个性化配置完成"
```

## Step 3: 环境探测

```bash
# MCP 配置
[ -f ~/.gemini/antigravity/mcp_config.json ] \
  && echo "✅ MCP 配置就绪" \
  || echo "ℹ️ 未发现 MCP 配置，纯开发场景可忽略"

# Voice Hook 脚本
[ -f ~/.gemini/antigravity/scripts/notify_done.sh ] \
  && echo "✅ 语音通知脚本就绪" \
  || echo "ℹ️ 未发现 notify_done.sh，语音播报功能不可用"

# Knowledge 目录
mkdir -p ~/.gemini/antigravity/knowledge
echo "✅ Knowledge 目录挂载"
```

## Step 4: 工作区封签

// turbo

```bash
echo '{"last_heartbeat":"'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'","last_result":"healthy","issues_found":0,"total_runs":1,"history":["Init via /onboard"]}' > .agents/HEARTBEAT_STATE.json
echo "✅ 封签完毕"
```

## Step 5: 自动验证 + 欢迎词

执行验证矩阵，确认环境完整性：

```bash
PASS=0
TOTAL=0

check() {
  TOTAL=$((TOTAL + 1))
  if eval "$2" > /dev/null 2>&1; then
    echo "✅ $1"
    PASS=$((PASS + 1))
  else
    echo "❌ $1"
  fi
}

check "全局 GEMINI.md 有 Soul 内容" "grep -q 'Antigravity OS Kernel' ~/.gemini/GEMINI.md"
check "占位符已替换" "! grep -q '{{YOUR_NAME}}' ~/.gemini/GEMINI.md"
check "Skills 目录非空" "ls .agents/skills/ | head -1"
check ".agents/tmp/ 存在" "test -d .agents/tmp/"
check "Workflows 非空" "ls .agents/workflows/ | head -1"
check "HEARTBEAT.md 存在" "test -f .agents/HEARTBEAT.md"
check "HEARTBEAT_STATE.json 存在" "test -f .agents/HEARTBEAT_STATE.json"
check "Knowledge 目录存在" "test -d ~/.gemini/antigravity/knowledge/"

echo ""
echo "📊 验证结果: $PASS/$TOTAL 项通过"
```

验证完成后输出欢迎消息：

```markdown
🎉 **欢迎加入 Antigravity 团队！** 环境已全部就绪。

| 指令 | 效果 |
|---|---|
| `直接做` | 跳过确认立即执行 |
| `验收` | 5 项检查清单 |
| `记住 <内容>` | 持久化到知识库 |
| `开新局` | 标准化换会话 |

💡 **Tips**：
- 省掉客套话直接说需求
- 个性化配置在 `~/.gemini/GEMINI.md`，随时可改

输入你的第一个需求 👇
```
