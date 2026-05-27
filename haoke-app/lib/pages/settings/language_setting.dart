import 'package:flutter/material.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  final List<Language> _languages = [
    Language(
        code: 'zh',
        name: 'Simplified Chinese',
        nativeName: 'Chinese',
        isDefault: true),
    Language(
        code: 'zh_TW',
        name: 'Traditional Chinese',
        nativeName: 'Chinese Traditional'),
    Language(code: 'en', name: 'English', nativeName: 'English'),
    Language(code: 'ja', name: 'Japanese', nativeName: 'Japanese'),
    Language(code: 'ko', name: 'Korean', nativeName: 'Korean'),
  ];

  String _selectedLanguageCode = 'zh';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language'),
        actions: [
          TextButton(onPressed: _saveSettings, child: const Text('Save'))
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
                const Icon(Icons.info_outline_rounded),
                const SizedBox(width: 8),
                Expanded(
                    child:
                        Text('Current: ${_getCurrentLanguage().nativeName}')),
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
                  child: const Text('Default',
                      style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language.name,
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

  void _saveSettings() {
    final selectedLanguage = _getCurrentLanguage();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Language switched to ${selectedLanguage.nativeName}')),
    );
    Navigator.pop(context);
  }
}

class Language {
  final String code;
  final String name;
  final String nativeName;
  final bool isDefault;

  Language({
    required this.code,
    required this.name,
    required this.nativeName,
    this.isDefault = false,
  });
}
