import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:insectpedia/themes/insectpedia_colors.dart';
import 'package:insectpedia/themes/insectpedia_typography.dart';
import '../provider/bottom_bar_provider.dart';
import '../provider/theme_provider.dart';

class BottomBarWidget extends StatelessWidget {
  final BottomBarProvider provider;

  const BottomBarWidget({
    required this.provider,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: themeProvider.background,
      currentIndex: provider.selectedIndex,
      onTap: provider.setIndex,
      selectedItemColor: InsectpediaColors.textColor,
      unselectedItemColor: InsectpediaColors.textColor,
      selectedLabelStyle: InsectpediaTypography.captionBold,
      unselectedLabelStyle: InsectpediaTypography.caption,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      items: [
        _buildItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home_filled,
          index: 0,
          label: 'Home',
          provider: provider,
          themeProvider: themeProvider,
        ),
        _buildItem(
          icon: Icons.qr_code_scanner_outlined,
          activeIcon: Icons.qr_code_scanner,
          index: 1,
          label: 'Scan',
          provider: provider,
          themeProvider: themeProvider,
        ),
        _buildItem(
          icon: Icons.info_outline,
          activeIcon: Icons.info,
          index: 2,
          label: 'About',
          provider: provider,
          themeProvider: themeProvider,
        ),
        _buildItem(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          index: 3,
          label: 'Profile',
          provider: provider,
          themeProvider: themeProvider,
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildItem({
    required IconData icon,
    required IconData activeIcon,
    required int index,
    required String label,
    required BottomBarProvider provider,
    required ThemeProvider themeProvider,
  }) {
    final bool isActive = provider.selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Icon(
        isActive ? activeIcon : icon,
        color: isActive ? themeProvider.tersier : InsectpediaColors.textColor,
        size: 24,
      ),
      label: label,
    );
  }
}
