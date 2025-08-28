import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/AssignmentModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Notice/ShowNoticeDetailsSheet.dart';
import 'package:flutter/material.dart';

class Noticecard extends StatelessWidget {
  final int noticeId;
  final String course;
  final String? noticeNo;
  final String time;
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

  const Noticecard({
    Key? key,
    required this.noticeId,
    required this.course,
    required this.time,
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
    this.noticeNo,
    required this.onDelete,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => ShowNoticeDetailsSheet(
            noticeId: noticeId,
            time: time,
            noticeNo:noticeNo,
            noticeTitle: noticeTitle,
            noticeDescription: noticeDescription,
            noticeDate: "$noticeDate | $time",
            course:course,
            submittedBy: submittedBy,
            submittedByProfile: submittedByProfile,
            attachments: attachments,
            withapp: withapp,
            withtextSms: withtextSms,
            withEmail: withEmail,
            withWebsite: withWebsite,
            authorizedBy: authorizedBy,
            noticeurls: noticeurls,
            onDelete: onDelete,
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.green.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header with profile and date
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(submittedByProfile),
                    radius: 18,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Submitted By',
                            style: TextStyle(fontSize: 11, color: Colors.black54)),
                        Text(submittedBy,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("$course [ $noticeNo ]",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                        Text("$noticeDate | $time",
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                                fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 0.8),
              const SizedBox(height: 16),

              /// Notice Title and Description Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      noticeTitle.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      noticeDescription,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
