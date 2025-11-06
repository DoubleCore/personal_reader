import 'package:flutter/material.dart';
import '../main.dart';
import '../models/book.dart';
import '../services/reading_service.dart';
import '../widgets/book_selector.dart';
import '../widgets/markdown_viewer.dart';

class _TocItem {
  final String title;
  final int level;
  final int lineIndex;

  _TocItem({
    required this.title,
    required this.level,
    required this.lineIndex,
  });
}

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
  final ScrollController _tocScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<_TocItem> _tocItems = [];
  List<_TocItem> _filteredTocItems = [];

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
    _tocScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterTocItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTocItems = _tocItems;
      } else {
        _filteredTocItems = _tocItems
            .where((item) => item.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  List<_TocItem> _extractTableOfContents(String content) {
    final List<_TocItem> items = [];
    final lines = content.split('\n');
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.startsWith('#')) {
        int level = 0;
        int j = 0;
        while (j < line.length && line[j] == '#') {
          level++;
          j++;
        }
        
        if (level <= 6) {
          final title = line.substring(level).trim();
          if (title.isNotEmpty) {
            items.add(_TocItem(
              title: title,
              level: level,
              lineIndex: i,
            ));
          }
        }
      }
    }
    
    return items;
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
    final toc = _extractTableOfContents(content);

    setState(() {
      _content = content;
      _isLoading = false;
      _readingProgress = progress;
      _tocItems = toc;
      _filteredTocItems = toc;
      _searchController.clear();
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

  void _toggleTheme() {
    // 调用主应用的主题切换方法
    final appState = PersonalReader.of(context);
    if (appState != null) {
      appState.toggleTheme();
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
                : Row(
                    children: [
                      // 左侧目录栏
                      if (_tocItems.isNotEmpty)
                        Container(
                          width: 200,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              // 搜索框
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: '搜索目录',
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: _searchController.text.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(Icons.clear),
                                            onPressed: () {
                                              _searchController.clear();
                                              _filterTocItems('');
                                            },
                                          )
                                        : null,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  onChanged: _filterTocItems,
                                ),
                              ),
                              // 目录列表
                              Expanded(
                                child: _buildTableOfContents(),
                              ),
                            ],
                          ),
                        ),

                      // 右侧内容区域
                      Expanded(
                        child: Stack(
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

  Widget _buildTableOfContents() {
    final displayItems = _filteredTocItems.isEmpty ? _tocItems : _filteredTocItems;
    
    if (displayItems.isEmpty) {
      return const Center(
        child: Text('没有找到匹配的目录'),
      );
    }
    
    return ListView.builder(
      controller: _tocScrollController,
      itemCount: displayItems.length,
      itemBuilder: (context, index) {
        final item = displayItems[index];
        final indent = (item.level - 1) * 12.0;
        
        return Padding(
          padding: EdgeInsets.only(left: indent),
          child: ListTile(
            dense: true,
            title: Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: item.level == 1 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onTap: () {
              // 滚动到对应位置
              if (_scrollController.hasClients) {
                // 简单估算：每行大约50像素
                final offset = item.lineIndex * 50.0;
                _scrollController.animateTo(
                  offset,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        );
      },
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