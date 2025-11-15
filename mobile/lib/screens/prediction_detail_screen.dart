import 'dart:io';
import 'package:flutter/material.dart';
import 'package:insectpedia/themes/insectpedia_colors.dart';
import 'package:insectpedia/themes/insectpedia_typography.dart';
import 'package:provider/provider.dart';
import '../models/insect_detail.dart';
import '../provider/theme_provider.dart';
import '../widgets/buttons_widget.dart';

class PredictionDetailScreen extends StatelessWidget {
  final InsectDetail insect;
  final File imageFile;
  final double confidence;

  const PredictionDetailScreen({
    super.key,
    required this.insect,
    required this.imageFile,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      backgroundColor: themeProvider.background ,
      body: Column(
          children: [
            _HeaderImage(imageFile: imageFile),
            Expanded(
              child: confidence < 50
                  ? Center(
                child: LowConfidenceWarning(
                  confidence: confidence,
                  onRetry: () {
                    Navigator.pop(context);
                  },
                ),
              )
                  : SingleChildScrollView(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 80, top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InsectIdentificationSection(insect: insect, themeProvider: themeProvider),
                    const SizedBox(height: 20),
                    _ConfidenceSection(confidence: confidence, themeProvider: themeProvider),
                    const SizedBox(height: 20),
                    _CharacteristicSection(insect: insect, themeProvider: themeProvider),
                    const SizedBox(height: 20),
                    _ControlMethodsSection(
                      controlMethods: insect.controlMethods,
                      themeProvider: themeProvider,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
    );
  }
}

class _HeaderImage extends StatelessWidget {
  final File imageFile;
  const _HeaderImage({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            image: DecorationImage(
              image: FileImage(imageFile),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: 24,
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.6),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }
}

class _InsectIdentificationSection extends StatelessWidget {
  final InsectDetail insect;
  final ThemeProvider themeProvider;
  const _InsectIdentificationSection({required this.insect, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return _SectionContainer(
      icon: Icons.bug_report_rounded,
      title: 'Insect Identification',
      themeProvider: themeProvider,
      child: Column(
        children: [
          _InfoRow(label: 'Insect Name', value: insect.title),
          const SizedBox(height: 8),
          _InfoRow(label: 'Danger Level', value: insect.dangerLevel),
        ],
      ),
    );
  }
}

class _ConfidenceSection extends StatelessWidget {
  final double confidence;
  final ThemeProvider themeProvider;
  const _ConfidenceSection({required this.confidence, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return _SectionContainer(
      icon: Icons.stacked_line_chart,
      title: 'Confidence Level',
      themeProvider: themeProvider,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                  'Confidence',
                  style: InsectpediaTypography.labelTextField
              ),
              Text(
                  '${confidence.toStringAsFixed(0)}%',
                  style: InsectpediaTypography.h5
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: confidence / 100,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getConfidenceColor(confidence),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 75) {
      return const Color(0xFF7CB342);
    } else if (confidence >= 50) {
      return Colors.yellow.shade700;
    } else {
      return Colors.red.shade400;
    }
  }
}

class _CharacteristicSection extends StatelessWidget {
  final InsectDetail insect;
  final ThemeProvider themeProvider;
  const _CharacteristicSection({required this.insect, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return _SectionContainer(
      icon: Icons.description,
      title: 'Characteristic',
      themeProvider: themeProvider,
      child: Column(
        children: [
          _InfoRow(label: 'Size', value: insect.size),
          const SizedBox(height: 16),
          _InfoRow(label: 'Body', value: insect.body),
          const SizedBox(height: 16),
          _InfoRow(label: 'Color', value: insect.color),
          const SizedBox(height: 16),
          _InfoRow(label: 'Habitat', value: insect.habitat),
        ],
      ),
    );
  }
}

class _ControlMethodsSection extends StatelessWidget {
  final List<String> controlMethods;
  final ThemeProvider themeProvider;
  const _ControlMethodsSection({required this.controlMethods, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return _SectionContainer(
      icon: Icons.shield,
      title: 'Control Methods',
      themeProvider: themeProvider,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: controlMethods
            .map((method) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 6, right: 8),
                decoration: BoxDecoration(
                  color: themeProvider.tersier,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  method,
                  style: InsectpediaTypography.labelTextField,
                ),
              ),
            ],
          ),
        ))
            .toList(),
      ),
    );
  }
}


class _SectionContainer extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final ThemeProvider themeProvider;
  const _SectionContainer({
    required this.icon,
    required this.title,
    required this.child,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeProvider.accent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Icon(
                    icon,
                    color: themeProvider.tersier, size: 20
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style:  InsectpediaTypography.h3,
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}


class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
            label,
            style: InsectpediaTypography.labelTextField
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: InsectpediaTypography.h5,
          ),
        ),
      ],
    );
  }
}

class LowConfidenceWarning extends StatelessWidget {
  final double confidence;
  final VoidCallback onRetry;

  const LowConfidenceWarning({
    super.key,
    required this.confidence,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          /// Title
          Text(
            "Low Confidence Result",
            textAlign: TextAlign.center,
            style: InsectpediaTypography.h3,
          ),

          const SizedBox(height: 12),

          /// Explanation text
          Text(
            "The prediction confidence is too low to determine whether this insect is harmful. "
                "Please try scanning again for a more accurate result.",
            textAlign: TextAlign.center,
            style: InsectpediaTypography.labelTextField,
          ),

          const SizedBox(height: 20),

          Text(
            "Confidence: ${confidence.toStringAsFixed(0)}%",
            style: InsectpediaTypography.h5.copyWith(
              color: Colors.redAccent,
            ),
          ),

          const SizedBox(height: 24),

          PrimaryButton(
            text: "Back to Prediction",
            isFullWidth: true,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}


