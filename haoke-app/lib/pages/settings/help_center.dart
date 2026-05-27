import 'package:flutter/material.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final List<FAQItem> _faqList = [
    FAQItem(
        question: 'How do I publish a listing?',
        answer:
            'Go to Home > Me > Room Management > Publish New Listing. Complete details and submit.'),
    FAQItem(
        question: 'How can I contact landlord?',
        answer:
            'Open any listing detail page and tap Contact Owner or Book Viewing.'),
    FAQItem(
        question: 'How long does listing review take?',
        answer: 'Usually 1-3 business days depending on listing completeness.'),
    FAQItem(
        question: 'How can I edit my listing?',
        answer: 'Open Room Management and edit your target listing card.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Center')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search questions',
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
          const Text('Popular Questions',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 8),
          ..._faqList.map(_buildFAQItem),
          const SizedBox(height: 14),
          const Text('Contact Support',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 8),
          _buildContactItem(
              icon: Icons.phone_rounded,
              title: 'Support Hotline',
              subtitle: '400-888-9999',
              action: 'Call'),
          const SizedBox(height: 10),
          _buildContactItem(
              icon: Icons.email_outlined,
              title: 'Support Email',
              subtitle: 'support@haoke.com',
              action: 'Email'),
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
          Icon(icon),
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
