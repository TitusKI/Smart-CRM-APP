import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color primaryBackground = Colors.white;
  static const Color cardBackground = Color(0xFFF4F4F4);

  // Primary and accent colors
  static const Color primaryColor =
      Color(0xFF000000); // Black for titles and headings
  static const Color secondaryColor = Color(0xFF5C5C5C); // Subtle dark gray
  static const Color accentColor =
      Color(0xFF5A97D3); // Soft blue for highlights

  // Text colors
  static const Color primaryText =
      Color(0xFF1A1A1A); // Dark black for main text
  static const Color secondaryText =
      Color(0xFF707070); // Muted gray for secondary text
  static const Color hintText =
      Color(0xFFB3B3B3); // Light gray for placeholder text

  // Miscellaneous
  static const Color borderColor = Color(0xFFD9D9D9); // Light border color
  static const Color progressColor = Color(0xFF0055FF); // Progress bar color
}

class LightModeColors {
  // Base colors
  static const Color primaryBackground = AppColors.primaryBackground;
  static const Color cardColor = AppColors.cardBackground;

  // Text colors
  static const Color primaryText = AppColors.primaryText;
  static const Color secondaryText = AppColors.secondaryText;

  // Highlights
  static const Color accentColor = AppColors.accentColor;
  static const Color borderColor = AppColors.borderColor;

  // Progress indicators
  static const Color progressColor = AppColors.progressColor;
}

class DarkModeColors {
  // Base colors
  static const Color primaryBackground =
      Color(0xFF1A1A1A); // Dark gray background
  static const Color cardColor =
      Color(0xFF2E2E2E); // Slightly lighter dark gray for cards

  // Text colors
  static const Color primaryText = Colors.white; // White for main text
  static const Color secondaryText =
      Color(0xFFB3B3B3); // Muted gray for secondary text

  // Highlights
  static const Color accentColor =
      Color(0xFF6FAFFF); // Bright blue for highlights
  static const Color borderColor = Color(0xFF4A4A4A); // Darker border

  // Progress indicators
  static const Color progressColor =
      Color(0xFF008FFF); // Vibrant blue for progress
}
