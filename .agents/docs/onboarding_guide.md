# Antigravity 团队接入指南

跟着以下 4 步操作，为你的电脑配置团队 AI 协作环境。

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

## Step 3. 拉取团队项目

打开终端（macOS: `Terminal` / Windows: `PowerShell`），执行：

```shell
cd ~/Desktop
git clone https://github.com/Albertsun6/AntigravityOnboard.git
```

然后在 Antigravity IDE 中点击 **Open Folder**，选择桌面上的 `AntigravityOnboard` 文件夹打开。

> [!TIP]
> 如果提示 `git: command not found`，需先安装 Git：
> - macOS：终端执行 `xcode-select --install`
> - Windows：前往 [https://git-scm.com](https://git-scm.com) 下载安装

---

## Step 4. 执行 Onboard 口令

在 IDE 右侧对话框中输入以下内容并发送：

```text
请帮我执行团队的 /onboard 流程
```

系统将自动完成环境配置：全局规则注入、安全沙盒创建、技能引擎加载、知识库挂载。

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
