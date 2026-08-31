import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/editor_screen.dart';
import 'models/essay.dart';

void main() {
  runApp(const EssayApp());
}

class EssayApp extends StatelessWidget {
  const EssayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Essay Writer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Georgia', // Using a serif-like default for essays if available
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (_) => const HomeScreen());
        }
        if (settings.name == '/editor') {
          final essay = settings.arguments as Essay;
          return MaterialPageRoute(builder: (_) => EditorScreen(essay: essay));
        }
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      },
    );
  }
}
