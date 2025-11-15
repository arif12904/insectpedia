import 'package:flutter/material.dart';
import 'package:insectpedia/themes/insectpedia_typography.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      backgroundColor: themeProvider.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                'About Insectpedia',
                style: InsectpediaTypography.h3,
              ),
              const SizedBox(height: 24),
              Center(
                child: Image.asset(
                  'assets/images/logo/logo_insectpedia.png',
                  height: 200,
                  width: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.menu_book,
                        size: 80,
                        color: Colors.green,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
               Text(
                'Insectpedia is a dangerous insect classification app powered by artificial intelligence that identifies various insect species through photos. The app provides brief information about each detected insect\'s characteristics, danger level, and handling methods. Insectpedia helps users recognize potential threats early and raises awareness about insects that can harm crops or affect human health.',
                textAlign: TextAlign.justify,
                style: InsectpediaTypography.body,
              ),
              const SizedBox(height: 24),
               Text(
                'Our Team',
                style: InsectpediaTypography.h3,
              ),
              const SizedBox(height: 16),
              _buildTeamMember('Muhammad Arif Septian', '2309106046', 'assets/team1.png', themeProvider),
              const SizedBox(height: 24),
              _buildTeamMember('Muhammad Iqbal Fadiatama', '2309106077', 'assets/team2.png', themeProvider),
              const SizedBox(height: 24),
              _buildTeamMember('Muhammad Rizky Haritama Putra', '2309106083', 'assets/team3.png',themeProvider),
              const SizedBox(height: 24),
              _buildTeamMember('Ari Fullah', '2309106085', 'assets/team4.jpg',themeProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String nim, String imagePath, ThemeProvider themeProvider) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.asset(
            imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: themeProvider.accent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: themeProvider.tersier,
                  size: 30,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: InsectpediaTypography.h4
              ),
              const SizedBox(height: 8),
              Text(
                nim,
                style:InsectpediaTypography.caption2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
