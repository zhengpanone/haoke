import 'package:flutter/material.dart';
import 'package:haoke_app/models/news/news_article.dart';
import 'package:haoke_app/services/api_service.dart';
import 'package:haoke_app/widgets/common_image.dart';

class NewsDetailPage extends StatefulWidget {
  final String newsId;

  const NewsDetailPage({super.key, required this.newsId});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  NewsArticle? _article;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadArticle();
  }

  Future<void> _loadArticle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final response = await _apiService.queryNewsArticleDetail(widget.newsId);
      if (!mounted) return;
      setState(() {
        _article = response.isSuccess ? response.data : null;
        _isLoading = false;
        _errorMessage = _article == null ? '资讯不存在或已下架' : '';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _article = null;
        _isLoading = false;
        _errorMessage = '资讯加载失败，稍后再试';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('资讯详情')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final article = _article;
    if (article == null) {
      return Center(
        child: Text(_errorMessage, style: TextStyle(color: Colors.grey[600])),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        Text(
          article.title,
          style: const TextStyle(
            color: Color(0xFF1F2B2A),
            fontSize: 22,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(article.source, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(width: 12),
            Text(article.timeLabel, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        const SizedBox(height: 16),
        if (article.coverUrl.isNotEmpty)
          CommonImage(
            imageUrl: article.coverUrl,
            height: 190,
            borderRadius: BorderRadius.circular(12),
          ),
        if (article.summary.isNotEmpty) ...[
          const SizedBox(height: 18),
          Text(
            article.summary,
            style: const TextStyle(
              color: Color(0xFF52615E),
              fontSize: 15,
              height: 1.55,
            ),
          ),
        ],
        const SizedBox(height: 18),
        Text(
          article.content.replaceAll(r'\n', '\n'),
          style: const TextStyle(
            color: Color(0xFF24312F),
            fontSize: 16,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}
