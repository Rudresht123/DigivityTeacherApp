import 'dart:convert';
import 'dart:io';

import 'package:digivity_admin_app/AdminPanel/Components/CustomPickerBottomSheetForUploads.dart';
import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FilePickerBox.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/helpers/FilePickerHelper.dart';
import 'package:digivity_admin_app/helpers/PickAndResizeImage.dart';
import 'package:digivity_admin_app/helpers/launchAnyUrl.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadDocumentBottomSheet extends StatefulWidget {
  final String studentName;
  final String documentName;
  final int StudentId;
  final int documentId;
  final String? docuemntFile;
  final Future<Map<String, dynamic>> Function(Map<String, dynamic> bodydata)?
  onupload;

  const UploadDocumentBottomSheet({
    super.key,
    required this.studentName,
    required this.documentName,
    required this.documentId,
    required this.StudentId,
    this.docuemntFile,
    this.onupload,
  });

  @override
  State<UploadDocumentBottomSheet> createState() =>
      _UploadDocumentBottomSheetState();
}

class _UploadDocumentBottomSheetState extends State<UploadDocumentBottomSheet> {
  List<File> selectedFiles = [];



  @override
  Widget build(BuildContext context) {
    final uiTheme = Provider.of<UiThemeProvider>(context);
    final fileUrl = widget.docuemntFile ?? "";
    final ext = fileUrl.split('.').last.toLowerCase();
    final name = fileUrl.split('/').last;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.70,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) {
        return Container(
          color: uiTheme.bottomSheetBgColor ?? Colors.white,
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Handle Bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                Center(child: _notifyChip('${widget.studentName}', 'green')),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "Document Name - ${widget.documentName}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
                const Divider(),
                const SizedBox(height: 16),

                const Text(
                  "Attachments:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                if (fileUrl.isEmpty)
                  const Text(
                    "No Attachments Found",
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: InkWell(
                      onTap: () => openFile(fileUrl),
                      child: Row(
                        children: [
                          Icon(
                            ext == 'pdf'
                                ? Icons.picture_as_pdf_sharp
                                : Icons.link,
                            color: ext == 'pdf' ? Colors.red : Colors.blue,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(name, overflow: TextOverflow.ellipsis),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.blue,
                            ),
                            onPressed: () => openFile(fileUrl),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 14),
                const Divider(),

                /// Notification Type
                FilePickerBox(
                  onTaped: () {
                    showDocumentPickerBottomSheet(
                      context: context,
                      title: "Upload File",
                      onCameraTap: () => FilePickerHelper.pickFromCamera((file) {
                        setState(() => selectedFiles.add(file));
                      }),
                      onGalleryTap: () => FilePickerHelper.pickFromGallery((file) {
                        setState(() => selectedFiles.add(file));
                      }),
                      onPickDocument: () => FilePickerHelper.pickDocuments((files) {
                        setState(() => selectedFiles.addAll(files));
                      }),
                    );
                  },
                  selectedFiles: selectedFiles,
                  onRemoveFile: (index) {
                    setState(() => selectedFiles.removeAt(index));
                  },
                ),
                const SizedBox(height: 14),
                const Divider(),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey, width: 1.2),
                  ),
                  child: Text(
                    'Note: Uploading a document will replace the previously uploaded documents.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 11,
                        ),
                        label: const Text(
                          "Close",
                          style: TextStyle(fontSize: 11, color: Colors.white),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (widget.onupload != null) {
                            showLoaderDialog(context);

                            String? base64File;
                            String? fileName;

                            if (selectedFiles.isNotEmpty) {
                              final file = selectedFiles.first;
                              final bytes = await file.readAsBytes();
                              base64File = base64Encode(bytes);
                              fileName = file.path.split('/').last;
                            }

                            final bodydata = {
                              'student_id': widget.StudentId,
                              'document_id': widget.documentId,
                              'document_name': widget.documentName,
                              'document_file':
                                  base64File ?? widget.docuemntFile,
                              'file_name':
                                  fileName ??
                                  widget.docuemntFile?.split('/').last,
                            };

                            final response = await widget.onupload!(bodydata);
                            Navigator.pop(context, response); // dismiss loader

                            if (response['result'] == 1) {
                              Navigator.pop(context); // close bottom sheet
                              showBottomMessage(
                                context,
                                response['message'],
                                false,
                              );
                            } else {
                              showBottomMessage(
                                context,
                                response['message'],
                                true,
                              );
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 11,
                        ),
                        label: const Text(
                          "Upload",
                          style: TextStyle(fontSize: 11, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _notifyChip(String? label, String? color) {
    return Chip(
      label: Text(label ?? '', style: const TextStyle(color: Colors.white)),
      backgroundColor: color != '' ? Colors.green : Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}
