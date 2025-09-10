import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/StaffLeaveRecordModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/CustomWidget/LeaveCancelDialog.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Helpers/launchAnyUrl.dart';
import 'package:flutter/material.dart';
import 'package:digivity_admin_app/Components/Badge.dart';
import 'package:digivity_admin_app/Helpers/LeaveRecordHelper/StudentLeaveRecordHelper.dart';

void StaffLeaveRecordBottomSheet(
    BuildContext context,
    Map<String, dynamic> applicantdata,
    StaffLeaveRecordModel leaveData,
    VoidCallback? onRefresh,
    ) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Drag Handle
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // Content
                Expanded(
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Title
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Center(
                          key: ValueKey(leaveData.lvTitle),
                          child: Text(
                            "Leave Details",
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Chips Row
                      Wrap(
                        spacing: 8.0, // horizontal gap
                        runSpacing: 8.0, // vertical gap
                        alignment: WrapAlignment.center,
                        children: [
                          Chip(
                            label: Text("From : ${leaveData.lvFromDate ?? ''}"),
                            backgroundColor: StudentLeaveRecordHelper()
                                .getLeaveStatusColor("Approved" ?? ''),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                          Chip(
                            label: Text("To : ${leaveData.lvToDate ?? ''}"),
                            backgroundColor: StudentLeaveRecordHelper()
                                .getLeaveStatusColor("Rejected" ?? ''),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                          Chip(
                            avatar: const Icon(Icons.access_time, size: 18),
                            label: Text("${leaveData.lvDays} Days"),
                            backgroundColor: Colors.blue.shade50,
                          ),
                          Chip(
                            label: Text(leaveData.lvStatus ?? ''),
                            backgroundColor: StudentLeaveRecordHelper()
                                .getLeaveStatusColor(leaveData.lvStatus ?? ''),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Title + Description
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${leaveData.lvTitle ?? ''} ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                leaveData.lvDescription ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(height: 1),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Cancel Reason : ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                leaveData.lvStatusReason ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Attachments
                      if (leaveData.attachment.isNotEmpty) ...[
                        Text(
                          "Attachments (${leaveData.attachment.length})",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: leaveData.attachment.length,
                          itemBuilder: (context, index) {
                            final att = leaveData.attachment[index];
                            return InkWell(
                              onTap: () => openFile(att.filePath),
                              child: Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.insert_drive_file,
                                    color: Colors.purple,
                                  ),
                                  title: Text(
                                    att.fileName ?? '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: const Icon(
                                    Icons.visibility,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Applicant Info
                      Divider(),
                      ListTile(
                        leading: CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage(
                            applicantdata['profileImage'] ?? '',
                          ),
                        ),
                        title: Text(
                          applicantdata['leaveApplyBy'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text("Applied By"),
                        trailing: BadgeScreen(
                          text: "Attachment (${leaveData.attachment.length})",
                          color: Colors.green.shade300,
                          icon: Icons.attach_file,
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),

                // Bottom Buttons
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black12)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          label: const Text("Close"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      leaveData.lvStatus != "Cancel"
                          ? Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final parentContext = context;
                            showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return LeaveCancelDialog(
                                  onConfirm: (reason) async {
                                    Navigator.pop(dialogContext);
                                    showLoaderDialog(parentContext);
                                    try {
                                      final userid =
                                      await SharedPrefHelper.getPreferenceValue(
                                        "user_id",
                                      );
                                      final formdata = {
                                        "leaveid": leaveData.lvId,
                                        "reason": reason,
                                        "status": "cancel",
                                        "leave_status_reason": reason,
                                        "approve_by_user_id": userid,
                                        "leave_status": "cancel",
                                      };

                                      final response =
                                      await StudentLeaveRecordHelper()
                                          .leaveRecordStatus(
                                        formdata,
                                      );

                                      if (response["result"] == 1) {
                                        Navigator.pop(parentContext);
                                        onRefresh!();
                                        showBottomMessage(
                                          parentContext,
                                          "${response['message']}",
                                          false,
                                        );
                                      } else {
                                        showBottomMessage(
                                          parentContext,
                                          "${response['message']}",
                                          true,
                                        );
                                      }
                                    } catch (e) {
                                      print("$e");
                                      showBottomMessage(
                                        parentContext,
                                        "$e",
                                        true,
                                      );
                                    } finally {
                                      hideLoaderDialog(parentContext);
                                    }
                                  },
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400,
                          ),
                        ),
                      )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
