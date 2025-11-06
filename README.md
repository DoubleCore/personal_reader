# Personal Reader - 极简个人MD阅读器

一个专为个人使用设计的简洁Markdown阅读器，**无需数据库，无需导入功能**。

## 🎯 设计理念

- **零配置**：书籍直接硬编码在应用中
- **极简操作**：打开即读，无复杂功能
- **专注阅读**：提供沉浸式阅读体验
- **个人专用**：针对单用户优化

## 📚 内置书籍

应用已预置3本技术书籍：

1. **编程原则与实践** - 软件开发核心原则
2. **系统设计基础** - 大型系统架构指南
3. **算法与数据结构精要** - 编程基础知识

## ✨ 核心功能

### 📖 阅读体验
- **Markdown渲染**：完美支持MD语法
- **字体调节**：12-24px可调节字体大小
- **主题切换**：亮色/暗色主题
- **进度保存**：自动保存阅读位置

### 🎛️ 简洁操作
- **书籍切换**：顶部下拉菜单快速切换
- **返回顶部**：一键返回文章开头
- **浮动设置**：点击设置按钮弹出调节面板
- **进度显示**：实时显示阅读进度百分比

## 🚀 使用方法

### 1. 安装依赖
```bash
cd personal_reader
flutter pub get
```

### 2. 运行应用
```bash
flutter run
```

### 3. 添加新书籍
如需添加新书籍：

1. 将 `.md` 文件放入 `assets/books/` 目录
2. 在 `lib/models/book.dart` 的 `allBooks` 列表中添加书籍信息：

```dart
static const List<Book> allBooks = [
  // 现有书籍...
  Book(
    id: 'new_book',
    title: '新书标题',
    filePath: 'assets/books/new_book.md',
  ),
];
```

## 📁 项目结构

```
personal_reader/
├── lib/
│   ├── models/
│   │   └── book.dart              # 硬编码书籍列表
│   ├── services/
│   │   └── reading_service.dart   # 阅读进度和设置
│   ├── screens/
│   │   └── reader_screen.dart     # 主阅读界面
│   ├── widgets/
│   │   ├── book_selector.dart     # 书籍选择器
│   │   └── markdown_viewer.dart   # MD渲染组件
│   └── main.dart                  # 应用入口
├── assets/books/                  # MD文件目录
└── pubspec.yaml                   # 依赖配置
```

## 🎨 界面设计

### 主界面布局
- **顶部**：书籍选择下拉菜单
- **主体**：Markdown内容渲染区域
- **右侧**：浮动按钮组（设置、返回顶部）
- **设置面板**：点击设置按钮弹出

### 交互特性
- **自动保存**：滚动时自动保存阅读进度（每10%保存一次）
- **平滑滚动**：切换书籍时平滑滚动到上次阅读位置
- **响应式设计**：适配不同屏幕尺寸
- **Material Design 3**：现代化UI设计

## ⚙️ 技术实现

### 零数据库设计
- **书籍列表**：硬编码在 `Book` 类中
- **阅读进度**：使用 `SharedPreferences` 存储
- **用户设置**：字体大小、主题偏好也用 SharedPreferences

### 核心依赖
- `flutter_markdown`: Markdown渲染
- `shared_preferences`: 轻量级本地存储
- `cupertino_icons`: iOS风格图标

### 性能优化
- **懒加载**：按需加载书籍内容
- **智能保存**：避免频繁的进度保存操作
- **内存管理**：合理的Widget生命周期管理

## 🎯 使用场景

这个阅读器适合以下场景：

- **个人技术文档阅读**
- **学习笔记管理**
- **参考资料查阅**
- **便携式知识库**

## 🔧 自定义配置

### 修改默认设置
在 `lib/services/reading_service.dart` 中可以修改：

```dart
// 默认字体大小
return prefs.getDouble(_fontSizeKey) ?? 16.0;

// 默认主题
return prefs.getBool(_darkModeKey) ?? false;
```

### 自定义MD样式
在 `lib/widgets/markdown_viewer.dart` 中可以自定义Markdown渲染样式。

## 📱 平台支持

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Desktop (Windows, macOS, Linux)

## 🚀 快速开始

1. **克隆或下载项目**
2. **运行 `flutter pub get`**
3. **运行 `flutter run`**
4. **开始阅读！**

---

### 极简设计，专注阅读 📖✨

这是一个真正的个人阅读器，没有多余的功能，只有纯粹的阅读体验。