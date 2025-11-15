import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:insectpedia/screens/login_screen.dart';
import 'package:insectpedia/themes/insectpedia_colors.dart';
import 'package:insectpedia/themes/insectpedia_typography.dart';
import 'package:insectpedia/widgets/textfield_widget.dart';
import 'package:insectpedia/widgets/buttons_widget.dart';
import '../data/avatars_data.dart';
import '../provider/auth_provider.dart';
import '../provider/theme_provider.dart';
import '../utils/error_handler.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterScreen> {
  bool _obscurePass1 = true;
  bool _obscurePass2 = true;
  String? _selectedAvatar;


  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: themeProvider.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _RegisterHeader(),
              const SizedBox(height: 28),
              _UploadSection(
                selectedAvatar: _selectedAvatar,
                onTap: () => _showAvatarBottomSheet(context, themeProvider),
                themeProvider: themeProvider,
              ),
              const SizedBox(height: 40),
              _EmailField(controller: _emailController, themeProvider: themeProvider),
              const SizedBox(height: 24),
              _UsernameField(controller: _usernameController, themeProvider: themeProvider),
              const SizedBox(height: 24),
              _PasswordField(
                controller: _passwordController,
                obscureText: _obscurePass1,
                toggleVisibility: () => setState(() => _obscurePass1 = !_obscurePass1),
                themeProvider: themeProvider,
              ),
              const SizedBox(height: 24),
              _ConfirmPasswordField(
                controller: _confirmPassController,
                obscureText: _obscurePass2,
                toggleVisibility: () => setState(() => _obscurePass2 = !_obscurePass2),
                themeProvider: themeProvider,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: authProvider.isLoading
                      ? "Creating Account..."
                      : "Create Your Account",
                  isFullWidth: true,
                  onPressed: authProvider.isLoading
                      ? () {}
                      : () async {
                    final email = _emailController.text.trim();
                    final name = _usernameController.text.trim();
                    final password = _passwordController.text.trim();
                    final confirm = _confirmPassController.text.trim();

                    if (email.isEmpty || name.isEmpty || password.isEmpty || confirm.isEmpty) {
                      ErrorHandler.showError(context, "Please fill all fields");
                      return;
                    }

                    if (password != confirm) {
                      ErrorHandler.showError(context, "Passwords do not match");
                      return;
                    }

                    if (_selectedAvatar == null) {
                      ErrorHandler.showError(context, "Please select an avatar");
                      return;
                    }

                    await authProvider.register(
                      email: email,
                      password: password,
                      name: name,
                      avatarPath: _selectedAvatar!,
                    );

                    if (authProvider.errorMessage != null) {
                      ErrorHandler.showError(context, authProvider.errorMessage!);
                    } else {
                      ErrorHandler.showSuccess(context, "Account created successfully!");
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 28),
              _LoginRedirect(themeProvider: themeProvider),
            ],
          ),
        ),
      ),
    );
  }
}


class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: InsectpediaColors.greyColor,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),
        ),
        Text(
          "Create New Account",
          style: InsectpediaTypography.h2,
        ),
      ],
    );
  }
}

class _UploadSection extends StatelessWidget {
  final String? selectedAvatar;
  final VoidCallback onTap;

  const _UploadSection({
    required this.selectedAvatar,
    required this.onTap, required ThemeProvider themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(
                color: InsectpediaColors.greyColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: selectedAvatar == null
                ? const Icon(Icons.add,
                size: 40, color: InsectpediaColors.greyColor)
                : ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(selectedAvatar!, fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Select Avatar",
          style: InsectpediaTypography.h4,
        ),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  final ThemeProvider themeProvider;

  const _EmailField({required this.controller, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What’s Your Email?",
            style: InsectpediaTypography.labelTextField),
        const SizedBox(height: 12),
        CustomTextField(
          controller: controller,
          label: "Email",
          hintText: "Enter your email",
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          borderColor: InsectpediaColors.textfieldColor,
          focusedBorderColor: themeProvider.primary,
          labelColor: InsectpediaColors.text2Color,
        ),
      ],
    );
  }
}

class _UsernameField extends StatelessWidget {
  final ThemeProvider themeProvider;
  final TextEditingController controller;

  const _UsernameField({required this.controller, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("How Are You Called?",
            style: InsectpediaTypography.labelTextField),
        const SizedBox(height: 12),
        CustomTextField(
          controller: controller,
          label: "Username",
          hintText: "Enter your username",
          prefixIcon: Icons.person_outline,
          borderColor: InsectpediaColors.textfieldColor,
          focusedBorderColor: themeProvider.primary,
          labelColor: InsectpediaColors.text2Color,
        ),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  final ThemeProvider themeProvider;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback toggleVisibility;

  const _PasswordField({
    required this.controller,
    required this.obscureText,
    required this.toggleVisibility, required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What’s Your Password?",
            style: InsectpediaTypography.labelTextField),
        const SizedBox(height: 6),
        CustomTextField(
          controller: controller,
          label: "Password",
          hintText: "Enter your password",
          obscureText: obscureText,
          prefixIcon: Icons.lock_outline,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: toggleVisibility,
          ),
          borderColor: InsectpediaColors.textfieldColor,
          focusedBorderColor: themeProvider.primary,
          labelColor: InsectpediaColors.text2Color,
        ),
      ],
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  final ThemeProvider themeProvider;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback toggleVisibility;

  const _ConfirmPasswordField({
    required this.controller,
    required this.obscureText,
    required this.toggleVisibility, required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Repeat Your Password",
            style: InsectpediaTypography.labelTextField),
        const SizedBox(height: 6),
        CustomTextField(
          controller: controller,
          label: "Confirm Password",
          hintText: "Re-enter your password",
          obscureText: obscureText,
          prefixIcon: Icons.lock_outline,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: toggleVisibility,
          ),
          borderColor: InsectpediaColors.textfieldColor,
          focusedBorderColor: themeProvider.primary,
          labelColor: InsectpediaColors.text2Color,
        ),
      ],
    );
  }
}


class _LoginRedirect extends StatelessWidget {
  final ThemeProvider themeProvider;
  const _LoginRedirect({required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Got an account? ",
          style: InsectpediaTypography.labelTextField,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
          child: Text(
            "Log in here",
            style: TextStyle(
              color: themeProvider.secondary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
