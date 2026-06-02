import 'package:flutter/material.dart';

class CommonRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;
  final double edgeOffset;
  final double displacement;

  const CommonRefreshIndicator({
    super.key,
    required this.child,
    this.onRefresh,
    this.edgeOffset = 0,
    this.displacement = 40,
  });

  Future<void> _defaultRefresh() {
    return Future<void>.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      color: colorScheme.primary,
      backgroundColor: colorScheme.surface,
      edgeOffset: edgeOffset,
      displacement: displacement,
      onRefresh: onRefresh ?? _defaultRefresh,
      child: child,
    );
  }
}
