import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/reading_service.dart';
import '../widgets/book_selector.dart';
import '../widgets/markdown_viewer.dart';

class ReaderScreen extends StatefulWidget {
  final Book? initialBook;

  const ReaderScreen({super.key, this.initialBook});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  Book _currentBook;
  String _content = '';
  double _fontSize = 16.0;
  bool _isLoading = true;
  bool _showSettings = false;
  double _readingProgress = 0.0;
  final ScrollController _scrollController = ScrollController();

  _ReaderScreenState() : _currentBook = Book.defaultBook;

  @override
  void initState() {
    super.initState();
    _currentBook = widget.initialBook ?? Book.defaultBook;
    _loadSettings();
    _loadBookContent();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final fontSize = await ReadingService.getFontSize();
    setState(() {
      _fontSize = fontSize;
    });
  }

  Future<void> _loadBookContent() async {
    setState(() {
      _isLoading = true;
    });

    final content = await ReadingService.loadBookContent(_currentBook.filePath);
    final progress = await ReadingService.getProgress(_currentBook.id);

    setState(() {
      _content = content;
      _isLoading = false;
      _readingProgress = progress;
    });

    // 恢复阅读位置
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restoreReadingPosition();
    });
  }

  void _restoreReadingPosition() {
    if (_scrollController.hasClients && _readingProgress > 0) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      if (maxScroll > 0) {
        _scrollController.animateTo(
          maxScroll * _readingProgress,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _onBookChanged(Book newBook) {
    setState(() {
      _currentBook = newBook;
    });
    _loadBookContent();
  }

  void _onScroll(double progress) {
    _readingProgress = progress;
    // 每滚动10%保存一次进度
    if ((progress * 10).floor() > (_readingProgress * 10).floor() || progress >= 0.99) {
      ReadingService.saveProgress(_currentBook.id, progress);
    }
  }

  void _changeFontSize(double newFontSize) {
    setState(() {
      _fontSize = newFontSize;
    });
    ReadingService.saveFontSize(newFontSize);
  }

  void _toggleTheme() async {
    final currentTheme = Theme.of(context).brightness;
    final newDarkMode = currentTheme == Brightness.light;
    await ReadingService.saveDarkMode(newDarkMode);

    // 简单重启应用来应用主题
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  void _showProgressInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('阅读进度 - ${_currentBook.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${(_readingProgress * 100).toInt()}%'),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: _readingProgress),
            const SizedBox(height: 8),
            Text(
              '已阅读 ${(_readingProgress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 书籍选择器
          BookSelector(
            currentBook: _currentBook,
            onBookChanged: _onBookChanged,
          ),

          // 主内容区域
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(
                    children: [
                      // Markdown 内容
                      MarkdownViewer(
                        content: _content,
                        fontSize: _fontSize,
                        scrollController: _scrollController,
                        onScroll: _onScroll,
                      ),

                      // 设置面板
                      if (_showSettings)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: _buildSettingsPanel(),
                        ),
                    ],
                  ),
          ),
        ],
      ),

      // 右侧浮动按钮组
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 设置按钮
          FloatingActionButton(
            heroTag: "settings",
            mini: true,
            onPressed: () {
              setState(() {
                _showSettings = !_showSettings;
              });
            },
            child: Icon(
              _showSettings ? Icons.close : Icons.settings,
            ),
          ),
          const SizedBox(height: 8),

          // 返回顶部按钮
          FloatingActionButton(
            heroTag: "scrollTop",
            mini: true,
            onPressed: _scrollToTop,
            child: const Icon(Icons.keyboard_arrow_up),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsPanel() {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Row(
            children: [
              const Icon(Icons.tune),
              const SizedBox(width: 8),
              Text(
                '阅读设置',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 字体大小调节
          Text(
            '字体大小: ${_fontSize.toInt()}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Row(
            children: [
              IconButton(
                onPressed: _fontSize > 12
                    ? () => _changeFontSize(_fontSize - 2)
                    : null,
                icon: const Icon(Icons.zoom_out),
                iconSize: 20,
              ),
              Expanded(
                child: Slider(
                  value: _fontSize,
                  min: 12.0,
                  max: 24.0,
                  divisions: 6,
                  onChanged: _changeFontSize,
                ),
              ),
              IconButton(
                onPressed: _fontSize < 24
                    ? () => _changeFontSize(_fontSize + 2)
                    : null,
                icon: const Icon(Icons.zoom_in),
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 进度信息
          ListTile(
            dense: true,
            leading: const Icon(Icons.trending_up),
            title: const Text('阅读进度'),
            subtitle: Text('${(_readingProgress * 100).toInt()}%'),
            onTap: _showProgressInfo,
          ),
          const SizedBox(height: 8),

          // 主题切换
          ListTile(
            dense: true,
            leading: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            title: Text(
              Theme.of(context).brightness == Brightness.dark
                  ? '亮色主题'
                  : '深色主题',
            ),
            onTap: _toggleTheme,
          ),
        ],
      ),
    );
  }
}