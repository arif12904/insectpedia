import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insectpedia/provider/precdiction_provider.dart';
import 'package:insectpedia/provider/theme_provider.dart';
import 'package:insectpedia/themes/insectpedia_colors.dart';
import 'package:insectpedia/themes/insectpedia_typography.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../widgets/buttons_widget.dart';

class PredictionScreen extends StatelessWidget {
  const PredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final predictionProvider = context.watch<PredictionProvider>();
    final themeProvider = context.watch<ThemeProvider>();


    return Scaffold(
      backgroundColor: themeProvider.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Prediction', style: InsectpediaTypography.h3),
              Center(
                child: Column(
                  children: [
                    ImagePreview(imageFile: predictionProvider.imageFile),
                    const SizedBox(height: 24),
                    Text(
                      'Take or Pick Image',
                      style: InsectpediaTypography.h2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upload a photo of a Dangerous\ninsect for identification',
                      textAlign: TextAlign.center,
                      style: InsectpediaTypography.body,
                    ),
                    const SizedBox(height: 32),
                    ActionButtons(predictionProvider: predictionProvider,themeProvider: themeProvider,),
                    const SizedBox(height: 28),
                    PredictButton(predictionProvider: predictionProvider),
                    const SizedBox(height: 16),
                    ClearButton(predictionProvider: predictionProvider),
                    const SizedBox(height: 32),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImagePreview extends StatelessWidget {
  final File? imageFile;
  const ImagePreview({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: imageFile != null ? 200 : 120,
        width: imageFile != null ? 200 : 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: imageFile == null ? Colors.transparent : null,
          image: imageFile != null ? DecorationImage(
            image: FileImage(imageFile!),
            fit: BoxFit.cover,
          ) : null,
        ),
        child: imageFile == null
            ? const Icon(Icons.image_outlined, size: 80, color: Colors.black87)
            : null,
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  final PredictionProvider predictionProvider;
  final ThemeProvider themeProvider;
  const ActionButtons({super.key, required this.predictionProvider, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          icon: Icons.camera_alt,
          onTap: () => predictionProvider.pickImage(ImageSource.camera),
          themeProvider: themeProvider
        ),
        const SizedBox(width: 24),
        _buildActionButton(
          icon: Icons.image,
          onTap: () => predictionProvider.pickImage(ImageSource.gallery),
          themeProvider: themeProvider
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required VoidCallback onTap, required ThemeProvider themeProvider}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: themeProvider.accent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: InsectpediaColors.textColor, size: 24),
      ),
    );
  }
}


class PredictButton extends StatelessWidget {
  final PredictionProvider predictionProvider;
  const PredictButton({super.key, required this.predictionProvider});

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: predictionProvider.isLoading ? 'Predicting...' : 'Predicted',
      isFullWidth: true,
      onPressed: predictionProvider.imageFile != null && !predictionProvider.isLoading
          ? () => predictionProvider.predictImage(context)
          : () {},
    );
  }
}


class ClearButton extends StatelessWidget {
  final PredictionProvider predictionProvider;
  const ClearButton({super.key, required this.predictionProvider});

  @override
  Widget build(BuildContext context) {
    return SecondaryButton(
      text: 'Clear Image',
      isFullWidth: true,
      onPressed: predictionProvider.clear,
    );
  }
}
