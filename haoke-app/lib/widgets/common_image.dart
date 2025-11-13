import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CommonImage extends StatelessWidget {
  // 图片URL
  final String imageUrl;

  // 宽度
  final double? width;

  // 高度
  final double? height;

  // 图片适配方式
  final BoxFit? fit;

  // 错误图标
  final IconData? errorIcon;

  final BorderRadius? borderRadius; // 圆角

  const CommonImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorIcon,
    this.borderRadius,
  });

  bool get isNetwork => RegExp(r'^https?://').hasMatch(imageUrl);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (isNetwork) {
      // 网络图片（带缓存）
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        width: width,
        height: height,
        cacheManager: MyCacheManager(), // 使用自定义缓存
        // placeholder: (context, url) => CircularProgressIndicator(), // 加载中
        // errorWidget: (context, url, error) => Icon(Icons.error), // 加载失败
        // placeholder: (context, url) => Container(
        //   width: width,
        //   height: height,
        //   color: Colors.grey.shade200,
        //   child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        // ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: Colors.grey.shade300,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    } else {
      imageWidget = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
      );
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: imageWidget,
    );
  }
}

/// 自定义缓存管理器（缓存 7 天，最多 200 张）
class MyCacheManager extends CacheManager {
  static const key = "myCustomCache";

  MyCacheManager()
    : super(
        Config(
          key,
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 200,
        ),
      );
}
