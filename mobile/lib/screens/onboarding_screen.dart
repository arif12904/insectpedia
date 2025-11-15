import 'package:flutter/material.dart';
import 'package:insectpedia/screens/login_screen.dart';
import 'package:insectpedia/themes/insectpedia_typography.dart';
import 'package:insectpedia/widgets/buttons_widget.dart';
import 'package:provider/provider.dart';
import '../data/onboarding_data.dart';
import '../provider/onboarding_provider.dart';
import '../provider/theme_provider.dart';
import '../widgets/indicator_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    final onboardingProvider = context.read<OnboardingProvider>();
    pageController =
        PageController(initialPage: onboardingProvider.currentPage);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingProvider = context.watch<OnboardingProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: themeProvider.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeader(context, onboardingProvider),
              _buildPageView(onboardingProvider, onboardingData),
              _buildFooter(context, onboardingProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, OnboardingProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IndicatorWidget(currentPage: provider.currentPage),
        TextButtonWidget(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
          text: 'Skip',
        ),
      ],
    );
  }

  Widget _buildPageView(
      OnboardingProvider provider,
      List<Map<String, String>> data,
      ) {
    return Expanded(
      child: PageView(
        controller: pageController,
        onPageChanged: provider.updatePage,
        children: data
            .map((item) => OnboardingPage(
          pathPhoto: item['pathPhoto']!,
          headline: item['headline']!,
          subHeadline: item['subHeadline']!,
        ))
            .toList(),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, OnboardingProvider provider) {
    final currentPage = provider.currentPage;

    return Row(
      mainAxisAlignment:
      currentPage > 0 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
      children: [
        if (currentPage > 0)
          SecondaryButton(
            onPressed: () {
              provider.previous();
              pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
            text: 'Previous',
          ),
        if (currentPage < 2)
          PrimaryButton(
            onPressed: () {
              provider.next();
              pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
            text: 'Next',
          ),
        if (currentPage == 2)
          PrimaryButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            text: 'Explore now',
          ),
      ],
    );
  }
}



class OnboardingPage extends StatelessWidget{
  final String pathPhoto;
  final String headline;
  final String subHeadline;

  const OnboardingPage({super.key,
    required this.pathPhoto,
    required this.headline,
    required this.subHeadline
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            pathPhoto,
            width: 327,
            height: 327,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 28),
          Text(
            headline,
            style: InsectpediaTypography.h1,
          ),
          SizedBox(height: 12,),
          Text(
            subHeadline,
            style: InsectpediaTypography.body,
          ),
        ],
      ),
    );
  }
}