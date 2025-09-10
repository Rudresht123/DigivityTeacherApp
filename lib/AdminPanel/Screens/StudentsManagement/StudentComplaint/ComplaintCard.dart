import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Models/ComplaintModel/ComplaintModel.dart';
import 'package:flutter/material.dart';

class ComplaintCard extends StatelessWidget {
  final ComplaintModel complaint;

  const ComplaintCard({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile + Name
            Row(
              children: [
                PopupNetworkImage(imageUrl: "${complaint.submittedByProfile}"),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Submitted By : ",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${complaint.submittedBy}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      complaint.complaintDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 5),

            // Complaint text
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.description_outlined,
                        color: Colors.blueAccent,
                        size: 18,
                      ),
                      SizedBox(width: 2),
                      Text(
                        "Complaint Description",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  Text(
                    complaint.complaint,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 2),

            // Complaint Info
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _infoChip(Icons.person, "By: ${complaint.complaintBy}"),
                _infoChip(Icons.person_outline, "To: ${complaint.complaintTo}"),
                _infoChip(Icons.school, "Course: ${complaint.course}"),
                _infoChip(Icons.badge, "Type: ${complaint.complaintType}"),
              ],
            ),

            const Divider(height: 20),

            // Communication Status
            Row(
              children: [
                if (complaint.withApp == "yes")
                  _statusChip(Icons.phone_android, "App"),
                if (complaint.withTextSms == "yes")
                  _statusChip(Icons.sms, "SMS"),
                if (complaint.withEmail == "yes")
                  _statusChip(Icons.email, "Email"),
                if (complaint.withWhatsapp == "yes")
                  _statusChip(Icons.whatshot, "WhatsApp"),
              ],
            ),

            const SizedBox(height: 0),

            // Status
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: complaint.status == "no"
                      ? Colors.orange[100]
                      : Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  complaint.status.isEmpty || complaint.status == "no"
                      ? "Pending"
                      : "Approved",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: complaint.status == "no"
                        ? Colors.orange[800]
                        : Colors.green[800],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.blue),
      label: Text(text, style: const TextStyle(fontSize: 13)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _statusChip(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        backgroundColor: Colors.blue[50],
        avatar: Icon(icon, size: 16, color: Colors.blue),
        label: Text(text, style: const TextStyle(fontSize: 12)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
