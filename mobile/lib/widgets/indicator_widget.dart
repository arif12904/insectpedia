import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:insectpedia/themes/insectpedia_colors.dart';
import '../provider/theme_provider.dart';

class IndicatorWidget extends StatelessWidget {
  final int currentPage;

  const IndicatorWidget({
    super.key,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final bool isActive = currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 4,
          decoration: BoxDecoration(
            color: isActive
                ? themeProvider.primary
                : InsectpediaColors.greyColor,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
