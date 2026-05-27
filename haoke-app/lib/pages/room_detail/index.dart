import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haoke_rent/pages/home/info/info.dart';
import 'package:haoke_rent/pages/room_detail/data.dart';
import 'package:haoke_rent/widgets/common_price_text.dart';
import 'package:haoke_rent/widgets/common_swipper.dart';
import 'package:haoke_rent/widgets/common_tag.dart';
import 'package:haoke_rent/widgets/common_title.dart';
import 'package:haoke_rent/widgets/room_appliance.dart';

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
  late RoomDetailData data;
  late bool isLike;
  late bool showAllText;

  @override
  void initState() {
    data = defaultData;
    isLike = false;
    showAllText = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final showTextTool = data.subTitle.length > 100;

    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
        actions: [
          IconButton(
            onPressed: () async {
              await Clipboard.setData(
                const ClipboardData(text: 'http://www.baidu.com'),
              );
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('分享链接已复制')),
              );
            },
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 110),
            children: [
              CommonSwipper(images: data.houseImages),
              const SizedBox(height: 8),
              CommonTitle(data.title),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: CommonPriceText(
                  price: data.price.toString(),
                  unit: '/month',
                  color: const Color(0xFF0F8F7A),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                child: Wrap(
                  spacing: 4,
                  children: data.tags
                      .map((item) => CommonTag(tagText: item))
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),
              _buildSectionCard(
                child: Wrap(
                  runSpacing: 16,
                  children: [
                    BaseInfoItem('Area: ${data.size} sqm'),
                    BaseInfoItem('Floor: ${data.floor}'),
                    BaseInfoItem('Type: ${data.roomType}'),
                    BaseInfoItem('Orientation: ${data.oriented.join('/')}'),
                  ],
                ),
              ),
              const CommonTitle('House Facilities'),
              _buildSectionCard(
                  child: RoomApplianceList(list: data.applicances)),
              const CommonTitle('House Description'),
              _buildSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.subTitle.isEmpty
                          ? 'No description yet'
                          : data.subTitle,
                      maxLines: showAllText ? null : 5,
                      style: const TextStyle(
                          height: 1.5, color: Color(0xFF394C49)),
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
                                    Text(showAllText ? 'Collapse' : 'Expand'),
                                    Icon(
                                      showAllText
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        const Text('Report',
                            style: TextStyle(color: Color(0xFF7B8885))),
                      ],
                    ),
                  ],
                ),
              ),
              const CommonTitle('You May Also Like'),
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
                    onTap: () {
                      setState(() {
                        isLike = !isLike;
                      });
                    },
                    child: SizedBox(
                      height: 50,
                      width: 52,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            isLike
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isLike
                                ? const Color(0xFF0F8F7A)
                                : const Color(0xFF516360),
                            size: 22,
                          ),
                          Text(
                            isLike ? 'Saved' : 'Save',
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
                      child: const Center(
                        child:
                            Text('Contact Owner', style: buttonBottomTextStyle),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F8F7A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child:
                            Text('Book Viewing', style: buttonBottomTextStyle),
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
