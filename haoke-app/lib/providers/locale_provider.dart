import 'package:flutter/material.dart';
import 'package:haoke_rent/l10n/app_localizations.dart';
import 'package:haoke_rent/services/storage_service.dart';

class LocaleProvider with ChangeNotifier {
  static const String _languageKey = 'app_language';
  final StorageService _storageService = StorageService.instance;

  Locale _locale = AppLocalizations.supportedLocales.first;

  Locale get locale => _locale;

  String get localeCode {
    if (_locale.countryCode == null || _locale.countryCode!.isEmpty) {
      return _locale.languageCode;
    }
    return '${_locale.languageCode}_${_locale.countryCode}';
  }

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final code = await _storageService.getString(_languageKey);
    if (code == null || code.isEmpty) return;
    _locale = _localeFromCode(code);
    notifyListeners();
  }

  Future<void> setLocaleByCode(String code) async {
    final next = _localeFromCode(code);
    if (next == _locale) return;
    _locale = next;
    await _storageService.saveLanguage(code);
    notifyListeners();
  }

  Locale _localeFromCode(String code) {
    final locale = code.contains('_')
        ? (() {
            final parts = code.split('_');
            return Locale(parts[0], parts.length > 1 ? parts[1] : null);
          })()
        : Locale(code);

    final isSupported = AppLocalizations.supportedLocales.any((item) =>
        item.languageCode == locale.languageCode &&
        (item.countryCode ?? '') == (locale.countryCode ?? ''));
    if (isSupported) {
      return locale;
    }

    return AppLocalizations.supportedLocales.first;
  }
}
