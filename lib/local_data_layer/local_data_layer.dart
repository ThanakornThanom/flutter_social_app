import 'package:shared_preferences/shared_preferences.dart';
import 'package:verbose_share_world/app_config/app_config.dart';

class LocalDataLayer {
  LocalDataLayer._privateConstructor() {
    _initPref();
  }

  static final LocalDataLayer _instance = LocalDataLayer._privateConstructor();
  SharedPreferences? _sharedPreferences;

  factory LocalDataLayer() {
    return _instance;
  }

  static const String keyCurrentLang = "key_cur_lang";

  _initPref() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  Future<String?> getCurrentLanguage() async {
    await _initPref();
    return _sharedPreferences!.containsKey(keyCurrentLang)
        ? _sharedPreferences!.getString(keyCurrentLang)
        : AppConfig.languageDefault;
  }

  Future<bool> setCurrentLanguage(String langCode) async {
    await _initPref();
    return _sharedPreferences!.setString(keyCurrentLang, langCode);
  }
}
