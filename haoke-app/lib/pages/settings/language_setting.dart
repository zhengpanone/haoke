import 'package:flutter/material.dart';
import 'package:haoke_rent/l10n/app_localizations.dart';
import 'package:haoke_rent/providers/locale_provider.dart';
import 'package:haoke_rent/widgets/common_icon_badge.dart';
import 'package:provider/provider.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  final List<Language> _languages = const [
    Language(
      code: 'zh',
      nameKey: 'lang_zh',
      nativeName: '简体中文',
      isDefault: true,
    ),
    Language(code: 'en', nameKey: 'lang_en', nativeName: 'English'),
  ];

  String _selectedLanguageCode = 'zh';
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }
    final localeCode = context.read<LocaleProvider>().localeCode;
    _selectedLanguageCode = _languages.any((item) => item.code == localeCode)
        ? localeCode
        : _languages.first.code;
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final current = _getCurrentLanguage();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('language')),
        actions: [
          TextButton(onPressed: _saveSettings, child: Text(context.tr('save')))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F6F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const CommonIconBadge(
                  icon: Icons.info_outline_rounded,
                  boxSize: 30,
                  iconSize: 15,
                  radius: 9,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${context.tr('current_language')}: ${context.tr(current.nameKey)}',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ..._languages.map(_buildLanguageItem),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(Language language) {
    final isSelected = _selectedLanguageCode == language.code;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => _selectedLanguageCode = language.code),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              if (language.isDefault)
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F8F7A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(context.tr('default'),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 10)),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tr(language.nameKey),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      language.nativeName,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF81908D)),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isSelected
                    ? const Color(0xFF0F8F7A)
                    : const Color(0xFFB0BCBA),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Language _getCurrentLanguage() {
    return _languages.firstWhere(
      (lang) => lang.code == _selectedLanguageCode,
      orElse: () => _languages.first,
    );
  }

  Future<void> _saveSettings() async {
    final selectedLanguage = _getCurrentLanguage();
    await context.read<LocaleProvider>().setLocaleByCode(selectedLanguage.code);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${context.tr('language_switched_to')} ${context.tr(selectedLanguage.nameKey)}',
        ),
      ),
    );
    Navigator.pop(context);
  }
}

class Language {
  final String code;
  final String nameKey;
  final String nativeName;
  final bool isDefault;

  const Language({
    required this.code,
    required this.nameKey,
    required this.nativeName,
    this.isDefault = false,
  });
}
