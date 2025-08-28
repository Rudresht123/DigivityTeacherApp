import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MainDashboardModel/UserInfo.dart';
import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:provider/provider.dart';

class UserProfileCard extends StatelessWidget {
  final UserInfo user;

  const UserProfileCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final uiTheme = Provider.of<UiThemeProvider>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: uiTheme.bottomSheetBgColor ?? Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Profile Image with circular border and online badge
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: user.profileImg.isNotEmpty
                          ? PopupNetworkImage(
                        imageUrl: user.profileImg,
                        radius: 40,
                      )
                          : Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: uiTheme.appbarIconColor ?? Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${user.userName}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: uiTheme.appbarIconColor ?? Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Emp. NO. ${user.userNo} | ${user.userInfo}",
                        style:  TextStyle(
                          fontSize: 14,
                          color: uiTheme.appbarIconColor ?? Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Last Login: ${user.lastLogin}",
                          style:  TextStyle(
                            fontSize: 12,
                            color: uiTheme.appbarIconColor ?? Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ===== Attendance Badge Top Right =====
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${user.todayAttendance}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }
}
