import 'package:flutter/material.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/models/news/news_article.dart';
import 'package:haoke_app/pages/home/info/item_widget.dart';
import 'package:haoke_app/services/api_service.dart';

class Info extends StatefulWidget {
  final bool showTitle;
  final List<NewsArticle>? dataList;

  const Info({super.key, this.showTitle = false, this.dataList});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool _hasError = false;
  List<NewsArticle> _items = [];

  @override
  void initState() {
    super.initState();
    if (widget.dataList == null) {
      _loadNews();
    } else {
      _items = widget.dataList!;
    }
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final response = await _apiService.queryNewsArticles(pageSize: 6);
      if (!mounted) return;
      setState(() {
        _items = response.isSuccess && response.data != null
            ? response.data!
            : <NewsArticle>[];
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _items = [];
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showTitle)
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
            child: Text(
              context.tr('latest_news'),
              style: const TextStyle(
                color: Color(0xFF1F2B2A),
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        if (_isLoading)
          const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          )
        else if (_hasError)
          _InfoStateBox(message: '资讯加载失败，稍后再试')
        else if (_items.isEmpty)
          _InfoStateBox(message: '暂无最新资讯')
        else
          Column(
            children: _items.map((item) => ItemWidget(data: item)).toList(),
          ),
      ],
    );
  }
}

class _InfoStateBox extends StatelessWidget {
  final String message;

  const _InfoStateBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message, style: TextStyle(color: Colors.grey[600])),
    );
  }
}
