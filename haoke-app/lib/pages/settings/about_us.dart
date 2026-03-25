import 'package:flutter/material.dart';
import 'package:haoke_rent/config/app_config.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {






  @override
  void initState() {
    super.initState();

  }



  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('无法打开链接: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于我们'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // Logo和版本信息
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '好客租房',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '版本: 1.0.0 (11111)',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          // 应用介绍
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('应用介绍'),
                const Text(
                  '好客租房是一个专业的房屋租赁平台，致力于为用户提供真实、优质的房源信息。我们连接房东和租客，打造安全、便捷的租房体验。',
                  style: TextStyle(color: Colors.grey, height: 1.5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 核心功能
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('核心功能'),
                _buildFeatureItem('海量真实房源', '覆盖全国各大城市，房源信息真实可靠'),
                _buildFeatureItem('在线签约', '支持电子合同，安全便捷，随时查看'),
                _buildFeatureItem('信用体系', '完善的信用评价系统，保障双方权益'),
                _buildFeatureItem('24小时客服', '全天在线客服，随时为您解决问题'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 联系我们
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('联系我们'),
                _buildContactItem(
                  '官方网站',
                  'https://www.haoke.com',
                  Icons.language,
                ),
                _buildContactItem(
                  '商务合作',
                  'mailto:business@haoke.com',
                  Icons.business,
                ),
                _buildContactItem(
                  '意见反馈',
                  'mailto:feedback@haoke.com',
                  Icons.feedback,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 法律信息
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('法律信息'),
                _buildLegalItem(
                  '用户协议',
                  Icons.description,
                  () {
                    // 跳转到用户协议页面
                  },
                ),
                _buildLegalItem(
                  '隐私政策',
                  Icons.privacy_tip,
                  () {
                    // 跳转到隐私政策页面
                  },
                ),
                _buildLegalItem(
                  '免责声明',
                  Icons.warning,
                  () {
                    // 跳转到免责声明页面
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // 版权信息
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  '© ${DateTime.now().year} 好客租房 版权所有',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '备案号: 沪ICP备12345678号',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
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
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(String title, String url, IconData icon) {
    return InkWell(
      onTap: () => _launchUrl(url),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.red, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalItem(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.red, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
