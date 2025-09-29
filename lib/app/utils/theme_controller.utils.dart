class ThemeController {
  // Singleton instance
  static final ThemeController instance = ThemeController._internal();

  // Valor do tema atual
  bool isThemeDark = false;

  // Construtor privado
  ThemeController._internal();

  // Método para alternar o tema
  void toggleTheme() {
    isThemeDark = !isThemeDark;
  }

  // Método para definir explicitamente o tema
  void setTheme(bool dark) {
    isThemeDark = dark;
  }
}