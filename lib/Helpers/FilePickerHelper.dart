import 'dart:io';
import 'package:digivity_admin_app/helpers/PickAndResizeImage.dart';
import 'package:digivity_admin_app/helpers/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerHelper {
  /// Pick image from camera
  static Future<void> pickFromCamera(Function(File) onFilePicked) async {
    final isGranted = await PermissionService.requestCameraPermission();
    if (isGranted) {
      final result = await ImagePickAndResize().pickAndResizeImage(
          source: ImageSource.camera);
      if (_isValid(result)) {
        onFilePicked(File(result));
      }
    }
  }

  /// Pick image from gallery
  static Future<void> pickFromGallery(Function(File) onFilePicked) async {
    final isGranted = await PermissionService.requestGalleryPermission();
    if(isGranted){
      final result = await ImagePickAndResize().pickAndResizeImage(
          source: ImageSource.gallery);
      if (_isValid(result)) {
        onFilePicked(File(result));
      }
    }
  }

  /// Pick PDF, DOC, DOCX files
  static Future<void> pickDocuments(Function(List<File>) onFilesPicked) async {
    final isGranted = await PermissionService.requestStoragePermission();
    print("Storage Permission Granted: $isGranted");

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: true,
    );
    if (result != null) {
      final files = result.paths.whereType<String>().map((e) => File(e)).toList();
      onFilesPicked(files);
    }
  }

  /// Validates picked image path
  static bool _isValid(String path) {
    return path.isNotEmpty && ![
      'No Image Selected',
      'Cropping Canceled By User',
      'Image decode failed.'
    ].contains(path);
  }
}
