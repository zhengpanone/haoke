import 'package:flutter/material.dart';
import 'package:haoke_rent/l10n/app_localizations.dart';
import 'package:haoke_rent/widgets/common_icon_badge.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqList = [
      FAQItem(
          question: context.tr('faq_publish_q'),
          answer: context.tr('faq_publish_a')),
      FAQItem(
          question: context.tr('faq_contact_q'),
          answer: context.tr('faq_contact_a')),
      FAQItem(
          question: context.tr('faq_review_q'),
          answer: context.tr('faq_review_a')),
      FAQItem(
          question: context.tr('faq_edit_q'), answer: context.tr('faq_edit_a')),
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
          Text(context.tr('popular_questions'),
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 8),
          ...faqList.map(_buildFAQItem),
          const SizedBox(height: 14),
          Text(context.tr('contact_support'),
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 8),
          _buildContactItem(
              icon: Icons.phone_rounded,
              title: context.tr('support_hotline'),
              subtitle: '400-888-9999',
              action: context.tr('call')),
          const SizedBox(height: 10),
          _buildContactItem(
              icon: Icons.email_rounded,
              title: context.tr('support_email'),
              subtitle: 'support@haoke.com',
              action: context.tr('email')),
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
          Text(faq.answer,
              style: const TextStyle(color: Color(0xFF5D6B68), height: 1.45))
        ],
      ),
    );
  }

  Widget _buildContactItem(
      {required IconData icon,
      required String title,
      required String subtitle,
      required String action}) {
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
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: const TextStyle(
                        color: Color(0xFF7D8B88), fontSize: 12)),
              ],
            ),
          ),
          Text(action,
              style: const TextStyle(
                  color: Color(0xFF0F8F7A), fontWeight: FontWeight.w600)),
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
