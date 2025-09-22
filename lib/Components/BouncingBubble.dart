import 'package:flutter/material.dart';

class BouncingBubble extends StatefulWidget {
  final double size;
  final double left;
  final double top;
  final Color color;
  final Duration? duration;
  final double bounceHeight;

  const BouncingBubble({
    super.key,
    required this.size,
    required this.left,
    required this.top,
    required this.color,
    this.duration = const Duration(seconds: 2),
    this.bounceHeight = 15,
  });

  @override
  State<BouncingBubble> createState() => _BouncingBubbleState();
}

class _BouncingBubbleState extends State<BouncingBubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: widget.bounceHeight).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: widget.left,
          top: widget.top + _animation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withOpacity(0.1),
            ),
          ),
        );
      },
    );
  }
}
