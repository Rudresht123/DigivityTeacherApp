import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:digivity_admin_app/Helpers/UserPermissions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomMenuModal extends StatefulWidget {
  const CustomMenuModal({super.key});

  @override
  State<CustomMenuModal> createState() => _CustomMenuModalState();
}

class _CustomMenuModalState extends State<CustomMenuModal> {
  List<Map<String, dynamic>> _quickActions = [];
  List<Map<String, dynamic>> _importantLinks = [];
  List<Map<String, dynamic>> _aboutSchool = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
  }

  Future<void> _fetchMenuItems() async {
    final data = await UserPermissions().getPermissions();
    setState(() {
      _quickActions = List<Map<String, dynamic>>.from(data['quickActions'] ?? []);
      _importantLinks = List<Map<String, dynamic>>.from(data['reports'] ?? []);
      _aboutSchool = List<Map<String, dynamic>>.from(data['aboutschools'] ?? []);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final uiTheme = Provider.of<UiThemeProvider>(context);

    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: uiTheme.bottomSheetBgColor ?? const Color(0xFF514197).withOpacity(0.1),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Navigation Menus",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              buildModuleGrid('Quick Actions', uiTheme, _quickActions),
              const SizedBox(height: 10),
              buildModuleGrid('Important Links', uiTheme, _importantLinks),
              const SizedBox(height: 10),
              buildModuleGrid('About School', uiTheme, _aboutSchool),
            ],
          ),
        ),
      ),
    );
  }
}

IconData getIconForModule(String moduleId) {
  switch (moduleId) {
  // Quick Actions
    case 'staff-attendance': return Icons.scanner;
    case 'inbox': return Icons.inbox;
    case 'attendance': return Icons.check_circle;
    case 'homework': return Icons.upload_file;
    case 'notice': return Icons.notifications;
    case 'assignment': return Icons.assignment;
    case 'syllabus': return Icons.menu_book;
    case 'circular': return Icons.blur_circular;
    case 'school-news': return Icons.newspaper;
    case 'student-photo': return Icons.photo_camera;
    case 'calendar': return Icons.calendar_month;
    case 'exam-entry': return Icons.fact_check;
    case 'PTM': return Icons.people;
    case 'master-update': return Icons.system_update;
    case 'student-leave': return Icons.person_remove;
    case 'staff-leave': return Icons.group_off;
    case 'transport-attendance': return Icons.directions_bus;


  // Important Links
    case 'student-list': return Icons.people;
    case 'student-fee-report': return Icons.request_page;
    case 'attendance-report': return Icons.bar_chart;
    case 'student-performance': return Icons.emoji_events;
    case 'exam-result': return Icons.school;
    case 'student-complaint': return Icons.report_problem;
    case 'my-student-birthday': return Icons.cake;
    case 'activity-gallery': return Icons.photo_library;
    case 'online-class': return Icons.video_call;

  // About School
    case 'website': return Icons.language;
    case 'about-school': return Icons.info;
    case 'manager-message': return Icons.message;
    case 'principal-message': return Icons.person;
    case 'school-rule-regulation': return Icons.rule;
    case 'staff-guidance': return Icons.support_agent;
    case 'school-staff': return Icons.groups;
    case 'contact-us': return Icons.contact_mail;

    default: return Icons.widgets; // fallback icon
  }
}

getRouteForModule(String moduleId) {
  switch (moduleId) {
    case 'attendance': return 'attendance';
    case 'homework': return 'upload-homework';
    case 'notice': return 'upload-notice';
    case 'assignment': return 'upload-assignment';
    case 'syllabus': return 'upload-syllabus';
    case 'circular': return 'upload-circular';
    case 'student-photo': return 'student-upload-image';
    case 'staff-photo': return 'staff-upload-image';
    case 'exam-entry': return 'exam-entry';
    case 'student-list': return 'student-list';
    case 'staff-list': return 'staff-list';
    case 'student-fee-report': return 'student-fee-report';
    case 'master-update': return 'master-update';
    case 'attendance-report': return 'student-attendance-reports';
    case 'student-performance': return 'student-performance';
    case 'exam-result': return 'exam-result';
    case 'student-complaint': return 'student-complaint';
    case 'activity-gallery': return 'activity-gallery';
    case 'online-class': return 'online-class';
    case 'staff-attendance': return 'mark-staff-attendance';
    case 'school-news': return 'school-news';
    default: return ''; // safe fallback
  }
}

Widget buildModuleGrid(String title, UiThemeProvider uiTheme , List<Map<String, dynamic>> modules) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: modules.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final module = modules[index];
          return GestureDetector(
            onTap: () {
              final route = getRouteForModule(module['module_id']);
              if (route.isNotEmpty) {
                context.pushNamed(route);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: uiTheme.iconBgColor?.withOpacity(0.1) ?? Colors.grey.shade100,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),

                  child: Icon(
                    getIconForModule(module['module_id']),
                    color: uiTheme.iconColor ?? const Color(0xFF514197),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  module['module_text'] ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: uiTheme.iconColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ],
  );
}
void showCustomMenuModal(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: const Color(0xFFF8F1F9),
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => const CustomMenuModal(),
  );
}
