import 'package:flutter/material.dart';
import 'dart:async';

class SliderCarouselWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const SliderCarouselWidget({super.key, required this.data});

  @override
  State<SliderCarouselWidget> createState() => _SliderCarouselWidgetState();
}

class _SliderCarouselWidgetState extends State<SliderCarouselWidget> {
  final PageController _pageController = PageController(viewportFraction: 0.95);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    if (widget.data.isNotEmpty) {
      Timer.periodic(const Duration(seconds: 4), (timer) {
        if (_pageController.hasClients) {
          _currentPage = (_currentPage + 1) % widget.data.length;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }


  String _extractMainValue(String value) {
    return value.contains("~") ? value.split("~")[0] : value;
  }

  String _formatKey(String key) {
    return key
        .replaceAll("_", " ")
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  final List<Color> iconColors = [
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          final item = widget.data[index];
          final key = _formatKey(item['key']);
          final rawValue = item['value'].toString();
          final mainValue = _extractMainValue(rawValue);
          final iconColor = iconColors[index % iconColors.length];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: iconColor.withOpacity(0.2),
                      ),
                      child: Icon(Icons.pie_chart, color: iconColor, size: 28),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            key,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            mainValue,
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
