import 'dart:io';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:digivity_admin_app/helpers/CommonFunctions.dart';


class ImageHandler {
  File? imageFile;
  File? resizedImageFile;

  Future<void> pickAndResizeImage(
      {ImageSource source = ImageSource.camera}) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile == null) {
        print('❌ No image selected.');
        return;
      }
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'eTab Image Cropper',
            toolbarColor: const Color(0xFF3C8DBC),
            statusBarColor: const Color(0xFF3C8DBC),
            // Important for spacing
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'eTab Image Cropper',
            aspectRatioLockEnabled: false,
          )
        ],
      );

      if (croppedFile == null) {
        print('❌ Cropping cancelled by user.');
        return;
      }

      imageFile = File(croppedFile.path);

      final originalBytes = await imageFile!.readAsBytes();
      final decodedImage = img.decodeImage(originalBytes);

      if (decodedImage == null) {
        print('❌ Image decode failed.');
        return;
      }

      final resized = img.copyResize(decodedImage, width: 600);
      final resizedBytes = img.encodeJpg(resized);

      final tempDir = await getTemporaryDirectory();
      final fileName = 'resized_${DateTime
          .now()
          .millisecondsSinceEpoch}.jpg';
      resizedImageFile =
      await File(path.join(tempDir.path, fileName)).writeAsBytes(
          resizedBytes);

      print('✅ Image processed: ${resizedImageFile!.path}');
    } catch (e) {
      print('❌ Error during image pick & resize: $e');
    }
  }



  Future<void> pickAndResizeImageFromGalery(
      {ImageSource source = ImageSource.camera}) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile == null) {
        print('❌ No image selected.');
        return;
      }
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'eTab Image Cropper',
            toolbarColor: const Color(0xFF3C8DBC),
            statusBarColor: const Color(0xFF3C8DBC),
            // Important for spacing
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'eTab Image Cropper',
            aspectRatioLockEnabled: false,
          )
        ],
      );

      if (croppedFile == null) {
        print('❌ Cropping cancelled by user.');
        return;
      }

      imageFile = File(croppedFile.path);

      final originalBytes = await imageFile!.readAsBytes();
      final decodedImage = img.decodeImage(originalBytes);

      if (decodedImage == null) {
        print('❌ Image decode failed.');
        return;
      }

      final resized = img.copyResize(decodedImage, width: 600);
      final resizedBytes = img.encodeJpg(resized);

      final tempDir = await getTemporaryDirectory();
      final fileName = 'resized_${DateTime
          .now()
          .millisecondsSinceEpoch}.jpg';
      resizedImageFile =
      await File(path.join(tempDir.path, fileName)).writeAsBytes(
          resizedBytes);

      print('✅ Image processed: ${resizedImageFile!.path}');
    } catch (e) {
      print('❌ Error during image pick & resize: $e');
    }
  }


  Future<Map<String, dynamic>> uploadResizedImage(String integrate,
      int clientId) async {

    try {
      if (resizedImageFile == null) {
        return {'result': 0, 'message': 'No image found'};
      }

      final bytes = await resizedImageFile!.readAsBytes();
      final base64Image = base64Encode(bytes);

      final formData = {
        'DB_ID': clientId,
        'imageFile': base64Image,
      };

      final response = await CustomFunctions().uploadImages(
          integrate, formData);

      if (response['result'] == 1) {
        return response;
      } else {
        return {
          'result': 0,
          'message': response['message'] ?? 'Upload failed'
        };
      }
    } catch (e) {
      return {'result': 0, 'message': 'Upload error: $e'};
    }
  }

}


