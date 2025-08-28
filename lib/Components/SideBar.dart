import 'dart:async';
import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/AuthenticationUi/UserProfileImage.dart';
import 'package:digivity_admin_app/Components/IconBg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String logo = '';
  String username = '';
  String role = '';

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 0), () async {
      final fetchedUsername = await SharedPrefHelper.getPreferenceValue('name');
      final userrole = await SharedPrefHelper.getPreferenceValue('role');

      setState(() {
        username = fetchedUsername ?? '';
        role = userrole ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final uiTheme = Provider.of<UiThemeProvider>(context);

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  color: uiTheme.appBarColor ?? Colors.blue,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const UserProfileImage(radius: 30),
                      const SizedBox(height: 10),
                      Text(
                        username.isNotEmpty
                            ? username.toUpperCase()
                            : 'HELLO, USER!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        role.isNotEmpty ? role.toUpperCase() : 'N/A',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CustomCardSidebar(
              cardWidget: ListTile(
                leading: const Icon(Icons.home),
                title: const Text(
                  'Home',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () => context.goNamed('dashboard'),
              ),
            ),

            // Profile
            CustomCardSidebar(
              cardWidget: ListTile(
                leading: IconBg.buildSidebarIcon(
                  Icons.person,
                  bgColor: const Color(0xFFE3F2FD),
                  iconColor: Colors.lightBlue,
                ),
                title: const Text(
                  'Profile',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () => context.goNamed('profile'),
              ),
            ),
            // Academic and financial Session
            CustomCardSidebar(
              cardWidget: ListTile(
                leading: IconBg.buildSidebarIcon(
                  Icons.school,
                  bgColor: const Color(0xFFE3F2FD),
                  iconColor: Colors.lightBlue,
                ),
                title: const Text(
                  'Academic Session',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () => context.goNamed('sessions'),
              ),
            ),

            // 2FA Authentication
            CustomCardSidebar(
              cardWidget: ListTile(
                leading: IconBg.buildSidebarIcon(
                  Icons.mobile_friendly,
                  bgColor: const Color(0xFFC8E6C9),
                  iconColor: Colors.green,
                ),
                title: const Text(
                  '2 FA Authentication',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  context.goNamed('tow-factor-auth');
                },
              ),
            ),

            // Change Password
            CustomCardSidebar(
              cardWidget: ListTile(
                leading: IconBg.buildSidebarIcon(
                  Icons.password,
                  bgColor: const Color(0xFFD1C4E9),
                  iconColor: Colors.deepPurple,
                ),
                title: const Text(
                  'Change Password',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {},
              ),
            ),

            // Logout
            CustomCardSidebar(
              cardWidget: ListTile(
                leading: IconBg.buildSidebarIcon(
                  Icons.logout,
                  bgColor: const Color(0xFFFDECEA),
                  iconColor: Colors.red,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();

                    if (context.mounted) {
                      context.goNamed('splash');
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCardSidebar extends StatelessWidget {
  final Widget cardWidget;
  const CustomCardSidebar({super.key, required this.cardWidget});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.1, // like box-shadow
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: cardWidget,
    );
  }
}
