import 'package:flutter/material.dart';

void main() => runApp(const AppBarApp());

class AppBarApp extends StatefulWidget {
  const AppBarApp({super.key});

  @override
  State<AppBarApp> createState() => _AppBarAppState();
}

class _AppBarAppState extends State<AppBarApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Color _seedColor = const Color.fromRGBO(22, 221, 122, 1);
  bool _showElevation = true;

  final List<Color> _palette = [
    const Color.fromRGBO(22, 221, 122, 1),
    Colors.deepPurple,
    Colors.teal,
    Colors.indigo,
    Colors.orange,
  ];

  void _toggleThemeMode(bool value) {
    setState(() {
      _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _toggleElevation(bool value) {
    setState(() {
      _showElevation = value;
    });
  }

  void _cycleColor() {
    setState(() {
      final currentIndex = _palette.indexWhere((c) => c.value == _seedColor.value);
      final nextIndex = (currentIndex + 1) % _palette.length;
      _seedColor = _palette[nextIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData light = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.light),
      useMaterial3: true,
      appBarTheme: AppBarTheme(backgroundColor: _seedColor, foregroundColor: Colors.white),
      scaffoldBackgroundColor: _seedColor.withOpacity(0.04),
    );

    final ThemeData dark = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.dark),
      useMaterial3: true,
      appBarTheme: AppBarTheme(backgroundColor: _seedColor, foregroundColor: Colors.white),
      scaffoldBackgroundColor: Colors.black,
    );

    return MaterialApp(
      title: 'Inmortal king',
      debugShowCheckedModeBanner: false,
      theme: light,
      darkTheme: dark,
      themeMode: _themeMode,
      home: AppBarExample(
        onToggleTheme: _toggleThemeMode,
        onToggleElevation: _toggleElevation,
        onChangeColor: _cycleColor,
        seedColor: _seedColor,
        showElevation: _showElevation,
      ),
    );
  }
}

class AppBarExample extends StatefulWidget {
  const AppBarExample({
    super.key,
    required this.onToggleTheme,
    required this.onToggleElevation,
    required this.onChangeColor,
    required this.seedColor,
    required this.showElevation,
  });

  final ValueChanged<bool> onToggleTheme;
  final ValueChanged<bool> onToggleElevation;
  final VoidCallback onChangeColor;
  final Color seedColor;
  final bool showElevation;

  @override
  State<AppBarExample> createState() => _AppBarExampleState();
}

class _AppBarExampleState extends State<AppBarExample> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Menú',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Inicio seleccionado'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Perfil seleccionado'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ajustes'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ajustes'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.pop(context);
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmar'),
                      content: const Text('¿Deseas cerrar sesión?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sesión cerrada')),
                            );
                          },
                          child: const Text('Sí'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Menu',
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        // Mostrar título y el valor de scroll (scrolledUnderElevation)
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Simba'),
            Text(
              'scrolledUnderElevation: ${_scrollOffset.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        elevation: widget.showElevation ? (_scrollOffset > 0 ? 6.0 : 0.0) : 0.0,
        actions: <Widget>[
          // Botón que muestra SnackBar personalizado
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Alerta personalizada - scroll: ${_scrollOffset.toStringAsFixed(1)}'),
                  backgroundColor: widget.seedColor, // usar color actual
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),

          // Botón para cambiar color dinámicamente
          IconButton(
            icon: const Icon(Icons.color_lens),
            tooltip: 'Cambiar color',
            onPressed: () {
              widget.onChangeColor();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Color cambiado'),
                  backgroundColor: widget.seedColor,
                ),
              );
            },
          ),

          // Navegar a la siguiente página
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return const NextPage();
                  },
                ),
              );
            },
          ),
        ],
      ),
      // BottomAppBar con switches para modo oscuro y sombra
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(Icons.dark_mode),
                  const SizedBox(width: 8),
                  const Text('Modo oscuro'),
                  Switch(
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (v) => widget.onToggleTheme(v),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const Icon(Icons.layers),
                  const SizedBox(width: 8),
                  const Text('Sombra AppBar'),
                  Switch(
                    value: widget.showElevation,
                    onChanged: (v) => widget.onToggleElevation(v),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 12),
              // Logo circular
              CircleAvatar(
                radius: 56,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(
                  Icons.pets,
                  size: 56,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Título de bienvenida
              Text(
                'Bienvenido a Simba',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),

              // Subtítulo / descripción
              Text(
                'Tu compañero fiel para gestionar contenido. Explora las opciones desde el menú.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Grid de items con iconos y opacidad
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 3,
                children: List<Widget>.generate(4, (int index) {
                  final icons = [Icons.photo, Icons.map, Icons.message, Icons.settings];
                  return Opacity(
                    opacity: 0.9,
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Item ${index + 1} seleccionado')),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: <Widget>[
                              Icon(icons[index], color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 12),
                              Text('Item ${index + 1}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Card con información rápida
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Accede al menú para ver Inicio, Perfil, Ajustes y más.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Comenzar'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('¡Vamos!'),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Más info'),
                    onPressed: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Simba',
                        applicationVersion: '1.0.0',
                        children: const [Text('Aplicación de ejemplo con AppBar, Drawer y SnackBars.')],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Pie discreto
              Text(
                '© ${DateTime.now().year} Simba • Todos los derechos reservados',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Next page')),
      body: const Center(
        child: Text(
          'This is the next page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}