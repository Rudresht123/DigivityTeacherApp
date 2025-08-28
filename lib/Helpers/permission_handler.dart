import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class PermissionService {
  /// 📷 Request camera permission
  static Future<bool> requestCameraPermission() async {
    if (Platform.isIOS || Platform.isAndroid) {
      final status = await Permission.camera.status;

      if (status.isGranted) return true;
      final result = await Permission.camera.request();

      if (result.isGranted) return true;
      if (result.isPermanentlyDenied || result.isRestricted) {
        return false;
      }
    }
    return false;
  }

  /// 🗂 Request storage permission (Android only)
  static Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true; // iOS does not require this

    final status = await Permission.storage.status;

    if (status.isGranted) return true;

    final result = await Permission.storage.request();
    if (result.isGranted) return true;

    if (result.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }

  /// 🖼 Request gallery/media access permission (Android & iOS)
  static Future<bool> requestGalleryPermission() async {
    final result = await PhotoManager.requestPermissionExtend();

    if (result.isAuth) {
      // Full access granted
      return true;
    } else if (result == PermissionState.limited) {
      // iOS limited access – can still access selected media
      await PhotoManager.presentLimited(); // Optional prompt for more access
      return true;
    } else {
      // Denied access
      if (Platform.isIOS || Platform.isAndroid) {
        await openAppSettings();
      }
      return false;
    }
  }

  static Future<bool> requestNotificationPermission() async {
    if (Platform.isIOS) {

      final status = await Permission.notification.status;
      if (status.isGranted) return true;

      final result = await Permission.notification.request();
      if (result.isGranted) return true;

      if (result.isPermanentlyDenied || result.isRestricted) {
        // User ne permanently deny kar diya ya restricted hai
        return false;
      }
    } else if (Platform.isAndroid) {

      final status = await Permission.notification.status;
      if (status.isGranted) return true;

      final result = await Permission.notification.request();
      if (result.isGranted) return true;

      if (result.isPermanentlyDenied || result.isRestricted) {
        return false;
      }
    }
    return false;
  }


/// Permission For The Device Location
  static Future<bool> requestDeviceLocationPermission() async {
  if (Platform.isIOS || Platform.isAndroid) {
    var status = await Permission.location.status;
    if (status.isGranted) return true;
    final result = await Permission.location.request();
    if (result.isGranted) return true;
    if (result.isPermanentlyDenied || result.isRestricted) {
      return false;
    }
  }
  return false;
}
}

