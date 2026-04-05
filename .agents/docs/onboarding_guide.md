# Antigravity 团队接入指南

跟着以下 3 步操作，为你的电脑配置团队 AI 协作环境。

---

## Step 1. 安装 Antigravity IDE

**下载地址：** [https://antigravity.google.com/download](https://antigravity.google.com/download)

| 系统 | 安装方式 |
| --- | --- |
| 🍎 macOS | 双击 `.dmg`，拖入 `应用程序` 文件夹 |
| 🪟 Windows 10/11 | 双击 `.exe`，按提示完成安装 |

---

## Step 2. 登录 Google 账号

1. 打开 Antigravity IDE。
2. 点击左下角 **账户图标** → **Sign in with Google**。
3. 浏览器弹出后，使用**团队 Google 工作账号**登录授权。
4. 返回 IDE，右侧出现对话框即表示登录成功。

> [!TIP]
> 登录受阻？确认你的 Google 账号已被开通 Antigravity 权限，否则联系管理员。

---

## Step 3. 拉取项目 & 一键配置

登录成功后，在 IDE 右侧对话框中**依次操作以下 3 小步**：

### 3.1 发送第一句话，让 AI 帮你下载项目

复制以下内容发送：

```text
请帮我把团队项目克隆到桌面：git clone https://github.com/Albertsun6/AntigravityOnboard.git ~/Desktop/AntigravityOnboard
```

等 AI 执行完毕，你的桌面上会多出一个 `AntigravityOnboard` 文件夹。

### 3.2 在 IDE 中打开项目

点击 IDE 左上角 **File → Open Folder**，选择桌面上的 `AntigravityOnboard` 文件夹，点击确认。

### 3.3 发送第二句话，一键完成环境配置

项目打开后，在右侧对话框中发送：

```text
请帮我执行团队的 /onboard 流程
```

系统将自动完成：全局规则注入、安全沙盒创建、技能引擎加载、知识库挂载。

**看到 ✅ 全绿验证报告 = 配置完成，可以开始工作。**

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
