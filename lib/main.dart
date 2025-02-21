import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sickle_cell_app/screens/auth/login_screen.dart';
import 'package:sickle_cell_app/screens/auth/sign_up_screen.dart';
import 'package:sickle_cell_app/screens/more_screen.dart';
import 'package:sickle_cell_app/screens/profile/profile_screen.dart';
import 'package:sickle_cell_app/screens/splash_screen.dart';
import 'package:sickle_cell_app/screens/tabs_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromRGBO(255, 87, 51, 1),
    primary: const Color.fromRGBO(255, 87, 51, 1),
    secondary: const Color.fromARGB(255, 250, 112, 6),
  ),
  textTheme: GoogleFonts.robotoTextTheme(),
);

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
