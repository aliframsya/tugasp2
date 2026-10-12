import 'package:flutter/material.dart';
import 'screens/main_navigation_screen.dart';
import 'state/kantin_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KantinBuSariApp());
}

class KantinBuSariApp extends StatefulWidget {
  const KantinBuSariApp({super.key});

  @override
  State<KantinBuSariApp> createState() => _KantinBuSariAppState();
}

class _KantinBuSariAppState extends State<KantinBuSariApp> {
  final KantinState _kantinState = KantinState();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _kantinState,
      builder: (context, _) {
        return KantinScope(
          state: _kantinState,
          child: MaterialApp(
            title: 'Kantin Bu Sari',
            debugShowCheckedModeBanner: false,
            themeMode: _kantinState.themeMode,

            // Light Theme
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFE65100),
                primary: const Color(0xFFE65100),
                secondary: const Color(0xFF2E7D32),
                brightness: Brightness.light,
              ),
              appBarTheme: const AppBarTheme(
                centerTitle: false,
                elevation: 0,
                scrolledUnderElevation: 1,
              ),
              cardTheme: CardThemeData(
                elevation: 1.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFFE65100),
                    width: 2,
                  ),
                ),
              ),
            ),

            // Dark Theme
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFE65100),
                primary: const Color(0xFFFF8A65),
                secondary: const Color(0xFF81C784),
                brightness: Brightness.dark,
              ),
              appBarTheme: const AppBarTheme(
                centerTitle: false,
                elevation: 0,
              ),
              cardTheme: CardThemeData(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF8A65),
                    width: 2,
                  ),
                ),
              ),
            ),

            home: const MainNavigationScreen(),
          ),
        );
      },
    );
  }
}
