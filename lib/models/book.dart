class Book {
  final String id;
  final String title;
  final String filePath;

  const Book({
    required this.id,
    required this.title,
    required this.filePath,
  });

  // 硬编码的书籍列表 - 无需数据库
  static const List<Book> allBooks = [
    Book(
      id: 'programming_principles',
      title: '编程原则与实践',
      filePath: 'assets/books/programming_principles.md',
    ),
    Book(
      id: 'system_design',
      title: '系统设计基础',
      filePath: 'assets/books/system_design.md',
    ),
    Book(
      id: 'algorithms',
      title: '算法与数据结构精要',
      filePath: 'assets/books/algorithms_and_data_structures.md',
    ),
  ];

  // 根据ID获取书籍
  static Book? findById(String id) {
    try {
      return allBooks.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }

  // 获取默认书籍（第一本）
  static Book get defaultBook => allBooks.first;
}