import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showDocumentPickerBottomSheet({
  required BuildContext context,
  required String title,
  required VoidCallback onPickDocument,
  required VoidCallback onCameraTap,
  required VoidCallback onGalleryTap,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: false,
    builder: (bottomSheetContext) {
      final uiTheme = Provider.of<UiThemeProvider>(bottomSheetContext);

      return Container(
        decoration: BoxDecoration(
          color: uiTheme.bottomSheetBgColor ?? Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Wrap(
          children: [
            const Center(child: Icon(Icons.keyboard_arrow_up, size: 30, color: Colors.grey)),
            const SizedBox(height: 10),
            Center(
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                "Select file source",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const Divider(height: 30),

            // Camera
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE5E6FA),
                child: Icon(Icons.camera_alt, color: Colors.orange),
              ),
              title: const Text("Take Photo from Camera", style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                onCameraTap();
              },
            ),
            const SizedBox(height: 10),

            // Gallery
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE5E6FA),
                child: Icon(Icons.photo_library_outlined, color: Colors.pink),
              ),
              title: const Text("Choose from Gallery", style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                onGalleryTap();
              },
            ),
            const SizedBox(height: 10),

            // Document
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE5E6FA),
                child: Icon(Icons.insert_drive_file, color: Colors.blueAccent),
              ),
              title: const Text("Pick Document", style: TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {

                Navigator.pop(context);
                onPickDocument();
              },
            ),
            const SizedBox(height: 10),

            const Divider(height: 30),
            Center(
              child: TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.red),
                label: const Text("Cancel", style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      );
    },
  );
}
