import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentProfileModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentsManagement/StudentAcountAlert.dart';
import 'package:digivity_admin_app/helpers/CommonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



void showStudentOptionsBottomSheet(BuildContext context, String studentName,String StudentId,String contactNo,String studentStatus) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.3,
            maxChildSize: 0.5,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        studentName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildBottomSheetItem(
                        icon: Icons.phone,
                        label: 'Voice Call',
                        iconBg: Colors.green.shade100,
                        onTap: () {
                          print(contactNo);
                          CustomFunctions().dialPhoneNumber(contactNo);
                        },
                      ),
                      _buildBottomSheetItem(
                        icon: Icons.person,
                        label: 'View Profile',
                        iconBg: Colors.orange.shade100,
                        onTap: () async{
                          context.pushNamed(
                              'student-profile',
                              pathParameters: {
                                'id':StudentId
                              }
                          );
                        },
                      ),
                      _buildBottomSheetItem(
                        icon: Icons.edit,
                        label: 'Modify Details ',
                        iconBg: Colors.grey.shade200,
                        onTap: () {
                          context.pushNamed(
                            'edit-student',
                            pathParameters: {
                              'id':StudentId
                            }
                          );
                        },
                      ),
                      _buildBottomSheetItem(
                        icon: Icons.check_circle,
                        label: 'Activate Account',
                        iconBg: Colors.green.shade100,
                        onTap: () {
                          showStudentAlertDialog(context,StudentId,studentStatus == 'active' ? 'inactive' : 'active');
                        },
                      ),
                      _buildBottomSheetItem(
                        icon: Icons.add,
                        label: 'Add Complaint',
                        iconBg: Colors.blue.shade100,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }

  );
}

// ✅ This must be outside ANY other function
Widget _buildBottomSheetItem({
  required IconData icon,
  required String label,
  required Color iconBg,
  required VoidCallback onTap,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.grey, // your desired color
          width: 2.0,
        ),
      ),
      borderRadius: BorderRadius.circular(8),
      color: Colors.white, // Optional: background color
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      leading: CircleAvatar(
        backgroundColor: iconBg,
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    ),
  );
}

