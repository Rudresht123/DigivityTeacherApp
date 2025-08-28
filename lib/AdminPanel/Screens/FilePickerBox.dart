import 'dart:io';
import 'package:flutter/material.dart';

class FilePickerBox extends StatefulWidget {
  final VoidCallback onTaped;
  final List<File>? selectedFiles;
  final Function(int) onRemoveFile;

  const FilePickerBox({
    super.key,
    required this.onTaped,
    required this.selectedFiles,
    required this.onRemoveFile,
  });

  @override
  State<FilePickerBox> createState() => _FilePickerBoxState();
}

class _FilePickerBoxState extends State<FilePickerBox> {
  @override
  Widget build(BuildContext context) {
    final selected = widget.selectedFiles ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upload box
        InkWell(
          onTap: widget.onTaped,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.cloud_upload, color: Colors.green, size: 32),
                    SizedBox(width: 12),
                    Text("Choose Attachment", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "1. File formats: jpg, jpeg, png, pdf, doc, docx, xls, ppt, pptx, xlsx, csv",
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const Text(
                  "2. Max file size: 5 MB",
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        if (selected.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text("No file selected."),
          )
        else
          ...selected.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;
            final fileName = file.path.split('/').last.toLowerCase();

            final isImage = fileName.endsWith('.jpg') ||
                fileName.endsWith('.jpeg') ||
                fileName.endsWith('.png');

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: isImage
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(
                      file,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(Icons.insert_drive_file, size: 40, color: Colors.blueAccent),
                  title: Text(
                    fileName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => widget.onRemoveFile(index),
                  ),
                ),
              ),
            );
          }).toList(),
      ],
    );
  }
}
