import 'package:flutter/material.dart';
import 'package:insectpedia/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:insectpedia/screens/profile_screen.dart';
import 'package:insectpedia/screens/login_screen.dart';
import 'package:insectpedia/provider/theme_provider.dart';
import 'package:insectpedia/provider/auth_provider.dart';
import 'package:insectpedia/utils/error_handler.dart';
import 'package:insectpedia/themes/insectpedia_typography.dart';
import 'package:insectpedia/themes/insectpedia_colors.dart';
import '../data/avatars_data.dart';
import '../widgets/buttons_widget.dart';
import '../widgets/textfield_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedAvatar;

  @override
  void initState() {
    super.initState();
    final currentUser = context.read<AuthProvider>().currentUser;
    _nameController.text = currentUser?.displayName ?? '';
    _selectedAvatar = currentUser?.photoUrl;
  }

  Future<void> _updateProfile(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    try {
      await authProvider.updateProfile(
        displayName: _nameController.text.trim(),
        photoUrl: _selectedAvatar,
      );
      if (mounted) {
        ErrorHandler.showSuccess(context, "Profile updated successfully!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MainScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showError(context, "Error updating profile: $e");
      }
    }
  }

  void _showAvatarBottomSheet(BuildContext context, ThemeProvider themeProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: themeProvider.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Choose Your Avatar", style: InsectpediaTypography.h3),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                itemCount: avatars.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final avatarPath = avatars[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedAvatar = avatarPath);
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(avatarPath),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "Are you sure you want to permanently delete your account? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await authProvider.deleteAccount();
        if (context.mounted) {
          ErrorHandler.showSuccess(context, "Account deleted successfully.");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ErrorHandler.showError(context, "Error deleting account: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: themeProvider.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      color: InsectpediaColors.greyColor,
                    ),
                      onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "Edit Profile",
                    style: InsectpediaTypography.h3,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Avatar section
              GestureDetector(
                onTap: () => _showAvatarBottomSheet(context, themeProvider),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _selectedAvatar != null
                          ? AssetImage(_selectedAvatar!)
                          : const AssetImage('assets/avatars/avatar1.png'),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: themeProvider.primary,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Icons.edit, size: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Edit Your Name",
                  style: InsectpediaTypography.labelTextField,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _nameController,
                label: "Username",
                hintText: "Enter your name",
              ),

              const SizedBox(height: 24),
              PrimaryButton(
                text: "Save Changes",
                isFullWidth: true,
                onPressed: authProvider.isLoading
                    ? () {}
                    : () => _updateProfile(context),
              ),

              const SizedBox(height: 16),
              TextButtonWidget(
                text: "Delete Account",
                color: Colors.red,
                onPressed: authProvider.isLoading
                    ? () {} //
                    : () async => await _confirmDeleteAccount(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
