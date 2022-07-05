import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbose_share_world/app_config/app_config.dart';
import 'package:verbose_share_world/local_data_layer/local_data_layer.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(Locale(AppConfig.languageDefault));

  void selectLanguage(String countryCode) {
    emit(Locale(countryCode));
  }

  void getCurrentLanguage() async {
    String? currLang = await (LocalDataLayer().getCurrentLanguage());
    selectLanguage(currLang!);
  }

  void setCurrentLanguage(String langCode) async {
    await LocalDataLayer().setCurrentLanguage(langCode);
    selectLanguage(langCode);
  }
}
