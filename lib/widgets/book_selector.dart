import 'package:flutter/material.dart';
import '../models/book.dart';

class BookSelector extends StatelessWidget {
  final Book currentBook;
  final Function(Book) onBookChanged;

  const BookSelector({
    super.key,
    required this.currentBook,
    required this.onBookChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.menu_book,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<Book>(
              value: currentBook,
              isExpanded: true,
              underline: const SizedBox(), // 移除下划线
              items: Book.allBooks.map((book) {
                return DropdownMenuItem<Book>(
                  value: book,
                  child: Text(
                    book.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (Book? newBook) {
                if (newBook != null) {
                  onBookChanged(newBook);
                }
              },
              selectedItemBuilder: (BuildContext context) {
                return Book.allBooks.map((book) {
                  return DropdownMenuItem<Book>(
                    value: book,
                    child: Text(
                      book.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  );
                }).toList();
              },
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}