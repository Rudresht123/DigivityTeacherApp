import 'package:digivity_admin_app/Components/BottomNavigation.dart';
import 'package:digivity_admin_app/helpers//CommonFunctions.dart';
import 'package:digivity_admin_app/Components/AppBarComponent.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/IconBg.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SideBar.dart';
import 'package:digivity_admin_app/css/style.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => Profile();
}

class Profile extends State<UserProfile> {
  Map<String, dynamic> userdata = {};

  @override
  void initState() {
    super.initState();

    /// Safe place to run context-aware code
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userData();
    });
  }

  Future<void> _userData() async {
    showLoaderDialog(context);
    final data = await CustomFunctions().getAppUserProfileData();

    print(data);
    hideLoaderDialog(context);
    if (data != null) {
      setState(() {
        userdata = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Sidebar(),
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBarComponent(appbartitle: "User Profile"),
        ),
        body:BackgroundWrapper(
          child: CardContainer(
            margin: EdgeInsets.all(5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Academic Session',
                    style: TextStyle(
                      fontSize: AppFontSizes.xLarge,
                      fontWeight: AppFontWeights.bold,
                    ),
                  ),
                  Text(
                    '${userdata["academicyear"] ?? "N/A"}',
                    style: TextStyle(
                      fontSize: AppFontSizes.large,
                      fontWeight: AppFontWeights.bold,
                    ),
                  ),


                  Column(
                    children: [
                      userdata['profile_image'] != null && userdata['profile_image'].toString().isNotEmpty
                          ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(userdata['profile_image']),
                        backgroundColor: Colors.grey.shade200,
                      )
                          : CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade200,
                        child: Text(
                          'NA',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 1),
                      // User Info List
                      buildProfileRow(Icons.person, "Name", userdata['name'] ?? 'N/A'),
                      buildProfileRow(Icons.verified_user, "Role", userdata['role'] ?? 'N/A'),
                      buildProfileRow(Icons.male, "Gender", userdata['gender'] ?? 'N/A'),
                      buildProfileRow(Icons.calendar_today, "Date of Birth", userdata['dob'] ?? 'N/A'),
                      buildProfileRow(Icons.phone, "Contact No", userdata['contact'] ?? 'N/A'),
                      buildProfileRow(Icons.email, "Email", userdata['email'] ?? 'N/A'),
                      buildProfileRow(Icons.lock, "2 FA Authentication", userdata['tow_factor_auth'] == true ? "Enable" : "Disable"),
                      buildProfileRow(Icons.access_time, "Last Login at", userdata['lastlogin'] ?? 'N/A'),

                    ],
                  )
                  // Profile Picture
                ],
              ),
            ),),
        ),
        bottomNavigationBar:const CustomBottomNavBar()
    );
  }
}

Widget buildProfileRow(IconData icon, String label, String value) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon with background
        IconBg.buildSidebarIcon(
          icon,
          bgColor: const Color(0xFFF5F5F5),
          iconColor: Colors.black,
        ),
        const SizedBox(width: 12),

        // Text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

