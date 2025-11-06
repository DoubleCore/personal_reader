<!-- 540e73e4-8f23-4164-baed-22bbfd45ae54 aadb72f6-6894-4d7b-81b3-a6bac298253e -->
# 在 Windows 上用 SJTU 镜像安装 Flutter（含 Android/Web/Windows）

## 前置准备

- 安装 Git（从官网下载或 winget）。
- 确保已安装 Chrome（用于 Web）。

## 1) 配置 SJTU 镜像（临时与永久）

- 临时环境变量（当前 PowerShell 会话）：
- `$env:PUB_HOSTED_URL = "https://mirror.sjtu.edu.cn/dart-pub"`
- `$env:FLUTTER_STORAGE_BASE_URL = "https://mirror.sjtu.edu.cn"`
- 永久环境变量（用户级）：
- `PUB_HOSTED_URL = https://mirror.sjtu.edu.cn/dart-pub`
- `FLUTTER_STORAGE_BASE_URL = https://mirror.sjtu.edu.cn`

## 2) 下载并安装 Flutter SDK

- 在浏览器用 SJTU 镜像下载稳定版 zip：
- 例：将 `https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.6-stable.zip`
改为 `https://mirror.sjtu.edu.cn/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.6-stable.zip`
- 解压至安装目录（示例：`E:\dev\flutter`）。
- 将 `E:\dev\flutter\bin` 加入用户 Path。

## 3) 验证基础安装

- 新开 PowerShell：`flutter doctor -v`

## 4) 配置 Android 开发环境

- 安装 Android Studio（含 SDK Manager）。
- 在 SDK Manager 勾选并安装：
- Android SDK Platform（推荐 Android 14/15 至少一个）
- Android SDK Build-Tools（匹配版本）
- Android SDK Command-line Tools (latest)
- Android Emulator（可选）
- 接受许可：`flutter doctor --android-licenses`
- 若需设备：创建 Android 虚拟机（AVD）或连接真机。

## 5) 配置 Web 支持

- `flutter config --enable-web`
- `flutter doctor -v` 确认 Chrome/Web OK。

## 6) 配置 Windows 桌面支持

- 安装 Visual Studio 2022（社区版即可），选择工作负载：
- Desktop development with C++
- 确保包含 MSVC v143 工具集与 Windows 10/11 SDK
- `flutter doctor -v` 确认 Windows 桌面 OK。

## 7) 创建并验证示例项目

- `flutter create hello_sjtu`
- `cd hello_sjtu`
- 运行：
- Android：`flutter run -d emulator-5554`（或选择设备）
- Web：`flutter run -d chrome`
- Windows：`flutter run -d windows`

## 8) 常见问题与切换发布

- 若发布到 pub.dev：确保未设置（或清空）`PUB_HOSTED_URL`；网络需可访问 Google 账号登录与 pub.dev。
- 若国内拉取依赖慢：确认两镜像环境变量已生效；重新打开终端。

### To-dos

- [ ] 设置 SJTU 镜像（临时与永久环境变量）
- [ ] 下载并解压 Flutter SDK，配置 PATH
- [ ] 运行 flutter doctor 验证基础安装
- [x] 安装 Android Studio 与 SDK 组件并接受许可
- [ ] 启用 Web 支持并验证
- [x] 安装 VS2022 C++ 工作负载并验证 Windows 桌面
- [ ] 创建示例项目并在 Android/Web/Windows 运行
- [ ] 了解发布到 pub.dev 的镜像变量注意事项