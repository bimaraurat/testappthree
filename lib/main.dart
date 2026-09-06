import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'views/bingo_game_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar appearance
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0D0E21),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const BingoApp());
}

class BingoApp extends StatelessWidget {
  const BingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bingo Game',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0E21),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF4081),
          secondary: Color(0xFF00E676),
          surface: Color(0xFF14152A),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const BingoGameScreen(),
    );
  }
}
