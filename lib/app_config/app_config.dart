class AppConfig {
  static final String appName = 'Home';
  static final String packageName = '<package_name>';
  static final String languageDefault = "en";
  static final Map<String, String> languagesSupported = {
    'en': "English",
    'ar': "عربى",
    'pt': "Portugal",
    'fr': "Français",
    'id': "Bahasa Indonesia",
    'es': "Español",
  };
  final componentSize = Size();
}

class Size {
  double feedIconSize = 20;
  double feedReactionCountSize = 14;
}
