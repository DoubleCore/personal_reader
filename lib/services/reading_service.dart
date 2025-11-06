import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingService {
  static const String _progressKey = 'reading_progress_';
  static const String _fontSizeKey = 'font_size';
  static const String _darkModeKey = 'dark_mode';

  // 保存阅读进度
  static Future<void> saveProgress(String bookId, double progress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('$_progressKey$bookId', progress);
    } catch (e) {
      print('保存进度失败: $e');
    }
  }

  // 获取阅读进度
  static Future<double> getProgress(String bookId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble('$_progressKey$bookId') ?? 0.0;
    } catch (e) {
      print('获取进度失败: $e');
      return 0.0;
    }
  }

  // 保存字体大小
  static Future<void> saveFontSize(double fontSize) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_fontSizeKey, fontSize);
    } catch (e) {
      print('保存字体大小失败: $e');
    }
  }

  // 获取字体大小
  static Future<double> getFontSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_fontSizeKey) ?? 16.0;
    } catch (e) {
      print('获取字体大小失败: $e');
      return 16.0;
    }
  }

  // 保存主题设置
  static Future<void> saveDarkMode(bool isDark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, isDark);
    } catch (e) {
      print('保存主题设置失败: $e');
    }
  }

  // 获取主题设置
  static Future<bool> getDarkMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_darkModeKey) ?? false;
    } catch (e) {
      print('获取主题设置失败: $e');
      return false;
    }
  }

  // 加载书籍内容
  static Future<String> loadBookContent(String filePath) async {
    try {
      return await rootBundle.loadString(filePath);
    } catch (e) {
      print('加载书籍内容失败: $e');
      return '# 加载失败\n\n无法加载书籍内容，请检查文件路径。\n\n错误信息：$e';
    }
  }
}