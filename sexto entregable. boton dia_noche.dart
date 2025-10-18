import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Estado actual del tema (claro por defecto)
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tema Claro y Oscuro',
      debugShowCheckedModeBanner: false,

      // 🌞 Tema claro
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: Color.fromARGB(255, 19, 222, 230),
          onPrimary: Colors.white,
          background: Color.fromARGB(255, 179, 236, 234),
          onBackground: Color(0xFF1C1B1F),
        ),
        useMaterial3: true,
      ),

      // 🌙 Tema oscuro
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Color.fromARGB(255, 31, 4, 105),
          onPrimary: Color.fromARGB(255, 254, 250, 255),
          background: Color.fromARGB(255, 34, 5, 122),
          onBackground: Color.fromARGB(255, 131, 7, 106),
        ),
        useMaterial3: true,
      ),

      // ⚙️ Tema actual (según el botón)
      themeMode: _themeMode,

      home: MyHomePage(
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const MyHomePage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isDarkMode ? "Tema Oscuro" : "Tema Claro"),
        backgroundColor: theme.primary,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: onToggleTheme,
          icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
          label: Text(
            isDarkMode ? "Cambiar a modo claro" : "Cambiar a modo oscuro",
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primary,
            foregroundColor: theme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
    );
  }
}
