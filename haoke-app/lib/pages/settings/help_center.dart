import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/models/profile/profile_models.dart';
import 'package:haoke_app/services/api_service.dart';
import 'package:haoke_app/widgets/common_icon_badge.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final ApiService _apiService = ApiService();

  List<ContactChannelModel> _contacts = const [
    ContactChannelModel(
      type: 'phone',
      title: '客服热线',
      value: '400-888-9999',
      description: '工作日 09:00-18:00',
    ),
    ContactChannelModel(
      type: 'email',
      title: '客服邮箱',
      value: 'support@haoke.com',
      description: '24 小时内回复',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    try {
      final response = await _apiService.queryContactChannels();
      if (!mounted || !response.isSuccess || response.data == null) return;
      setState(() => _contacts = response.data!);
    } catch (_) {
      // Keep default contact channels.
    }
  }

  @override
  Widget build(BuildContext context) {
    final faqList = [
      FAQItem(
        question: context.tr('faq_publish_q'),
        answer: context.tr('faq_publish_a'),
      ),
      FAQItem(
        question: context.tr('faq_contact_q'),
        answer: context.tr('faq_contact_a'),
      ),
      FAQItem(
        question: context.tr('faq_review_q'),
        answer: context.tr('faq_review_a'),
      ),
      FAQItem(
        question: context.tr('faq_edit_q'),
        answer: context.tr('faq_edit_a'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('help_center'))),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: context.tr('search_questions'),
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            context.tr('popular_questions'),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ...faqList.map(_buildFAQItem),
          const SizedBox(height: 14),
          Text(
            context.tr('contact_support'),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ..._contacts.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildContactItem(item),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(FAQItem faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ExpansionTile(
        title: Text(faq.question),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        children: [
          Text(
            faq.answer,
            style: const TextStyle(color: Color(0xFF5D6B68), height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(ContactChannelModel item) {
    final icon = switch (item.type) {
      'email' => Icons.email_rounded,
      'wechat' => Icons.chat_bubble_rounded,
      _ => Icons.phone_rounded,
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CommonIconBadge(icon: icon, boxSize: 34, iconSize: 17),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  item.value,
                  style: const TextStyle(
                    color: Color(0xFF0F8F7A),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (item.description.isNotEmpty)
                  Text(
                    item.description,
                    style: const TextStyle(
                      color: Color(0xFF7D8B88),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            context.tr(item.type == 'email' ? 'email' : 'call'),
            style: const TextStyle(
              color: Color(0xFF0F8F7A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
