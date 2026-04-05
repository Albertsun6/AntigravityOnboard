# Antigravity 团队接入指南

跟着以下 3 步，为你的电脑配置团队 AI 协作环境。

---

## Step 1. 安装 Antigravity IDE

**下载地址：** [https://antigravity.google.com/download](https://antigravity.google.com/download)

| 系统 | 安装方式 |
| --- | --- |
| 🍎 macOS | 双击 `.dmg`，拖入 `应用程序` 文件夹 |
| 🪟 Windows | 双击 `.exe`，按提示完成安装 |

---

## Step 2. 登录 Google 账号

1. 打开 Antigravity IDE
2. 点击左下角 **账户图标** → **Sign in with Google**
3. 使用 **团队 Google 工作账号** 登录授权
4. 返回 IDE，右侧出现对话框即表示登录成功

> [!TIP]
> 登录受阻？确认你的 Google 账号已被开通 Antigravity 权限，否则联系管理员。

---

## Step 3. 一键初始化

1. 在桌面（或任意位置）**新建一个空文件夹**，命名随意（如 `MyWorkspace`）
2. 在 IDE 左上角点击 **File → Open Folder**，打开这个空文件夹
3. 在右侧对话框中 **复制粘贴** 以下内容并发送：

```text
请帮我初始化团队项目：git clone https://github.com/Albertsun6/AntigravityOnboard.git ./
```

4. **等待 AI 完成全部配置**（约 30 秒），你会看到：
   - ✅ 项目代码拉取
   - ✅ 沙盒环境创建
   - ✅ AI 协作规则部署
   - ✅ 环境验证报告
   - ✅ 欢迎消息

5. **AI 会问你两个问题**：你希望被叫什么 & 偏好输出什么语言。回答后即完全就绪。

> [!WARNING]
> 文件夹必须为 **空**。如果文件夹内有其他文件，clone 会失败。

---

## 常用指令速查

| 指令 | 用途 | 示例场景 |
| --- | --- | --- |
| `直接做` | 跳过规划，立即执行 | 小改动不想看计划书 |
| `验收` | 自动检查功能/UI/报错 | 改完代码想兜底 |
| `记住 <内容>` | 沉淀经验到知识库 | 排查到好思路想留存 |
| `开新局` | 重启对话并交接上下文 | 聊太久 AI 开始犯糊涂 |

> [!IMPORTANT]
> AI 按 Token 计费。省掉"请、谢谢、如果可以的话"，直接说需求和约束。

---

## 个性化配置

初始化完成后，你的 AI 行为规则存储在 `~/.gemini/GEMINI.md`。你可以随时修改：

- **称呼**：AI 叫你的名字
- **输出语言**：AI 回复使用的语言
- **人格风格**：极客、零寒暄、有观点（默认团队风格）

直接用文本编辑器打开 `~/.gemini/GEMINI.md` 修改即可，下次新会话自动生效。
