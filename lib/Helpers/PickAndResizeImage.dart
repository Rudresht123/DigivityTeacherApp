import 'dart:io';
import 'package:digivity_admin_app/helpers/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImagePickAndResize {
  static bool _isPicking = false; // Prevent concurrent access

  Future<String> pickAndResizeImage({required ImageSource source}) async {
    if (_isPicking) {
      print('Image picking already in progress.');
      return 'Picking in progress';
    }

    _isPicking = true;

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile == null) {
        print('No image selected.');
        return 'No Image Selected';
      }

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: const Color(0xFF3C8DBC),
            toolbarWidgetColor: Colors.white,
            statusBarColor: const Color(0xFF3C8DBC),
            activeControlsWidgetColor: Colors.green,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            cropFrameStrokeWidth: 2,
            hideBottomControls: false,
            cropStyle: CropStyle.rectangle,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: false,
          ),
        ],
      );

      if (croppedFile == null) {
        print('Cropping cancelled by user.');
        return 'Cropping Canceled By User';
      }

      final imageFile = File(croppedFile.path);
      final originalBytes = await imageFile.readAsBytes();

      final decodedImage = img.decodeImage(originalBytes);
      if (decodedImage == null) {
        print('Image decode failed.');
        return 'Image decode failed.';
      }

      final resized = img.copyResize(decodedImage, width: 600);
      final resizedBytes = img.encodeJpg(resized);

      final tempDir = await getTemporaryDirectory();
      final fileName = 'resized_${DateTime
          .now()
          .millisecondsSinceEpoch}.jpg';

      final resizedFile = await File(path.join(tempDir.path, fileName))
          .writeAsBytes(resizedBytes);

      return resizedFile.path;
    } catch (e) {
      print('Error during image pick & resize: $e');
      return 'Error: $e';
    } finally {
      _isPicking = false; // Reset flag
    }
  }

}

