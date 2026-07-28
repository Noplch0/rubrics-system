# Rubrics 评判系统

一个纯前端评审工具，用于将需求 Prompt 转换为可验证的 Rubrics，并在同一页面中打开多个目标网页进行逐项评分。

## 在线使用

GitHub Pages：<https://noplch0.github.io/rubrics-system/>

> API Key 只保存在当前浏览器的 `localStorage` 中，并由浏览器直接发送到你配置的 API 地址。请勿在公共或不可信设备上保存密钥。

## 功能

- 调用 OpenAI Chat Completions 兼容接口或 Responses API 生成 Rubrics
- 配置并切换多组 API 预设
- 通过多个 URL 标签页查看待评审页面
- 逐项记录 Rubric 的通过状态、说明和评分结果
- 使用浏览器 `localStorage` 保存 AI 设置与当前工作区内容

## 本地运行要求

- Windows
- Python 3，可使用 `python` 或 `py` 命令
- 支持直接从浏览器调用的 OpenAI 兼容 API

## 本地启动

双击 `start-website.bat`，然后访问：

```text
http://127.0.0.1:8080/
```

命令行启动方式：

```powershell
python -m http.server 8080 --bind 0.0.0.0 --directory .
```

使用期间请保持服务器窗口运行。启动脚本会同时显示局域网访问地址。

## AI 配置

在页面右上角打开 AI 设置，填写：

- API Key
- API 接口地址
- API 类型
- 模型名称
- System Prompt

页面支持 OpenAI 兼容的 Chat Completions 格式和 Responses API 格式。API Key 保存在当前浏览器的 `localStorage` 中，并由浏览器直接发送到配置的接口，请仅在可信设备和可信接口上使用。若请求失败，请确认接口允许浏览器跨域访问。

## 使用提示词

[`prompt.md`](prompt.md) 提供了一套面向前端代码生成任务的 Prompt 准入规则与 Rubrics 编写规范。新用户首次打开页面时，该文件内容会自动作为默认 System Prompt；API Key、API 地址、API 类型、模型名称等配置均默认为空，需要用户自行填写。

模型应返回以下结构的 JSON：

```json
{
  "is_allow": true,
  "rubrics": ["分点1", "分点2", "分点3"],
  "reason": ""
}
```

## 开机自启

以 PowerShell 运行：

```powershell
.\install-autostart.ps1
```

该脚本会创建名为 `RubricSystemWebsiteServer` 的计划任务，在当前 Windows 用户登录时隐藏启动本地服务器。运行以下脚本可移除计划任务：

```powershell
.\uninstall-autostart.ps1
```

后台服务日志写入项目目录下的 `server.log`。

## 项目文件

- `index.html`：单页应用及全部前端逻辑
- `prompt.md`：Prompt 审核和 Rubrics 生成规范
- `start-website.bat`：前台启动本地服务器
- `start-website-hidden.ps1`：后台启动本地服务器并记录日志
- `install-autostart.ps1`：安装登录自启计划任务
- `uninstall-autostart.ps1`：移除登录自启计划任务