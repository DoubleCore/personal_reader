import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/reader_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 读取主题设置
  final prefs = await SharedPreferences.getInstance();
  final darkMode = prefs.getBool('dark_mode') ?? false;

  runApp(PersonalReader(darkMode: darkMode));
}

class PersonalReader extends StatefulWidget {
  final bool darkMode;

  const PersonalReader({
    super.key,
    required this.darkMode,
  });

  @override
  State<PersonalReader> createState() => _PersonalReaderState();

  static _PersonalReaderState? of(BuildContext context) {
    return context.findAncestorStateOfType<_PersonalReaderState>();
  }
}

class _PersonalReaderState extends State<PersonalReader> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.darkMode;
  }

  void toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Reader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const ReaderScreen(),
    );
  }
}