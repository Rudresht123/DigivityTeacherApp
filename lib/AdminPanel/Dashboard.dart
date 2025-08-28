
import 'package:digivity_admin_app/AdminPanel/LoginUserCard.dart';
import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:digivity_admin_app/Components/AppBarComponent.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/BottomNavigation.dart';
import 'package:digivity_admin_app/Components/CustomMenuModal1.dart';
import 'package:digivity_admin_app/Components/SideBar.dart';
import 'package:digivity_admin_app/Providers/DashboardProvider.dart';
import 'package:digivity_admin_app/Providers/MenuProvider.dart';
import 'package:digivity_admin_app/helpers/permission_handler.dart';
import 'package:flutter/material.dart';
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
    });
  }

  Future<void> _initializeDashboard() async {
    // Fetch dashboard data
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
    await PermissionService.requestNotificationPermission();
    await PermissionService.requestDeviceLocationPermission();
    // Fetch menu items
    await Provider.of<MenuProvider>(
      context,
      listen: false,
    ).fetchMenuItems();
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// Container for the Teacher Information
              dashboardProvider.userInfo.isNotEmpty
                  ? UserProfileCard(user: dashboardProvider.userInfo[0])
                  : SizedBox(),
              /// Menu Section Start Here
              CustomMenuContainer()
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
