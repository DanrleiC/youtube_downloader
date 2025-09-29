import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_downloader/app/configs/theme/colors.theme.dart';

abstract class AppDataTheme {
  /// Tema claro (light)
  // static ThemeData get light {
  //   return ThemeData(
  //     useMaterial3: true,
  //     brightness: Brightness.light,
  //     scaffoldBackgroundColor: ColorsTheme.backgroundColorLight,
  //     primaryColor: ColorsTheme.darkGray,
  //     colorScheme: ColorScheme.light(
  //       primary: ColorsTheme.darkGray,
  //       secondary: ColorsTheme.darkGray,
  //       surface: ColorsTheme.surfaceLight,
  //       onPrimary: Colors.white,
  //       onSecondary: Colors.white,
  //       onSurface: Colors.black87,
  //       error: Colors.red,
  //       onError: Colors.white,
  //     ),
  //     appBarTheme: const AppBarTheme(
  //       backgroundColor: ColorsTheme.surfaceLight,
  //       elevation: 0,
  //       foregroundColor: Colors.black87,
  //     ),
  //     cardTheme: CardThemeData(
  //       color: ColorsTheme.midGray.withValues(alpha: 0.2),
  //       elevation: 0,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(16),
  //         side: BorderSide(
  //           color: const Color.fromARGB(255, 179, 179, 179).withValues(alpha: 0.1),
  //           width: 1,
  //         ),
  //       ),
  //     ),
  //     textTheme: Typography.blackCupertino.apply(
  //       bodyColor: Colors.black87,
  //       displayColor: Colors.black87,
  //     ),
  //     inputDecorationTheme: InputDecorationTheme(
  //       filled: true,
  //       fillColor: ColorsTheme.lightGray,
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(8),
  //         borderSide: BorderSide(
  //           color: ColorsTheme.glassMedium
  //         ),
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(8),
  //         borderSide: BorderSide(
  //           color: const Color.fromARGB(255, 179, 179, 179)
  //         ),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(8),
  //         borderSide: BorderSide(color: ColorsTheme.primaryColor, width: 1.5),
  //       ),
  //     ),
  //     elevatedButtonTheme: ElevatedButtonThemeData(
  //       style: ElevatedButton.styleFrom(
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //         backgroundColor: ColorsTheme.primaryColor,
  //         foregroundColor: Colors.white,
  //       ),
  //     ),
  //   );
  // }

  /// Tema escuro (dark)
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ColorsTheme.almostAbsoluteBlack,
      primaryColor: ColorsTheme.almostAbsoluteBlack,
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorsTheme.almostAbsoluteBlack,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(Typography.whiteCupertino).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorsTheme.almostAbsoluteBlack,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorsTheme.inputBorderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorsTheme.inputBorderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white, width: 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: ColorsTheme.almostAbsoluteBlack,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 24.0,
          ),
          side: BorderSide(color: ColorsTheme.inputBorderDark, width: 0.5),
        ),
      ),
    );
  }

}