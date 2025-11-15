import 'package:flutter/material.dart';
import 'package:insectpedia/screens/prediction_screen.dart';
import 'package:insectpedia/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import '../provider/bottom_bar_provider.dart';
import '../screens/home_screen.dart';
import '../screens/about_screen.dart';
import '../widgets/bottom_bar_widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BottomBarProvider>();

    final List<Widget> pages = [
      const HomeScreen(),
      const PredictionScreen(),
      const AboutScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[provider.selectedIndex],
      bottomNavigationBar: BottomBarWidget(provider: provider),
    );
  }
}
