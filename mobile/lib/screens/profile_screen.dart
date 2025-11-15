import 'package:flutter/material.dart';
import 'package:insectpedia/provider/bottom_bar_provider.dart';
import 'package:insectpedia/screens/edit_profile_screen.dart';
import 'package:insectpedia/screens/login_screen.dart';
import 'package:insectpedia/themes/insectpedia_typography.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../provider/theme_provider.dart';
import '../widgets/buttons_widget.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();
    final bottomBarProvider = context.watch<BottomBarProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: themeProvider.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Profile', style: InsectpediaTypography.h3),
              Expanded(
                child: Center(
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Profile Picture
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD4C495),
                        ),
                        child: ClipOval(
                          child: (user?.photoUrl?.isNotEmpty ?? false)
                              ? Image.asset(
                            user!.photoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              );
                            },
                          )
                              : const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Name
                      Text(
                        user?.displayName ?? 'Guest',
                        style: InsectpediaTypography.h3,
                      ),
                      const SizedBox(height: 8),

                      // Email
                      Text(
                        user?.email ?? '-',
                        style: InsectpediaTypography.caption,
                      ),
                      const SizedBox(height: 40),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SecondaryButton(
                            text: 'Edit Profile',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          PrimaryButton(
                            text: 'Log out',
                            color: Colors.redAccent,
                            onPressed: () async {
                              await authProvider.logout();
                              bottomBarProvider.setIndex(0);
                              if (context.mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
