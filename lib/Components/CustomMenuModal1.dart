import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Providers/MenuProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomMenuContainer extends StatelessWidget {
  const CustomMenuContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final uiTheme = Provider.of<UiThemeProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: uiTheme.bottomSheetBgColor ?? Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: menuProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Navigation Menus",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: uiTheme.appbarIconColor ?? Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  menuProvider.quickActions.isNotEmpty
                      ? buildModuleGrid(
                          'Quick Actions',
                          uiTheme,
                          menuProvider.quickActions,
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 16),
                  menuProvider.importantLinks.isNotEmpty
                      ? buildModuleGrid(
                          'Important Links',
                          uiTheme,
                          menuProvider.importantLinks,
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 16),
                  menuProvider.aboutSchool.isNotEmpty
                      ? buildModuleGrid(
                          'About School',
                          uiTheme,
                          menuProvider.aboutSchool,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
    );
  }
}

Widget buildModuleGrid(
  String title,
  UiThemeProvider uiTheme,
  List<Map<String, dynamic>> modules,
) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
      final fontSize = _getFontSize(constraints.maxWidth);
      final iconSize = _getIconSize(constraints.maxWidth);
      final childasspectratio = _childasspectratio(constraints.maxWidth);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: fontSize + 2,
                fontWeight: FontWeight.bold,
                color: uiTheme.appbarIconColor ?? Colors.black,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: modules.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: childasspectratio,
            ),
            itemBuilder: (context, index) {
              final module = modules[index];
              return GestureDetector(
                onTap: () {
                  final route = getRouteForModule(module['module_id']);
                  try {
                    if (route.isNotEmpty) {
                      context.pushNamed(route);
                    } else {
                      showBottomMessage(context, "Opps!! Comming Soon", false);
                    }
                  } catch (e) {
                    showBottomMessage(context, "${e}", false);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color:
                        uiTheme.iconBgColor?.withOpacity(0.1) ??
                        Colors.grey.shade100,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        getIconForModule(module['module_id']),
                        color: uiTheme.iconColor ?? Colors.blue,
                        size: iconSize,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        module['module_text'] ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          color: uiTheme.iconColor ?? Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}

/// ================= Helpers =================
int _getCrossAxisCount(double width) {
  if (width < 600) return 3; // Mobile
  if (width < 900) return 8; // Small tablet
  if (width < 1200) return 10; // iPad / medium
  return 8; // Large screen
}

double _getFontSize(double width) {
  if (width < 600) return 10;
  if (width < 900) return 8;
  if (width < 1200) return 14;
  return 16;
}

double _getIconSize(double width) {
  if (width < 600) return 20;
  if (width < 900) return 20;
  if (width < 1200) return 32;
  return 40;
}

double _childasspectratio(double width) {
  if (width < 600) return 1.3;
  if (width < 900) return 0.9;
  if (width < 1200) return 0.5;
  return 40;
}

IconData getIconForModule(String moduleId) {
  switch (moduleId) {
    case 'inbox':
      return Icons.inbox;
    case 'attendance':
      return Icons.check_circle;
    case 'homework':
      return Icons.upload_file;
    case 'notice':
      return Icons.notifications;
    case 'assignment':
      return Icons.assignment;
    case 'syllabus':
      return Icons.menu_book;
    case 'circular':
      return Icons.blur_circular;
    case 'school-news':
      return Icons.newspaper;
    case 'student-photo':
      return Icons.photo_camera;
    case 'calendar':
      return Icons.calendar_month;
    case 'exam-entry':
      return Icons.fact_check;
    case 'PTM':
      return Icons.people;
    case 'master-update':
      return Icons.system_update;
    case 'student-leave':
      return Icons.person_remove;
    case 'staff-leave':
      return Icons.group_off;
    case 'transport-attendance':
      return Icons.directions_bus;
    case 'staff-attendance':
      return Icons.sentiment_satisfied_alt;
    case 'student-list':
      return Icons.people;
    case 'student-fee-report':
      return Icons.request_page;
    case 'attendance-report':
      return Icons.bar_chart;
    case 'student-performance':
      return Icons.emoji_events;
    case 'exam-result':
      return Icons.school;
    case 'student-complaint':
      return Icons.report_problem;
    case 'my-student-birthday':
      return Icons.cake;
    case 'activity-gallery':
      return Icons.photo_library;
    case 'online-class':
      return Icons.video_call;
    case 'website':
      return Icons.language;
    case 'about-school':
      return Icons.info;
    case 'manager-message':
      return Icons.message;
    case 'principal-message':
      return Icons.person;
    case 'school-rule-regulation':
      return Icons.rule;
    case 'staff-guidance':
      return Icons.support_agent;
    case 'school-staff':
      return Icons.groups;
    case 'contact-us':
      return Icons.contact_mail;
    default:
      return Icons.widgets;
  }
}

String getRouteForModule(String moduleId) {
  switch (moduleId) {
    case 'attendance':
      return 'attendance';
    case 'homework':
      return 'upload-homework';
    case 'notice':
      return 'upload-notice';
    case 'assignment':
      return 'upload-assignment';
    case 'syllabus':
      return 'upload-syllabus';
    case 'circular':
      return 'upload-circular';
    case 'student-photo':
      return 'student-upload-image';
    case 'staff-photo':
      return 'staff-upload-image';
    case 'exam-entry':
      return 'exam-entry';
    case 'student-list':
      return 'student-list';
    case 'staff-list':
      return 'staff-list';
    case 'student-fee-report':
      return 'classwise-student-fee-defaulter-report';
    case 'master-update':
      return 'master-update';
    case 'attendance-report':
      return 'student-attendance-reports';
    case 'student-performance':
      return 'student-performance';
    case 'exam-result':
      return 'exam-result';
    case 'student-complaint':
      return 'student-complaint-filter';
    case 'activity-gallery':
      return 'activity-gallery';
    case 'online-class':
      return 'student-online-classes';
    case 'staff-attendance':
      return 'mark-staff-attendance';
    case 'school-news':
      return 'school-news';
    case 'calendar':
      return 'calendar';
    case 'student-leave':
      return 'student-leave';
    case 'my-student-birthday':
      return 'student-birthday-reports';
    case 'staff-leave':
      return "staff-applied-leave";
    case 'transport-attendance':
      return "transport-attendance-filter-student";
    default:
      return '';
  }
}
