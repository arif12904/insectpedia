import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../themes/insectpedia_colors.dart';

class ThemeProvider extends ChangeNotifier {
  bool isTheme1 = true;

  ThemeProvider() {
    _loadTheme();
  }

  Color get background =>
      isTheme1 ? InsectpediaColors.background1 : InsectpediaColors.background2;
  Color get primary =>
      isTheme1 ? InsectpediaColors.primary1 : InsectpediaColors.primary2;
  Color get secondary =>
      isTheme1 ? InsectpediaColors.secondary1 : InsectpediaColors.secondary2;
  Color get tersier =>
      isTheme1 ? InsectpediaColors.tersier1 : InsectpediaColors.tersier2;
  Color get accent =>
      isTheme1 ? InsectpediaColors.accent1 : InsectpediaColors.accent2;

  /// Menganti tema dan simpan ke SharedPreferences
  Future<void> toggleTheme() async {
    isTheme1 = !isTheme1;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isTheme1', isTheme1);
  }

  /// Memuat tema terakhir dari SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isTheme1 = prefs.getBool('isTheme1') ?? true;
    notifyListeners();
  }
}
