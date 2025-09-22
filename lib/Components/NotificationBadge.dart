import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Helpers/NotificationCounter.dart';
import 'package:digivity_admin_app/Helpers/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NotificationBadge extends StatefulWidget {
  const NotificationBadge({super.key});

  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isShaking = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // duration for 3 shakes
    );

    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -4.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -4.0, end: 4.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 4.0, end: -4.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -4.0, end: 4.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 4.0, end: 0.0), weight: 1),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startShakeCycle(int unreadCount) async {
    if (unreadCount != 0 && !_isShaking) {
      _isShaking = true;
      while (unreadCount != 0) {
        await _controller.forward(from: 0.0); // perform 3 shakes
        await Future.delayed(const Duration(seconds: 2)); // pause 1 sec
        if (!mounted) break; // stop if widget removed
        unreadCount = Provider.of<NotificationService>(
          context,
          listen: false,
        ).unreadCount;
      }
      _controller.reset();
      _isShaking = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: -3,
      top: 5,
      child: InkWell(
        onTap: ()async{
          final permission = await PermissionService.requestNotificationPermission(context);
          if(permission)
          {
            context.pushNamed("notification-screen");
          }else{
            showBottomMessage(context, "Notification Permission Not Provided", true);
          }
        },
        child: Consumer<NotificationService>(
          builder: (context, notifService, child) {
            int unreadCount = notifService.unreadCount;

            // Start shake cycle if needed
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _startShakeCycle(unreadCount);
            });

            return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_animation.value, 0),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Center(
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
