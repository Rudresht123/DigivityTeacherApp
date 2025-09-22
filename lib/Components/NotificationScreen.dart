import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Helpers/NotificationCounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Reset unread count when user opens screen
    Future.microtask(
      () =>
          Provider.of<NotificationService>(context, listen: false).resetCount(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: "Notifications", routeName: "back"),
      ),
      body: BackgroundWrapper(
        child: Consumer<NotificationService>(
          builder: (context, notifService, __) {
            if (notifService.notifications.isEmpty) {
              return const Center(
                child: Text(
                  "No notifications",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            final uiTheme = Provider.of<UiThemeProvider>(context);

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Consumer<NotificationService>(
                  builder: (context, notifService, child) {
                    if (notifService.notifications.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 3,
                        ),
                        icon: const Icon(Icons.delete_forever, size: 20),
                        label: const Text(
                          "Clear All",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () async {
                          bool confirm = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Row(
                                children: const [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.redAccent,
                                  ),
                                  SizedBox(width: 8),
                                  Text("Clear All Notifications"),
                                ],
                              ),
                              content: const Text(
                                "This action cannot be undone. Do you want to remove all notifications?",
                                style: TextStyle(fontSize: 14),
                              ),
                              actionsPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              actions: [
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Yes, Clear"),
                                ),
                              ],
                            ),
                          );

                          if (confirm) {
                            notifService.clearAllNotifications();
                          }
                        },
                      ),
                    );
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: notifService.notifications.length,
                    itemBuilder: (context, index) {
                      final notif = notifService.notifications[index];
                      final timestamp = DateTime.fromMillisecondsSinceEpoch(
                        notif['timestamp'] ?? 0,
                      );
                      final timeStr = DateFormat(
                        'dd MMM, hh:mm a',
                      ).format(timestamp);

                      return Dismissible(
                        key: Key(notif['timestamp'].toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        onDismissed: (_) {
                          Provider.of<NotificationService>(
                            context,
                            listen: false,
                          ).removeNotificationAt(index);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Card Content
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.white, Colors.grey.shade50],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 8,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                  border: Border(
                                    left: BorderSide(
                                      color: uiTheme.appBarColor ?? Colors.blue,
                                      width: 5,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                  title: Text(
                                    notif['title'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        notif['body'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        timeStr,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -10,
                                left: -3,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(
                                        Icons.notifications,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                    Positioned(
                                      right: -2,
                                      top: -2,
                                      child: Consumer<NotificationService>(
                                        builder:
                                            (context, notifService, child) {
                                              int unreadCount =
                                                  notifService.unreadCount;
                                              if (unreadCount == 0)
                                                return const SizedBox.shrink();

                                              return Container(
                                                padding: const EdgeInsets.all(
                                                  3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 1,
                                                  ),
                                                ),
                                                constraints:
                                                    const BoxConstraints(
                                                      minWidth: 14,
                                                      minHeight: 14,
                                                    ),
                                                child: Center(
                                                  child: Text(
                                                    '$unreadCount',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
