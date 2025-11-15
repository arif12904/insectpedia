import 'package:flutter/material.dart';
import 'package:insectpedia/screens/main_screen.dart';
import 'package:insectpedia/screens/onboarding_screen.dart';
import 'package:insectpedia/screens/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:insectpedia/themes/insectpedia_colors.dart';
import '../provider/auth_provider.dart';
import '../provider/theme_provider.dart';
import '../themes/insectpedia_typography.dart';
import '../utils/error_handler.dart';
import '../widgets/buttons_widget.dart';
import '../widgets/textfield_widget.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      backgroundColor: themeProvider.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _LoginHeader(),
              const SizedBox(height: 28),
              _EmailField(controller: _emailController,themeProvider: themeProvider,),
              const SizedBox(height: 24),
              _PasswordField(
                themeProvider: themeProvider,
                controller: _passwordController,
                obscureText: _obscureText,
                onToggle: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              const SizedBox(height: 28),
              _LoginButton(
                authProvider: authProvider,
                emailController: _emailController,
                passwordController: _passwordController,
              ),
              const SizedBox(height: 24),
              _JoinNowSection(themeProvider: themeProvider),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

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
                  builder: (context) => const OnboardingScreen(),
                ),
              );
            },
          ),
        ),
        Text(
          "Log in Your Account",
          style: InsectpediaTypography.h2,
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
        Text(
          "What’s Your Email?",
          style: InsectpediaTypography.labelTextField,
        ),
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

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final ThemeProvider themeProvider;
  final bool obscureText;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.controller,
    required this.obscureText,
    required this.onToggle,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          "What’s Your Password?",
          style: InsectpediaTypography.labelTextField,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: controller,
          label: "Password",
          hintText: "Enter your password",
          obscureText: obscureText,
          prefixIcon: Icons.lock_outline,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: InsectpediaColors.greyColor,
            ),
            onPressed: onToggle,
          ),
          borderColor: InsectpediaColors.textfieldColor,
          focusedBorderColor: themeProvider.primary,
          labelColor: InsectpediaColors.text2Color,
        ),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  final AuthProvider authProvider;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _LoginButton({
    required this.authProvider,
    required this.emailController,
    required this.passwordController,
  });

  bool _isValidEmail(String email) {
    // Validasi sederhana format email
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        text: authProvider.isLoading
            ? "Loading..."
            : "Log In Your Account",
        isFullWidth: true,
        onPressed: authProvider.isLoading
            ? () {}
            : () async {
          final email = emailController.text.trim();
          final password = passwordController.text.trim();

          if (email.isEmpty || password.isEmpty) {
            ErrorHandler.showError(context, "Please fill all fields");
            return;
          }

          if (!_isValidEmail(email)) {
            ErrorHandler.showError(context, "Invalid email format");
            return;
          }

          if (password.length < 6) {
            ErrorHandler.showError(context, "Password must be at least 6 characters");
            return;
          }

          await authProvider.login(email, password);

          if (authProvider.errorMessage != null) {
            ErrorHandler.showError(context, "Login Failed");
          } else {
            ErrorHandler.showSuccess(context, "Login Success!");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainScreen()),
            );
          }
        },
      ),
    );
  }
}

class _JoinNowSection extends StatelessWidget {
  final ThemeProvider themeProvider;
  const _JoinNowSection({required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Text(
            "New here? ",
            style: InsectpediaTypography.labelTextField,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterScreen(),
                ),
              );
            },
            child: Text(
              "Join us now",
              style: TextStyle(
                color: themeProvider.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
