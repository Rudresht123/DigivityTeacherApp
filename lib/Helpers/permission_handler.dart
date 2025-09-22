import 'dart:io';
import 'package:digivity_admin_app/Helpers/Permission/showPermissionDialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class PermissionService {
  /// 📷 Request camera permission
  static Future<bool> requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;

    if (status.isGranted) return true;

    final result = await Permission.camera.request();

    if (result.isGranted) return true;

    if (result.isPermanentlyDenied || result.isRestricted) {
      showPermissionDialog(
        context,
        "Camera Access Required",
        "We need access to your camera so you can capture profile pictures, student documents, or classroom activities directly within the app.",
      );
      return false;
    }

    return false;
  }

  /// 🗂 Request storage permission (Android only)
  static Future<bool> requestStoragePermission(BuildContext context) async {
    if (!Platform.isAndroid) return true;

    final status = await Permission.storage.status;

    if (status.isGranted) return true;

    final result = await Permission.storage.request();

    if (result.isGranted) return true;

    if (result.isPermanentlyDenied) {
      showPermissionDialog(
        context,
        "Storage Access Required",
        "Storage permission is required to save and upload images, documents, and other teaching materials.",
      );
    }

    return false;
  }

  /// 🖼 Request gallery/media access permission
  static Future<bool> requestGalleryPermission(BuildContext context) async {
    final result = await PhotoManager.requestPermissionExtend();

    if (result.isAuth) return true;

    if (result == PermissionState.limited) {
      await PhotoManager.presentLimited();
      return true;
    }

    showPermissionDialog(
      context,
      "Gallery Access Required",
      "We need access to your gallery to upload or select photos and videos of students, classroom activities, or teaching materials.",
    );
    return false;
  }

  /// 🔔 Request notification permission
  static Future<bool> requestNotificationPermission(
    BuildContext context,
  ) async {
    // iOS me permission_handler ka Permission.notification unreliable hai
    if (Platform.isIOS) {
      final settings = await FirebaseMessaging.instance
          .getNotificationSettings();

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        return true;
      }

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        showPermissionDialog(
          context,
          "Notifications Access Required",
          "Please enable notification access from settings to receive reminders, updates, and school announcements.",
        );
        return false;
      }

      // notDetermined case -> request karo
      final result = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      return result.authorizationStatus == AuthorizationStatus.authorized ||
          result.authorizationStatus == AuthorizationStatus.provisional;
    }

    // ANDROID CASE
    final status = await Permission.notification.status;

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      showPermissionDialog(
        context,
        "Notifications Access Required",
        "Please enable notification access from settings to receive reminders, updates, and school announcements.",
      );
      return false;
    }

    // normal deny tha, to dobara request kar lo
    final result = await Permission.notification.request();
    if (result.isGranted) return true;

    showPermissionDialog(
      context,
      "Notifications Access Required",
      "Notification permission is needed to receive reminders, updates, and alerts about attendance, student activities, and school announcements.",
    );
    return false;
  }

  /// 📍 Device Location Permission
  static Future<bool> requestDeviceLocationPermission(
    BuildContext context,
  ) async {
    final status = await Permission.location.status;

    if (status.isGranted) return true;

    final result = await Permission.location.request();

    if (result.isGranted) return true;

    if (result.isPermanentlyDenied) {
      showPermissionDialog(
        context,
        "Location Access Required",
        "We need your location to accurately track attendance, monitor student pick-up/drop-off, and ensure safety during school activities and field trips.",
      );
    }

    return false;
  }
}
