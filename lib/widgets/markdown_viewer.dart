import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownViewer extends StatefulWidget {
  final String content;
  final double fontSize;
  final ScrollController? scrollController;
  final Function(double)? onScroll;

  const MarkdownViewer({
    super.key,
    required this.content,
    this.fontSize = 16.0,
    this.scrollController,
    this.onScroll,
  });

  @override
  State<MarkdownViewer> createState() => _MarkdownViewerState();
}

class _MarkdownViewerState extends State<MarkdownViewer> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.scrollController ?? ScrollController();
    _controller.addListener(_handleScroll);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleScroll);
    }
    super.dispose();
  }

  void _handleScroll() {
    if (_controller.hasClients && widget.onScroll != null) {
      final maxScroll = _controller.position.maxScrollExtent;
      final currentScroll = _controller.offset;
      final progress = maxScroll > 0 ? currentScroll / maxScroll : 0.0;
      widget.onScroll!(progress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Markdown(
      controller: _controller,
      data: widget.content,
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        // 段落样式
        p: TextStyle(
          fontSize: widget.fontSize,
          height: 1.6,
          color: isDark ? Colors.white70 : Colors.black87,
        ),

        // 标题样式
        h1: TextStyle(
          fontSize: widget.fontSize + 10,
          fontWeight: FontWeight.bold,
          height: 1.3,
          color: isDark ? Colors.white : Colors.black87,
        ),
        h2: TextStyle(
          fontSize: widget.fontSize + 8,
          fontWeight: FontWeight.bold,
          height: 1.3,
          color: isDark ? Colors.white : Colors.black87,
        ),
        h3: TextStyle(
          fontSize: widget.fontSize + 6,
          fontWeight: FontWeight.bold,
          height: 1.3,
          color: isDark ? Colors.white : Colors.black87,
        ),
        h4: TextStyle(
          fontSize: widget.fontSize + 4,
          fontWeight: FontWeight.bold,
          height: 1.3,
          color: isDark ? Colors.white : Colors.black87,
        ),
        h5: TextStyle(
          fontSize: widget.fontSize + 2,
          fontWeight: FontWeight.bold,
          height: 1.3,
          color: isDark ? Colors.white : Colors.black87,
        ),
        h6: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
          height: 1.3,
          color: isDark ? Colors.white : Colors.black87,
        ),

        // 代码样式
        code: TextStyle(
          fontSize: widget.fontSize - 2,
          backgroundColor: isDark ? Colors.grey[700] : Colors.grey[200],
          fontFamily: 'monospace',
        ),
        codeblockDecoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
          ),
        ),
        codeblockPadding: const EdgeInsets.all(12),

        // 引用样式
        blockquote: TextStyle(
          fontSize: widget.fontSize,
          fontStyle: FontStyle.italic,
          color: isDark ? Colors.white60 : Colors.black54,
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 4,
            ),
          ),
        ),
        blockquotePadding: const EdgeInsets.only(left: 16),

        // 列表样式
        listBullet: TextStyle(
          fontSize: widget.fontSize,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        listIndent: 32,

        // 表格样式
        tableHead: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
        ),
        tableBody: TextStyle(
          fontSize: widget.fontSize,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        tableBorder: TableBorder.all(
          color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
          width: 1,
        ),
        tableCellsPadding: const EdgeInsets.all(8),
        tableColumnWidth: const FlexColumnWidth(),

        // 水平分割线
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
              width: 1,
            ),
          ),
        ),

        // 链接样式
        a: TextStyle(
          color: Theme.of(context).primaryColor,
          decoration: TextDecoration.underline,
        ),

        // 强调文本
        em: TextStyle(
          fontSize: widget.fontSize,
          fontStyle: FontStyle.italic,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        strong: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
        ),

        // 删除线
        del: TextStyle(
          fontSize: widget.fontSize,
          decoration: TextDecoration.lineThrough,
          color: isDark ? Colors.white60 : Colors.black54,
        ),
      ),
    );
  }
}