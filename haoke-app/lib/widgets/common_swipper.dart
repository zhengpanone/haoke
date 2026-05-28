import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:haoke_rent/l10n/app_localizations.dart';
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
  final bool indicatorInside;

  const CommonSwipper({
    super.key,
    this.images = defaultImagList,
    this.indicatorInside = false,
  });

  @override
  State<CommonSwipper> createState() => _CommonSwipperState();
}

class _CommonSwipperState extends State<CommonSwipper> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.width / defaultWidth * defaultHeight;
    if (widget.images.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(child: Text(context.tr('no_images_yet'))),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CarouselSlider(
                  carouselController: _controller,
                  items: widget.images
                      .map(
                        (item) => SizedBox.expand(
                          child: CommonImage(imageUrl: item, fit: BoxFit.cover),
                        ),
                      )
                      .toList(),
                  options: CarouselOptions(
                    height: height,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 700),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    viewportFraction: 1.0,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                ),
              ),
              Positioned(
                left: 14,
                bottom: 14,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${_current + 1}/${widget.images.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              if (widget.indicatorInside)
                Positioned(
                  bottom: 12,
                  right: 0,
                  left: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.images.length, (index) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: _current == index ? 18 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            color: _current == index
                                ? const Color(0xFF0F8F7A)
                                : Colors.white.withValues(alpha: 0.55),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
          if (!widget.indicatorInside)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.images.length, (index) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: _current == index ? 18 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: _current == index
                            ? const Color(0xFF0F8F7A)
                            : const Color(0xFFDAE7E3),
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
