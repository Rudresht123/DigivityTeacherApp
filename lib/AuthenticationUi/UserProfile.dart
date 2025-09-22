import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Models/UserProfileModel.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
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
  UserProfileModel? userdata;

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
    try {
      final data = await CustomFunctions().getAppUserProfileData();

      if (data != null) {
        setState(() {
          userdata = data as UserProfileModel?;
        });
      }
    } catch (e) {
      showBottomMessage(context, "$e", true);
    } finally {
      hideLoaderDialog(context);
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
          child:userdata != null ? CardContainer(
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
                    '${userdata!.academic_session ?? "N/A"}',
                    style: TextStyle(
                      fontSize: AppFontSizes.large,
                      fontWeight: AppFontWeights.bold,
                    ),
                  ),


                  Column(
                    children: [
                      userdata?.profile_image != null
                          ? PopupNetworkImage(imageUrl: userdata!.profile_image)
                          : Image.asset("assets/images/placeholder.png"),

                      const SizedBox(height: 1),
                      // User Info List
                      buildProfileRow(Icons.person, "Name", userdata!.name ?? 'N/A'),
                      buildProfileRow(Icons.person, "Joining Date", userdata!.joining_date ?? 'N/A'),
                      buildProfileRow(Icons.verified_user, "Role", userdata!.role ?? 'N/A'),
                      buildProfileRow(Icons.male, "Gender", userdata!.gender ?? 'N/A'),
                      buildProfileRow(Icons.calendar_today, "Date of Birth", userdata!.dob ?? 'N/A'),
                      buildProfileRow(Icons.phone, "Contact No", userdata!.contact_no ?? 'N/A'),
                      buildProfileRow(Icons.phone, "Alt Contact No", userdata!.alt_contact_no ?? 'N/A'),
                      buildProfileRow(Icons.email, "Email", userdata!.email ?? 'N/A'),
                      buildProfileRow(Icons.email, "Residence Address", userdata!.residence_address ?? 'N/A'),
                      buildProfileRow(Icons.lock, "2 FA Authentication", userdata!.tow_factor_auth == true ? "Enable" : "Disable"),
                      buildProfileRow(Icons.access_time, "Last Login at", userdata!.lastlogin ?? 'N/A'),

                    ],
                  )
                  // Profile Picture
                ],
              ),
            ),) : Center(child: Text("Data Not Found!!!"),),
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

