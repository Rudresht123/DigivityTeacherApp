import 'package:digivity_admin_app/AdminPanel/Components/DeleteConfirmationDialog.dart';
import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/AssignmentModel.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/helpers/launchAnyUrl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Syllabusbottomsheet extends StatelessWidget {
  final int syllabusId;
  final String syllabusTitle;
  final String syllabus;
  final String course;
  final String subject;
  final String submittedBy;
  final List<Attachment> attachments;
  final String? withapp;
  final String? withWebsite;
  final String submittedByProfile;
  final Future<Map<String, dynamic>> Function()? onDelete;

  const Syllabusbottomsheet({
    Key? key,
    required this.syllabusId,
    required this.syllabusTitle,
    required this.syllabus,
    required this.course,
    required this.subject,
    required this.submittedBy,
    required this.attachments,
    this.withapp,
    this.withWebsite,
    required this.submittedByProfile,
    this.onDelete,
  }) : super(key: key);




  Map<String, String> getSelectedNotifyValues() {
    return {
      'with_text_sms': 'Text SMS',
      'with_app': 'App',
      'with_whatsapp': 'Whatsapp',
      'with_email': 'Email',
      'with_website': 'Website',
    };
  }

  @override
  Widget build(BuildContext context) {
    final uiTheme = Provider.of<UiThemeProvider>(context);
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

                Center(child: _notifyChip('Syllabus', 'green')),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$course - $subject", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),

                Text(syllabusTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(syllabus),

                const SizedBox(height: 16),
                const Divider(),

                const Text("Attachments:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                if (attachments.isEmpty)
                  const Text("No Attachments Found", style: TextStyle(color: Colors.grey)),

                ...attachments.map((file) {
                  final name = file.fileName ?? 'Unnamed';
                  final ext = file.extension ?? '';
                  final url = file.filePath ?? '';

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: InkWell(
                      onTap: () => openFile(url),
                      child: Row(
                        children: [
                          Icon(ext == 'pdf' ? Icons.picture_as_pdf_sharp : Icons.link,
                              color: ext == 'pdf' ? Colors.red : Colors.blue),
                          const SizedBox(width: 12),
                          Expanded(child: Text(name, overflow: TextOverflow.ellipsis)),
                          IconButton(
                            icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                            onPressed: () async {
                              openFile(url,);
                            },
                          ),

                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 14),
                const Divider(),

                const Text("Notify On:", style: TextStyle(fontWeight: FontWeight.bold)),

                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    if (withapp == 'yes') _notifyChip(getSelectedNotifyValues()['with_app'], ''),
                    if (withWebsite == 'yes') _notifyChip(getSelectedNotifyValues()['with_website'], ''),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      PopupNetworkImage(imageUrl: submittedByProfile, radius: 20),
                      const SizedBox(width: 8),
                      Text("Submitted by $submittedBy", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ]),
                    Text("Attachment (${attachments.length})", style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
                  ],
                ),

                const SizedBox(height: 24),

                /// Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white, size: 11),
                        label: const Text("Close", style: TextStyle(fontSize: 11, color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text("Delete",style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => DeleteConfirmationDialog(
                              message: "Are you sure you want to delete this item?",
                              onConfirm: () async {
                                Navigator.pop(context);
                                if (onDelete != null) {
                                  showLoaderDialog(context);
                                  final response = await onDelete!();
                                  hideLoaderDialog(context);
                                  Navigator.pop(context);
                                  showBottomMessage(
                                    context,
                                    response['message'],
                                    response['result'] != 1,
                                  );
                                }
                              },
                              onCancel: () {
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
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
}

Widget _notifyChip(String? label, String? color) {
  return Chip(
    label: Text(label ?? '', style: const TextStyle(color: Colors.black87)),
    backgroundColor: color != '' ? Colors.green : Colors.grey.shade200,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  );
}
