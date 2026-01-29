import 'package:flutter/material.dart';
import 'package:youtube_downloader/app/utils/theme_controller.utils.dart';

/// Utilitário para obter cores baseadas no tema atual
class ColorsTheme {
  static final ThemeController _themeController = ThemeController.instance;
  /// Ajuste nas cores (remove roxo)
  // static const Color primaryColor = darkGray; // cinza escuro como base
  // static const Color secondaryColor = midGray; // cinza intermediário


  /// Preto quase absoluto — para fundos e layers mais profundos.
  static const Color almostAbsoluteBlack = Color.fromRGBO(10, 10, 10, 1);

  static const Color inputBorderDark =  Color.fromRGBO(37, 37, 37, 1);


  // /// Cinza meio claro — tom intermediário para textos e bordas.
  // static const Color mediumLightGray = Color.fromRGBO(150, 150, 150, 1);

  // /// Cinza escuro — para elementos de hierarquia média.
  // static const Color darkGray = Color.fromRGBO(60, 60, 60, 1);

  // /// Cinza intermediário — entre mediumLightGray e darkGray.
  // static const Color midGray = Color.fromRGBO(105, 105, 105, 1);

  // /// Cinza claro
  // static const Color lightGray = Color.fromRGBO(187, 187, 187, 1);

  // /// Branco com 5% de opacidade — efeito glass leve.
  // static Color get glassLight => Colors.white.withValues(alpha: 0.05);

  // /// Branco com 10% de opacidade — efeito glass médio / divisor.
  // static Color get glassMedium => Colors.white.withValues(alpha: 0.1);

  // /// Azul índigo com 20% de opacidade — para overlays com destaque primário.
  // static Color get primaryGlass => primaryColor.withValues(alpha: 0.2);

  // /// Branco com 10% de opacidade — bordas discretas no dark mode.
  // static Color get borderLight => Colors.white.withValues(alpha: 0.1);

  // /// Fundo claro — reutilizado no tema claro.
  // static const Color surfaceLight = Colors.white;

  // /// Texto primário no tema claro.
  // static const Color textPrimaryLight = Colors.black87;

  // /// Cor de fundo principal
  // static Color backgroundColor(BuildContext context) {
  //   return Theme.of(context).scaffoldBackgroundColor;
  // }

  // /// Cor de fundo dos cards/containers
  // static Color cardBackgroundColor(BuildContext context) {
  //   return Theme.of(context).cardTheme.color ?? (_themeController.isThemeDark ? const Color(0xFF2A2A2A) : Colors.white);
  // }

  // /// Cor de fundo dos ícones nos cards
  // static Color iconBackgroundColor(BuildContext context) {
  //   return _themeController.isThemeDark ? const Color(0xFF3A3A3A) : const Color(0xFFF1F5F9);
  // }
  // /// Cor do texto principal
  // static Color primaryTextColor(BuildContext context) {
  //   return Theme.of(context).colorScheme.onSurface;
  // }

  // /// Cor do texto secundário
  // static Color secondaryTextColor(BuildContext context) {
  //   return _themeController.isThemeDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  // }

  // /// Cor para elementos desabilitados
  // static Color disabledColor(BuildContext context) {
  //   return _themeController.isThemeDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF);
  // }

  // /// Cor para tracks desabilitados
  // static Color disabledTrackColor(BuildContext context) {
  //   return _themeController.isThemeDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB);
  // }

  // /// Cor de fundo para inputs/paths
  // static Color inputBackgroundColor(BuildContext context) {
  //   return _themeController.isThemeDark ? const Color(0xFF1F2937) : const Color(0xFFF8FAFC);
  // }

  // /// Cor de borda para inputs
  // static Color inputBorderColor(BuildContext context) {
  //   return _themeController.isThemeDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB);
  // }

  // /// Cor de fundo para botões secundários
  // static Color secondaryButtonColor(BuildContext context) {
  //   return _themeController.isThemeDark ? const Color(0xFF374151) : const Color(0xFFF1F5F9);
  // }

  /// Retorna a cor apropriada de acordo com o tema atual.
  ///
  /// [context] — o contexto do widget.
  /// [lightColor] — cor para tema claro.
  /// [darkColor] — cor para tema escuro.
  static Color resolveThemeColor(BuildContext context, {required Color lightColor, required Color darkColor}) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkColor : lightColor;
  }

}
