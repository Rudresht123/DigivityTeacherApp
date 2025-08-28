import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/AssignmentModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Syllabus/SyllabusBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Syllabuscard extends StatelessWidget {
  final String course;
  final String subject;
  final int syllabusId;
  final String syllabusTitle;
  final String syllabusDetail;
  final String submittedBy;
  final String submittedByProfile;
  final List<Attachment> attachments;
  final String? withapp;
  final String? withWebsite;
  final Future<Map<String, dynamic>> Function()? onDelete;


  const Syllabuscard({
    Key? key,
    required this.course,
    required this.subject,
    required this.syllabusId,
    required this.syllabusTitle,
    required this.syllabusDetail,
    required this.submittedBy,
    required this.submittedByProfile,
    required this.attachments,
    this.withapp,
    this.withWebsite,
    required this.onDelete
  }) : super(key: key);

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(child: Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
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
                      Text('$course | $subject',
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),

                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 0.8),
            const SizedBox(height: 16),

            /// Homework Title and Description Box
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
                    syllabusTitle.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    syllabusDetail.toUpperCase(),
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
      onTap: () {

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => Syllabusbottomsheet(
            syllabusId:syllabusId,
            syllabusTitle: syllabusTitle,
            syllabus: syllabusDetail,
            course: course,
            subject: subject,
            submittedBy: submittedBy,
            attachments: attachments,
            withapp: withapp,
             withWebsite: withWebsite,
            submittedByProfile: submittedByProfile,
            onDelete: onDelete,
          ),
        );
      },

    );
  }
}
