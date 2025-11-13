import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/home/info/info.dart';
import 'package:haoke_rent/pages/room_detail/data.dart';
import 'package:haoke_rent/widgets/common_price_text.dart';
import 'package:haoke_rent/widgets/common_swipper.dart';
import 'package:haoke_rent/widgets/common_tag.dart';
import 'package:haoke_rent/widgets/common_title.dart';
import 'package:haoke_rent/widgets/room_appliance.dart';
import 'package:share_plus/share_plus.dart';

var buttonBottomTextStyle = TextStyle(fontSize: 18, color: Colors.white);

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
    setState(() {
      data = defaultData;
      isLike = false;
      showAllText = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var showTextTool = data.subTitle.length > 100;
    if (data == null) return Container();
    return Scaffold(
      appBar: AppBar(
        title: Text('房源详情:${data.title}'),
        actions: [
          IconButton(
            onPressed: () {
              Share.share('http://www.baidu.com');
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              CommonSwipper(images: data.houseImages),
              CommonTitle(data.title),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: CommonPriceText(
                  price: data.price.toString(),
                  unit: '元/月（押一付三）',
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 6,
                  top: 6,
                ),
                child: Wrap(
                  spacing: 4.0,
                  children: data.tags
                      .map((item) => CommonTag(tagText: item))
                      .toList(),
                ),
              ),
              Divider(color: Colors.grey, indent: 10, endIndent: 10),
              Container(
                padding: EdgeInsets.only(
                  left: 10,
                  top: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: Wrap(
                  runSpacing: 20,
                  children: [
                    BaseInfoItem('面积：${data.size}平方米'),
                    BaseInfoItem('楼层：${data.floor}'),
                    BaseInfoItem('房型：${data.roomType}'),
                    BaseInfoItem('装修：${data.size}'),
                  ],
                ),
              ),
              CommonTitle("房屋配置"),
              RoomApplianceList(list: data.applicances),
              CommonTitle("房屋概况"),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.subTitle ?? '暂无房屋概况',
                      maxLines: showAllText ? null : 5,
                    ),
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
                                    Text(showAllText ? '收起' : '展开'),
                                    Icon(
                                      showAllText
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        Text('举报'),
                      ],
                    ),
                  ],
                ),
              ),
              CommonTitle("猜你喜欢"),
              Info(),
              Container(height: 100),
            ],
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            height: 100,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
                top: 10,
              ),
              color: Colors.grey[200],

              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLike = !isLike;
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 40,
                      margin: EdgeInsets.only(right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            isLike ? Icons.star : Icons.star_border,
                            color: isLike ? Colors.green : Colors.black,
                            size: 24,
                          ),
                          Text(
                            isLike ? '已收藏' : '收藏',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text('联系房东', style: buttonBottomTextStyle),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text('预约看房', style: buttonBottomTextStyle),
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
}

class BaseInfoItem extends StatelessWidget {
  final String content;
  const BaseInfoItem(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(content, style: TextStyle(fontSize: 16)),
      width: (MediaQuery.of(context).size.width - 3 * 10) / 2,
    );
  }
}
