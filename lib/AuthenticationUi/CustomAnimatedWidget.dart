
import 'package:flutter/material.dart';

class CustomAnimatedWidget extends StatefulWidget{
  final Widget child;
  final Duration? duration;
  final Offset? beginOffset;
  final Curve slideCurve;
  final Curve fadeCurve;

  const CustomAnimatedWidget({
    super.key,
    required this.child,
    this.duration,
    this.beginOffset,
    this.slideCurve = Curves.easeOut,
    this.fadeCurve = Curves.easeIn,
  });

  @override
  State<CustomAnimatedWidget> createState(){
    return CustomSlideAnimatedWidget();
  }

}

class CustomSlideAnimatedWidget extends State<CustomAnimatedWidget> with TickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;


  @override

  void initState() {
    super.initState();

    _controller=AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _slideAnimation=Tween<Offset>(
      begin:widget.beginOffset,
      end:Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.slideCurve));

    _fadeAnimation=Tween<double>(
        begin: 0,
        end: 1
    ).animate(CurvedAnimation(parent: _controller, curve: widget.fadeCurve));
    _controller.forward();
  }
  @override

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context){
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),

    );
  }
}