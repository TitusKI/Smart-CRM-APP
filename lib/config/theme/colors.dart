import 'package:flutter/material.dart';

class AppColors {
  // Fresh and Lignt
  static const Color primaryBackground = Colors.white;

  static const Color secondaryColor = Color(0xFF005782);
  static const Color accentColor = Color(0xFF0097D3);
  static const Color cardColor = Color(0xFFE5E7EB);
  static const Color primarySecondaryText = Colors.grey;
  static const Color loadingColor = Color.fromARGB(135, 232, 227, 227);

  static const Color primaryText = Color(0xFF0C0E0A);
}

class LightModeColors {
  static const Color primaryColor = Color(0xFF005782);
  static const Color secondaryColor = Color(0xFF0097D3);
  static const Color cardColor = Color(0xFFE5E7EB);
  static const Color primaryText = Color(0xFF0C0E0A);
  static const Color primarySecondaryText = Colors.grey;
  // for names and titles
  static const Color headlineLarge = Color(0xFF005782);
  // for username
  static const Color headlineMedium = Colors.black45;
// for details
  static Color? headlineSmall = Colors.grey[850];

  //static const Color secondaryText = Colors.black45;
  static const Color hintColor = Colors.black26;
}

class DarkModeColors {
  static const Color primaryColor = Colors.black;
  static const Color secondaryColor = Color(0xFF0097D3);
  static const Color cardColor = Color(0xFF1E1E1E);
  static const Color primaryText = Colors.white;
  static const Color primarySecondaryText = Color(0xFFB0B0B0);
  static const Color secondaryText = Color(0xFF8A8A8A);
  static const Color hintColor = Colors.white38;
}
