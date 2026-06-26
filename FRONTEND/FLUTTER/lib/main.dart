import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/api_service.dart';
import 'screens/home_screen.dart';
import 'screens/random_screen.dart';
import 'screens/search_screen.dart';
import 'widgets/retro_app_bar.dart';
import 'widgets/retro_bottom_nav_bar.dart';

void main() async {
  // Initialiser les variables d'environnement
  await dotenv.load(fileName: '.env');
  
  // Initialiser le service API
  await ApiService.init();
  
  runApp(const CradosDexApp());
}

// Application principale
class CradosDexApp extends StatelessWidget {
  const CradosDexApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crados Dex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 4.0,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: Colors.white,
            fontFamily: 'Courier',
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            fontFamily: 'Courier',
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.pink, width: 2.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.white, width: 2.0),
            ),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// Écran principal avec navigation
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Pages de l'application
  final List<Widget> _pages = [
    const HomeScreen(),
    const RandomScreen(),
    const SearchScreen(),
  ];

  // Éléments de la barre de navigation
  final List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.list),
      label: 'Liste',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shuffle),
      label: 'Aléatoire',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Rechercher',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: RetroBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _navItems,
      ),
    );
  }
}
