import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> get notifications => _notifications;

  Future<void> init() async {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(alert: true, badge: true, sound: true);

    _unreadCount = await _getSavedCount();
    _notifications = await _getSavedNotifications();
    _updateBadge(_unreadCount);

    // Foreground message
    FirebaseMessaging.onMessage.listen((msg) => _addNotification(msg));

    // App opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((msg) => resetCount());

    // Background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Initial message
    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      resetCount();
    }
  }

  Future<void> _addNotification(RemoteMessage message) async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> notif = {
      "title": message.notification?.title ?? "No Title",
      "body": message.notification?.body ?? "No Body",
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    };

    _notifications.insert(0, notif);
    await prefs.setString('notifications', jsonEncode(_notifications));

    _unreadCount++;
    await prefs.setInt('notification_count', _unreadCount);

    _updateBadge(_unreadCount);
    notifyListeners();
  }

  Future<void> resetCount() async {
    final prefs = await SharedPreferences.getInstance();
    _unreadCount = 0;
    await prefs.setInt('notification_count', 0);
    _updateBadge(0);
    notifyListeners();
  }

  Future<int> _getSavedCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('notification_count') ?? 0;
  }

  Future<List<Map<String, dynamic>>> _getSavedNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    String? saved = prefs.getString('notifications');
    if (saved != null) {
      try {
        return List<Map<String, dynamic>>.from(jsonDecode(saved));
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  Future<void> removeNotificationAt(int index) async {
    if (index >= 0 && index < _notifications.length) {
      _notifications.removeAt(index);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notifications', jsonEncode(_notifications));
      notifyListeners();
    }
  }

  Future<void> clearAllNotifications() async {
    _notifications.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications');
    await resetCount();
    notifyListeners();
  }

  void _updateBadge(int count) {
    if (count > 0) {
      FlutterAppBadger.updateBadgeCount(count);
    } else {
      FlutterAppBadger.removeBadge();
    }
  }
}

// Background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Optional: Save background notifications if needed
}
