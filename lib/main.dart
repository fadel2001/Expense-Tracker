import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/expenses.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (FirebaseFirestore.instance.settings.persistenceEnabled == false) {
    await FirebaseFirestore.instance
        // ignore: deprecated_member_use
        .enablePersistence(const PersistenceSettings(synchronizeTabs: true));
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

final ColorScheme myLightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF3B60B3),
  brightness: Brightness.light,
);

final ColorScheme myDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF3B60B3),
  brightness: Brightness.dark,
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: myLightColorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: myLightColorScheme.primary,
          foregroundColor: myLightColorScheme.onPrimary,
        ),
        cardTheme: CardThemeData(
          color: myLightColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: myLightColorScheme.primary,
            foregroundColor: myLightColorScheme.onPrimary,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: myLightColorScheme.onSecondaryContainer,
                fontSize: 18,
              ),
            ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        // ignore: deprecated_member_use
        useMaterial3: true,
        colorScheme: myDarkColorScheme,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: myDarkColorScheme.surface,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: myDarkColorScheme.surface,
          foregroundColor: myDarkColorScheme.onSurface,
        ),
        cardTheme: CardThemeData(
          color: myDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: myDarkColorScheme.primary,
            foregroundColor: myDarkColorScheme.onPrimary,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: myDarkColorScheme.onSecondaryContainer,
                fontSize: 18,
              ),
            ),
      ),
      home: Expenses(onToggleTheme: _toggleTheme),
    );
  }
}
