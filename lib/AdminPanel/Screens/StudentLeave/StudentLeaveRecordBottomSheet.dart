import 'package:digivity_admin_app/Helpers/launchAnyUrl.dart';
import 'package:flutter/material.dart';
import 'package:digivity_admin_app/AdminPanel/Models/LeaveRecord/StudentLeaveModel.dart';
import 'package:digivity_admin_app/Components/Badge.dart';
import 'package:digivity_admin_app/Helpers/LeaveRecordHelper/StudentLeaveRecordHelper.dart';

import '../../Models/LeaveRecord/LeaveRecordModel.dart';

void StudentLeaveRecordBottomSheet(
  BuildContext context,
  Map<String, dynamic> applicantdata,
  LeaveRecord leaveData,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, controller) {
          final leaveRecords = leaveData ?? [];

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          applicantdata['profileImage'] ?? '',
                        ),
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            applicantdata['leaveApplyBy'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            applicantdata['courseSection'] ?? '',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(
                            "Father: ${applicantdata['fatherName'] ?? ''}",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Show each leave record
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade200, Colors.purple.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Status Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              leaveData.lvTitle ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          BadgeScreen(
                            text: leaveData.lvStatus ?? '',
                            color: StudentLeaveRecordHelper()
                                .getLeaveStatusColor(leaveData.lvStatus ?? ''),
                            icon: StudentLeaveRecordHelper()
                                .getLeaveStatusIcon(leaveData.lvStatus ?? ''),
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Description
                      Text(
                        leaveData.lvDescription ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Dates
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "From: ${leaveData.lvFromDate ?? ''}  To: ${leaveData.lvToDate ?? ''}, Days: ${leaveData.lvDays ?? ''}",
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Attachments
                      if (leaveData.attchment.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: leaveData.attchment.map((att) {
                            return GestureDetector(
                              onTap: () => openFile(att.filePath),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.attach_file, size: 16, color: Colors.black54),
                                    const SizedBox(width: 4),
                                    Text(
                                      att.fileName ?? '',
                                      style: const TextStyle(color: Colors.black87, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                )

              ],
            ),
          );
        },
      );
    },
  );
}
