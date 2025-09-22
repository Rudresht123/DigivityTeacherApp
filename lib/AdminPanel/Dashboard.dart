import 'package:digivity_admin_app/AdminPanel/LoginUserCard.dart';
import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/AppBarComponent.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/BottomNavigation.dart';
import 'package:digivity_admin_app/Components/CustomMenuModal1.dart';
import 'package:digivity_admin_app/Components/NotificationBadge.dart';
import 'package:digivity_admin_app/Components/SideBar.dart';
import 'package:digivity_admin_app/Providers/DashboardProvider.dart';
import 'package:digivity_admin_app/Providers/MenuProvider.dart';
import 'package:digivity_admin_app/helpers/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeDashboard();
      FirebaseMessaging.instance.getAPNSToken().then((apnsToken) {
        print("APNs Token: $apnsToken");
      });
    });
  }

  Future<void> _initializeDashboard() async {
    await PermissionService.requestNotificationPermission(context);
    await Provider.of<DashboardProvider>(
      context,
      listen: false,
    ).fetchDashboardData(context);

    // Load UI theme settings
    await Provider.of<UiThemeProvider>(
      context,
      listen: false,
    ).loadThemeSettingsFromApi(context);

    // Request notification permission
    // Fetch menu items
    await Provider.of<MenuProvider>(context, listen: false).fetchMenuItems();
  }

  void _onBottomBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final uiTheme = Provider.of<UiThemeProvider>(context);
    if (dashboardProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      drawer: Sidebar(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarComponent(appbartitle: "Dashboard"),
      ),
      body: BackgroundWrapper(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Teacher Info
                  dashboardProvider.userInfo.isNotEmpty
                      ? UserProfileCard(user: dashboardProvider.userInfo[0])
                      : SizedBox(),

                  // Menu Section
                  CustomMenuContainer(),
                ],
              ),
            ),

            // Bottom-left Floating Action Button
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                backgroundColor: uiTheme.appBarColor ?? Colors.blue,
                onPressed: () async {
                  final permission =
                      await PermissionService.requestNotificationPermission(
                        context,
                      );
                  if (permission) {
                    context.pushNamed("notification-screen");
                  } else {
                    showBottomMessage(
                      context,
                      "Notification Permission Not Provided",
                      true,
                    );
                  }
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      color: uiTheme.appbarIconColor ?? Colors.white,
                      size: 22,
                    ),
                    NotificationBadge(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
