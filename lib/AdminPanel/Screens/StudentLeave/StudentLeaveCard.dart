import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Models/LeaveRecord/LeaveRecordModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/LeaveRecord/StudentLeaveModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentLeave/StudentLeaveRecordBottomSheet.dart';
import 'package:digivity_admin_app/Components/Badge.dart';
import 'package:digivity_admin_app/Helpers/LeaveRecordHelper/StudentLeaveRecordHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentLeaveCard extends StatefulWidget {
  StudentLeaveModel leaveRequest;

  StudentLeaveCard({Key? key, required this.leaveRequest});
  @override
  State<StatefulWidget> createState() {
    return _StudentLeaveCard();
  }
}

class _StudentLeaveCard extends State<StudentLeaveCard> {
  @override
  Widget build(BuildContext context) {
    final leave = widget.leaveRequest;
    return Card(
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
                PopupNetworkImage(
                  imageUrl: "${leave.profileImage}",
                  radius: 25,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Leave Apply By',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                      Text(
                        "${leave.leaveApplyBy}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Course : ${leave.courseSection}",
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Admission No : ${leave.admissionNo}",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 0.8),
            const SizedBox(height: 16),

            /// Notice Title and Description Box
            leave.leaverecord.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: const Text(
                      "No Leave Record Found",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  )
                :SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: leave.leaverecord.length,
                itemBuilder: (context, index) {
                  final leaverecord = leave.leaverecord[index];
                  return InkWell(
                    onTap: () {
                      StudentLeaveRecordBottomSheet(context,
                          {
                            'profileImage':leave.profileImage,
                            "leaveApplyBy":leave.leaveApplyBy,
                            "courseSection":leave.courseSection,
                            "fatherName":leave.fatherName
                          },
                          leaverecord as LeaveRecord);
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: const [
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                leaverecord.lvTitle ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              BadgeScreen(
                                icon: StudentLeaveRecordHelper()
                                    .getLeaveStatusIcon(leaverecord.lvStatus ?? ""),
                                text: leaverecord.lvStatus ?? "",
                                fontSize: 10,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 10,
                                ),
                                color: StudentLeaveRecordHelper()
                                    .getLeaveStatusColor(leaverecord.lvStatus ?? ""),
                              ),
                            ],
                          ),
                          const Divider(height: 8),
                          Text(
                            leaverecord.lvDescription ?? "",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
            ,
          ],
        ),
      ),
    );
  }
}
