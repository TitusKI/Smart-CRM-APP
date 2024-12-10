import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/colors.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(lightTheme);

  static final lightTheme = ThemeData(
      colorScheme: const ColorScheme.light(),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: AppColors.accentColor), // Label color
        // Enabled border
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: AppColors.accentColor)), // Focused border
      ),
      textTheme: GoogleFonts.soraTextTheme(
        TextTheme(
          headlineLarge:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
          headlineMedium: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14.sp,
          ),
          headlineSmall: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12.sp,
          ),
        ),
      ),
      brightness: Brightness.light,
      primaryColor: AppColors.primaryColor,
      iconTheme: const IconThemeData(color: AppColors.secondaryColor),
      iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
              iconColor: WidgetStatePropertyAll(AppColors.secondaryColor))),
      cardColor: LightModeColors.cardColor,
      hintColor: AppColors.hintText,
      elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(AppColors.secondaryColor))));

  static final darkTheme = ThemeData(
    // brightness: Brightness.dark,
    colorScheme: const ColorScheme.highContrastDark(),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: AppColors.accentColor), // Label color
      // Enabled border
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.accentColor)),
    ),
    primaryColor: AppColors.primaryColor,
    cardColor: DarkModeColors.cardColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: DarkModeColors.primaryText),
      bodyMedium: TextStyle(color: DarkModeColors.secondaryText),
      titleMedium: TextStyle(color: AppColors.primaryText),
    ),
  );

  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? lightTheme : darkTheme);
  }
}
