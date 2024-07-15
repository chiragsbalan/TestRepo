import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart'; // Ensure this is correctly imported
import 'login_page.dart'; // Ensure this is correctly imported

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme darkColorScheme = ColorScheme(
          primary: Colors.black,
          primaryContainer: Color(0xFF212123),
          secondary: Color(0xFF2C2C2C),
          secondaryContainer: Color(0xFF212123),
          surface: Colors.black,
          background: Colors.black,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onBackground: Colors.white,
          onError: Colors.black,
          brightness: Brightness.dark,
        );

        return MaterialApp(
          title: 'StudentSphere',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
            textTheme: TextTheme(
              headlineSmall: TextStyle(
                color: darkColorScheme.onBackground,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              bodyLarge: TextStyle(
                color: darkColorScheme.onBackground,
                fontSize: 18,
              ),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
            textTheme: TextTheme(
              headlineSmall: TextStyle(
                color: darkColorScheme.onBackground,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              bodyLarge: TextStyle(
                color: darkColorScheme.onBackground,
                fontSize: 18,
              ),
            ),
          ),
          themeMode: ThemeMode.dark,
          home: isLoggedIn ? HomePage(studentName: 'Lena') : LoginPage(),
        );
      },
    );
  }
}
