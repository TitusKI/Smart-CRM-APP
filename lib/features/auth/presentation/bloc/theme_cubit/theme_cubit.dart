import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../config/theme/colors.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(lightTheme);

  static final lightTheme = ThemeData(
      colorScheme: const ColorScheme.highContrastLight(),
      textTheme: GoogleFonts.soraTextTheme(
        TextTheme(
          headlineLarge: TextStyle(
              color: LightModeColors.headlineLarge,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp),
          headlineMedium: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14.sp,
              color: LightModeColors.headlineMedium),
          headlineSmall: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12.sp,
              color: LightModeColors.headlineSmall),
        ),
      ),
      brightness: Brightness.light,
      primaryColor: LightModeColors.primaryColor,
      // backgroundColor: LightModeColors.primaryBackground,
      // hintRColor: LightModeColors.accentColor,
      iconTheme: const IconThemeData(color: AppColors.secondaryColor),
      iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
              iconColor:
                  WidgetStatePropertyAll(LightModeColors.secondaryColor))),
      cardColor: LightModeColors.cardColor,
      hintColor: LightModeColors.hintColor,
      // textTheme: TextTheme(
      //   headlineLarge: const TextStyle(color: LightModeColors.headlineLarge),
      //   headlineMedium: const TextStyle(color: LightModeColors.headlineMedium),
      //   headlineSmall: TextStyle(color: LightModeColors.headlineSmall),
      // ),
      elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(LightModeColors.secondaryColor))));

  static final darkTheme = ThemeData(
    // brightness: Brightness.dark,
    colorScheme: const ColorScheme.highContrastDark(),
    primaryColor: DarkModeColors.secondaryColor,
    cardColor: DarkModeColors.cardColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: DarkModeColors.primaryText),
      bodyMedium: TextStyle(color: DarkModeColors.secondaryText),
      titleMedium: TextStyle(color: DarkModeColors.primarySecondaryText),
    ),
  );

  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? lightTheme : darkTheme);
  }
}
