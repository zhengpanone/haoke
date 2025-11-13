import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:haoke_rent/widgets/common_image.dart';

const List<String> defaultImagList = [
  'https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg',
  'https://images.pexels.com/photos/32613165/pexels-photo-32613165.jpeg',
  'https://images.pexels.com/photos/33419928/pexels-photo-33419928.jpeg',
];
const double defaultHeight = 424;
const double defaultWidth = 750;

class CommonSwipper extends StatefulWidget {
  final List<String> images;
  final bool indicatorInside; // 是否在图片上叠加指示器

  const CommonSwipper({
    super.key,
    this.images = defaultImagList,
    this.indicatorInside = false,
  });

  @override
  State<CommonSwipper> createState() => _CommonSwipperState();
}

class _CommonSwipperState extends State<CommonSwipper> {
  int _current = 0; // 当前轮播索引

  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    var height =
        MediaQuery.of(context).size.width / defaultWidth * defaultHeight;
    if (widget.images.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(child: Text("暂无图片")),
      );
    }

    return Column(
      children: [
        Stack(
          children: [
            CarouselSlider(
              carouselController: _controller,
              items: widget.images
                  .map(
                    (item) => ClipRRect(
                      // borderRadius: BorderRadius.circular(12), // 圆角
                      child: SizedBox.expand(
                        // child: Image.network(item, fit: BoxFit.cover),
                        child: CommonImage(imageUrl: item, fit: BoxFit.cover),
                      ),
                    ),
                  )
                  .toList(),

              options: CarouselOptions(
                height: height,
                autoPlay: true, // 自动轮播
                autoPlayInterval: const Duration(seconds: 3), // 轮播间隔
                autoPlayAnimationDuration: Duration(milliseconds: 800), // 动画时间
                autoPlayCurve: Curves.fastOutSlowIn, // 动画曲线
                viewportFraction: 1.0, // 每页占满屏幕宽度
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                aspectRatio: 2.0, // 高宽比，可按需调整
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),

            if (widget.indicatorInside)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.images.length, (index) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(index),
                      child: Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Colors.red
                              : Colors.white.withOpacity(0.6),
                        ),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
        if (!widget.indicatorInside) // 在图片下方显示指示器
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (index) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(index),
                  child: Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index ? Colors.red : Colors.grey[300],
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
