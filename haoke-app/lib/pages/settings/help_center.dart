import 'package:flutter/material.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final List<FAQItem> _faqList = [
    FAQItem(
      question: '如何发布房源？',
      answer: '1. 登录账号后，点击底部导航栏的"发布"按钮\n'
          '2. 填写房源基本信息（标题、描述、价格等）\n'
          '3. 上传房源图片（最多9张）\n'
          '4. 设置租赁方式和租期要求\n'
          '5. 提交审核，等待管理员审核通过',
    ),
    FAQItem(
      question: '如何联系房东？',
      answer: '1. 在房源详情页点击"联系房东"按钮\n'
          '2. 可以通过在线聊天、电话或留言功能联系\n'
          '3. 建议在平台内沟通，平台会记录聊天记录\n'
          '4. 为了保护双方隐私，请勿在平台外联系',
    ),
    FAQItem(
      question: '房源审核需要多久？',
      answer: '正常审核时间为1-3个工作日。我们会尽快处理您的房源申请，请耐心等待。',
    ),
    FAQItem(
      question: '如何修改已发布的房源？',
      answer: '1. 进入"我的"-"我的发布"\n'
          '2. 找到需要修改的房源\n'
          '3. 点击"编辑"按钮进行修改\n'
          '4. 修改后需要重新审核',
    ),
    FAQItem(
      question: '如何申请退租？',
      answer: '1. 在"我的订单"中找到需要退租的订单\n'
          '2. 点击"申请退租"并填写退租原因\n'
          '3. 等待房东确认\n'
          '4. 确认后按照约定办理退租手续',
    ),
    FAQItem(
      question: '如何设置消息通知？',
      answer: '1. 进入"设置"-"通知设置"\n'
          '2. 开启或关闭相应的通知开关\n'
          '3. 可以设置免打扰时间',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('帮助中心'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // 搜索栏
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索问题...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 0.0,
                ),
              ),
            ),
          ),

          // 热门问题
          _buildSectionTitle('热门问题'),
          ..._faqList.take(3).map((faq) => _buildFAQItem(faq)),

          // 所有问题
          _buildSectionTitle('常见问题'),
          ..._faqList.map((faq) => _buildFAQItem(faq)),

          // 联系我们
          _buildSectionTitle('联系我们'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContactItem(
                  icon: Icons.phone,
                  title: '客服热线',
                  subtitle: '400-888-9999',
                  action: '拨打',
                  onTap: () {
                    // 拨打客服电话
                  },
                ),
                const SizedBox(height: 16),
                _buildContactItem(
                  icon: Icons.email,
                  title: '客服邮箱',
                  subtitle: 'support@haoke.com',
                  action: '发送邮件',
                  onTap: () {
                    // 发送邮件
                  },
                ),
                const SizedBox(height: 16),
                _buildContactItem(
                  icon: Icons.access_time,
                  title: '服务时间',
                  subtitle: '周一至周日 9:00-18:00',
                  action: '在线咨询',
                  onTap: () {
                    // 在线咨询
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 16.0,
        bottom: 8.0,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildFAQItem(FAQItem faq) {
    return ExpansionTile(
      title: Text(faq.question),
      childrenPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      children: [
        Text(
          faq.answer,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String action,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Text(
                action,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}