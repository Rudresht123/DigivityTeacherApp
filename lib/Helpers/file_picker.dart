import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

List<File> selectedFiles = [];

Future<void> pickFiles() async {
  final result = await FilePicker.platform.pickFiles(allowMultiple: false);
  if (result != null) {
    selectedFiles.addAll(result.paths.map((e) => File(e!)));
  }
}

Future<void> pickFromCamera() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
    selectedFiles.add(File(pickedFile.path));
  }
}

Future<void> pickFromGallery() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    selectedFiles.add(File(pickedFile.path));
  }
}
