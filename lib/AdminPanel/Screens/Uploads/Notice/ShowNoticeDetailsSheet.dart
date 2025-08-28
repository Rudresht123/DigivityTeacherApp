import 'package:digivity_admin_app/AdminPanel/Components/DeleteConfirmationDialog.dart';
import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/AssignmentModel.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/helpers/launchAnyUrl.dart';
import 'package:flutter/material.dart';

class ShowNoticeDetailsSheet extends StatelessWidget {
  final int noticeId;
  final String? time;
  final String? course;
  final String? noticeNo;
  final String noticeDate;
  final String noticeTitle;
  final String noticeDescription;
  final String submittedBy;
  final String submittedByProfile;
  final List<Attachment> attachments;
  final String? withapp;
  final String? withtextSms;
  final String? withEmail;
  final String? withWebsite;
  final String? authorizedBy;
  final List<String>? noticeurls;
  final Future<Map<String, dynamic>> Function()? onDelete;

  const ShowNoticeDetailsSheet({
    Key? key,
    required this.noticeId,
    this.time,
    required this.course,
    required this.noticeDate,
    required this.noticeTitle,
    required this.noticeDescription,
    required this.submittedBy,
    required this.submittedByProfile,
    required this.attachments,
    this.withapp,
    this.withtextSms,
    this.withEmail,
    this.withWebsite,
    this.authorizedBy,
    this.noticeurls,
    required this.onDelete,
    this.noticeNo
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> getSelectedNotifyValues() {
      return {
        'with_text_sms': 'Text SMS',
        'with_app': 'App',
        'with_whatsapp': 'Whatsapp',
        'with_email': 'Email',
        'with_website': 'Website',
      };
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.70,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Handle bar
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

              Center(child: _notifyChip('Notice', 'green')),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(noticeDate, style: const TextStyle(color: Colors.grey)),
                  Text('Hello',
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.w600)),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),

              Text(noticeTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(noticeDescription),

              const SizedBox(height: 16),
              const Divider(),

              const Text("Attachments:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (attachments.isEmpty)
                const Text("No Attachments Found", style: TextStyle(color: Colors.grey)),
              ...attachments.map((file) {
                final name = file.fileName ?? 'Unnamed';
                final ext = file.extension?? '';
                final url = file.filePath?? '';

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: InkWell(
                    onTap: () async => openFile(url),
                    child: Row(
                      children: [
                        Icon(ext == 'pdf' ? Icons.picture_as_pdf : Icons.link,
                            color: ext == 'pdf' ? Colors.red : Colors.blue),
                        const SizedBox(width: 12),
                        Expanded(child: Text(name, overflow: TextOverflow.ellipsis)),
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                          onPressed: () async => openFile(url),
                        )
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 14),
              const Divider(),

              /// Notification Type
              const Text("Notify On:", style: TextStyle(fontWeight: FontWeight.bold)),

              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (withapp == 'yes') _notifyChip(getSelectedNotifyValues()['with_app'], ''),
                  if (withtextSms == 'yes') _notifyChip(getSelectedNotifyValues()['with_text_sms'], ''),
                  if (withEmail == 'yes') _notifyChip(getSelectedNotifyValues()['with_email'], ''),
                  if (withWebsite == 'yes') _notifyChip(getSelectedNotifyValues()['with_website'], ''),
                ],
              ),

              const SizedBox(height: 14),
              if (authorizedBy != null && authorizedBy!.trim().isNotEmpty) ...[
                const Divider(),
                const Text("Authorized By:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(authorizedBy!),
              ],

              if (noticeurls!.isNotEmpty) ...[
                const SizedBox(height: 16),
                ...noticeurls!.map((url) => Container(
                  width: 180,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey.shade200,
                  ),
                  child: InkWell(
                    onTap: () => openFile(url),
                    child: Row(
                      children: const [
                        Icon(Icons.link, color: Colors.blue),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text("View Attached Link",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    PopupNetworkImage(imageUrl: submittedByProfile, radius: 20),
                    const SizedBox(width: 8),
                    Text("Submitted by $submittedBy",
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ]),
                  Text("Attachment (${attachments.length})",
                      style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
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
        );
      },
    );
  }

  Widget _notifyChip(String? label, String? color) {
    return Chip(
      label: Text(label ?? '', style: const TextStyle(color: Colors.black87)),
      backgroundColor: color != '' ? Colors.green : Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}
