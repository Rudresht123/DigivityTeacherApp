import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  int _getSelectedIndex(String location) {
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/profile')) return 1;
    if (location.startsWith('/school-news')) return 2;
    if (location.startsWith('/inbox')) return 3;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed('dashboard');
        break;
      case 1:
        context.pushNamed('profile');
        break;
      case 2:
        context.pushNamed('school-news');
        break;
      case 3:
        context.pushNamed('inbox');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _getSelectedIndex(location);

    final uiTheme = Provider.of<UiThemeProvider>(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: uiTheme.bottomSheetBgColor ?? Colors.white,
      currentIndex: selectedIndex,
      onTap: (index) => _onTap(context, index),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        _buildNavItem(Icons.home, "Home", 0, selectedIndex, uiTheme),
        _buildNavItem(Icons.person, "Profile", 1, selectedIndex, uiTheme),
        _buildNavItem(
          Icons.newspaper,
          "School News",
          2,
          selectedIndex,
          uiTheme,
        ),
        _buildNavItem(Icons.message, "Inbox", 3, selectedIndex, uiTheme),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    String label,
    int index,
    int selectedIndex,
    UiThemeProvider uiTheme,
  ) {
    final isSelected = index == selectedIndex;

    return BottomNavigationBarItem(
      label: '', // hide default label
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: Colors.blue.withOpacity(0.2), // selected background
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.blue
                  : uiTheme.appbarIconColor ?? Colors.black,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
