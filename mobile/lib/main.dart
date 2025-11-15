import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insectpedia/provider/bottom_bar_provider.dart';
import 'package:insectpedia/provider/precdiction_provider.dart';
import 'package:insectpedia/provider/theme_provider.dart';
import 'package:insectpedia/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insectpedia/firebase_options.dart';
import 'package:insectpedia/provider/onboarding_provider.dart';
import 'package:insectpedia/provider/auth_provider.dart';
import 'package:insectpedia/screens/onboarding_screen.dart';
import 'package:insectpedia/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BottomBarProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PredictionProvider()),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const MainScreen() : const OnboardingScreen(),
      theme: ThemeData(
        textTheme: GoogleFonts.spaceGroteskTextTheme(),
    ),
    );
  }
}
