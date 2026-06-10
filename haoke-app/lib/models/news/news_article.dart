class NewsArticle {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String coverUrl;
  final String source;
  final int status;
  final int sort;
  final DateTime? publishTime;

  const NewsArticle({
    required this.id,
    required this.title,
    this.summary = '',
    this.content = '',
    this.coverUrl = '',
    this.source = '好客资讯',
    this.status = 1,
    this.sort = 0,
    this.publishTime,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    final source = json['source']?.toString() ?? '';
    return NewsArticle(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      coverUrl: json['coverUrl']?.toString() ?? '',
      source: source.isNotEmpty ? source : '好客资讯',
      status: _intValue(json['status'], fallback: 1),
      sort: _intValue(json['sort']),
      publishTime: _parseDate(json['publishTime']),
    );
  }

  String get timeLabel {
    if (publishTime == null) return '';
    final diff = DateTime.now().difference(publishTime!);
    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inHours < 1) return '${diff.inMinutes}分钟前';
    if (diff.inDays < 1) return '${diff.inHours}小时前';
    if (diff.inDays < 7) return '${diff.inDays}天前';
    return '${publishTime!.year}-${_pad(publishTime!.month)}-${_pad(publishTime!.day)}';
  }

  static int _intValue(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static String _pad(int value) => value.toString().padLeft(2, '0');
}
