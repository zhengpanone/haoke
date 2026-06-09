import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/pages/home/info/info.dart';
import 'package:haoke_app/pages/room_detail/data.dart';
import 'package:haoke_app/services/api_service.dart';
import 'package:haoke_app/widgets/common_price_text.dart';
import 'package:haoke_app/widgets/common_icon_badge.dart';
import 'package:haoke_app/widgets/common_swipper.dart';
import 'package:haoke_app/widgets/common_tag.dart';
import 'package:haoke_app/widgets/common_title.dart';
import 'package:haoke_app/widgets/room_appliance.dart';

const buttonBottomTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
  fontWeight: FontWeight.w700,
);

class RoomDetailPage extends StatefulWidget {
  final String roomId;

  const RoomDetailPage({super.key, required this.roomId});

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  final ApiService _apiService = ApiService();
  RoomDetailData? data;
  late bool isLike;
  late bool showAllText;
  bool isLoading = true;
  bool isFavoriteLoading = false;
  bool isBookingViewing = false;
  String? errorMessage;

  @override
  void initState() {
    isLike = false;
    showAllText = false;
    super.initState();
    _loadRoomDetail();
  }

  Future<void> _loadRoomDetail() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await _apiService.queryRoomDetail(widget.roomId);
      if (!mounted) return;

      if (response.isSuccess && response.data != null) {
        final loadedData = response.data!;
        setState(() {
          data = loadedData;
          isLoading = false;
        });
        _loadFavoriteState(loadedData.id);
      } else {
        setState(() {
          errorMessage = response.message.isEmpty
              ? context.tr('load_room_detail_failed')
              : response.message;
          isLoading = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        errorMessage = context.tr('load_room_detail_failed');
        isLoading = false;
      });
    }
  }

  Future<void> _loadFavoriteState(String roomId) async {
    if (roomId.isEmpty) return;
    try {
      final response = await _apiService.checkFavorite(roomId);
      if (!mounted) return;
      if (response.isSuccess) {
        setState(() => isLike = response.data ?? false);
      }
    } catch (_) {}
  }

  Future<void> _toggleFavorite(RoomDetailData detail) async {
    if (isFavoriteLoading) return;
    setState(() => isFavoriteLoading = true);
    try {
      if (isLike) {
        final response = await _apiService.removeFavorite(detail.id);
        if (!mounted) return;
        if (response.isSuccess) {
          setState(() => isLike = false);
          _showTip(context, '已取消收藏');
        }
      } else {
        final response = await _apiService.addFavorite(
          houseId: detail.id,
          title: detail.title,
          address: detail.community,
          price: detail.price.toDouble(),
          tags: detail.tags,
          imageUrl: detail.houseImages.isEmpty
              ? null
              : detail.houseImages.first,
        );
        if (!mounted) return;
        if (response.isSuccess) {
          setState(() => isLike = true);
          _showTip(context, '已收藏房源');
        }
      }
    } finally {
      if (mounted) {
        setState(() => isFavoriteLoading = false);
      }
    }
  }

  Future<void> _bookViewing(RoomDetailData detail) async {
    if (isBookingViewing) return;
    setState(() => isBookingViewing = true);
    try {
      final response = await _apiService.createViewingRecord(
        houseId: detail.id,
        title: detail.title,
        address: detail.community,
        appointmentTime: DateTime.now().add(const Duration(days: 1)),
        note: '来自房源详情页预约',
      );
      if (!mounted) return;
      _showTip(context, response.isSuccess ? '看房预约已提交' : '预约失败');
    } finally {
      if (mounted) {
        setState(() => isBookingViewing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = data;

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(context.tr('property_details'))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (detail == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.tr('property_details'))),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 52,
                  color: Color(0xFF9AA8A5),
                ),
                const SizedBox(height: 12),
                Text(
                  errorMessage ?? context.tr('load_room_detail_failed'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF5A6966)),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: _loadRoomDetail,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(context.tr('retry')),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final showTextTool = detail.subTitle.length > 100;

    return Scaffold(
      appBar: AppBar(
        title: Text(detail.title),
        actions: [
          IconButton(
            onPressed: () async {
              await Clipboard.setData(
                const ClipboardData(text: 'http://www.baidu.com'),
              );
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.tr('share_link_copied'))),
              );
            },
            icon: const CommonIconBadge(
              icon: Icons.share_rounded,
              boxSize: 32,
              iconSize: 16,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 110),
            children: [
              CommonSwipper(images: detail.houseImages),
              const SizedBox(height: 8),
              CommonTitle(detail.title),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: CommonPriceText(
                  price: detail.price.toString(),
                  unit: context.tr('per_month'),
                  color: const Color(0xFF0F8F7A),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                child: Wrap(
                  spacing: 4,
                  children: detail.tags
                      .map((item) => CommonTag(tagText: item))
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),
              _buildSectionCard(
                child: Wrap(
                  runSpacing: 16,
                  children: [
                    BaseInfoItem(
                      '${context.tr('area_label')}: ${detail.size}${context.tr('sqm')}',
                    ),
                    BaseInfoItem(
                      '${context.tr('floor_label')}: ${detail.floor}',
                    ),
                    BaseInfoItem(
                      '${context.tr('type_label')}: ${detail.roomType}',
                    ),
                    BaseInfoItem(
                      '${context.tr('orientation_label')}: ${detail.oriented.join('/')}',
                    ),
                  ],
                ),
              ),
              CommonTitle(context.tr('house_facilities')),
              _buildSectionCard(
                child: RoomApplianceList(list: detail.applicances),
              ),
              CommonTitle(context.tr('house_description')),
              _buildSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.subTitle.isEmpty
                          ? context.tr('no_description_yet')
                          : detail.subTitle,
                      maxLines: showAllText ? null : 5,
                      style: const TextStyle(
                        height: 1.5,
                        color: Color(0xFF394C49),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        showTextTool
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showAllText = !showAllText;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      showAllText
                                          ? context.tr('collapse')
                                          : context.tr('expand'),
                                    ),
                                    Icon(
                                      showAllText
                                          ? Icons.keyboard_arrow_up_rounded
                                          : Icons.keyboard_arrow_down_rounded,
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        Text(
                          context.tr('report'),
                          style: const TextStyle(color: Color(0xFF7B8885)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CommonTitle(context.tr('you_may_also_like')),
              const Info(),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 18,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _toggleFavorite(detail),
                    child: SizedBox(
                      height: 50,
                      width: 52,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            isLike
                                ? Icons.bookmark_added_rounded
                                : Icons.bookmark_add_rounded,
                            color: isLike
                                ? const Color(0xFF0F8F7A)
                                : const Color(0xFF516360),
                            size: 22,
                          ),
                          Text(
                            isLike
                                ? context.tr('saved_listing')
                                : context.tr('save_listing'),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4AA9D8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          context.tr('contact_owner'),
                          style: buttonBottomTextStyle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _bookViewing(detail),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F8F7A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            isBookingViewing
                                ? '提交中'
                                : context.tr('book_viewing'),
                            style: buttonBottomTextStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3ECE9)),
      ),
      child: child,
    );
  }
}

void _showTip(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

class BaseInfoItem extends StatelessWidget {
  final String content;

  const BaseInfoItem(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 3 * 22) / 2,
      child: Text(
        content,
        style: const TextStyle(fontSize: 14, color: Color(0xFF334845)),
      ),
    );
  }
}
