import 'package:flutter/material.dart';
import 'package:insectpedia/themes/insectpedia_colors.dart';
import 'package:insectpedia/themes/insectpedia_typography.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../provider/theme_provider.dart';
import '../widgets/insect_card.dart';
import '../data/insects.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: themeProvider.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _ProfileSection(authProvider, themeProvider),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dangerous Insects",
                      style: InsectpediaTypography.h5,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: (insects.length / 2).ceil(),
                itemBuilder: (context, index) {
                  final firstIndex = index * 2;
                  final secondIndex = firstIndex + 1;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: InsectCard(
                            title: insects[firstIndex].title,
                            description: insects[firstIndex].description,
                            imagePath: insects[firstIndex].image,
                          ),
                        ),
                        if (secondIndex < insects.length) ...[
                          const SizedBox(width: 16),
                          Expanded(
                            child: InsectCard(
                              title: insects[secondIndex].title,
                              description: insects[secondIndex].description,
                              imagePath: insects[secondIndex].image,
                            ),
                          ),
                        ] else
                          const Expanded(child: SizedBox()),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _ProfileSection(AuthProvider authProvider, ThemeProvider themeProvider) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: themeProvider.primary.withOpacity(0.3),
              backgroundImage: authProvider.currentUser?.photoUrl != null
                  ? AssetImage(authProvider.currentUser!.photoUrl!)
                  : null,
              child: authProvider.currentUser?.photoUrl == null
                  ? Icon(Icons.person, size: 40, color: themeProvider.primary)
                  : null,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome to Insectpedia",
                  style: InsectpediaTypography.caption,
                ),
                Text(
                  authProvider.currentUser?.displayName ?? "User",
                  style: InsectpediaTypography.h5,
                ),
              ],
            ),
          ],
        ),
        IconButton(
          icon: Icon(
            Icons.color_lens_outlined,
            color: InsectpediaColors.textColor,
          ),
          onPressed: () {
            themeProvider.toggleTheme();
          },
        ),
      ],
    ),
  );
}
