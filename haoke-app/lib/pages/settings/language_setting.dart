import 'package:flutter/material.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  // 支持的语言列表
  final List<Language> _languages = [
    Language(
      code: 'zh',
      name: '简体中文',
      nativeName: '简体中文',
      isDefault: true,
    ),
    Language(
      code: 'zh_TW',
      name: '繁体中文',
      nativeName: '繁體中文',
    ),
    Language(
      code: 'en',
      name: 'English',
      nativeName: 'English',
    ),
    Language(
      code: 'ja',
      name: '日本語',
      nativeName: '日本語',
    ),
    Language(
      code: 'ko',
      name: '한국어',
      nativeName: '한국어',
    ),
  ];

  String _selectedLanguageCode = 'zh';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('语言设置'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: const Text(
              '保存',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 当前语言提示
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.red.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '当前语言: ${_getCurrentLanguage().nativeName}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),

          // 语言列表
          Expanded(
            child: ListView.builder(
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final language = _languages[index];
                return _buildLanguageItem(language);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(Language language) {
    return RadioListTile<String>(
      value: language.code,
      groupValue: _selectedLanguageCode,
      onChanged: (value) {
        setState(() {
          _selectedLanguageCode = value!;
        });
      },
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language.name,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(
            language.nativeName,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
      secondary: language.isDefault
          ? Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 2.0,
        ),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Text(
          '默认',
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      )
          : null,
      activeColor: Colors.red,
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('提示'),
        content: Text('是否将应用语言切换为 ${selectedLanguage.nativeName}？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _applyLanguageChange(selectedLanguage);
            },
            child: const Text('确定', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _applyLanguageChange(Language language) {
    // TODO: 实现语言切换逻辑
    // 1. 保存到本地存储
    // 2. 重启应用或重新加载语言资源
    // 3. 显示成功消息

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('语言已切换为 ${language.nativeName}'),
        backgroundColor: Colors.green,
      ),
    );

    // 延迟返回
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
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