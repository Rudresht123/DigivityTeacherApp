import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

void main() => runApp(MultiSchoolApp());

class MultiSchoolApp extends StatefulWidget {
  @override
  _MultiSchoolAppState createState() => _MultiSchoolAppState();
}

class _MultiSchoolAppState extends State<MultiSchoolApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Switcher',
      debugShowCheckedModeBanner: false,

      home: SwitchUserScreen(),
    );
  }
}

class SwitchUserScreen extends StatelessWidget {
  final List<Map<String, String>> users = [
    {
      'school_name': 'LRSMPS Noida',
      'base_url': 'lrsmpsnoida.erpwala.in',
    },
    {
      'school_name': 'LRSMPS Bihar',
      'base_url': 'lrsmpsbihar.erpwala.in',
    },
  ];

  void switchUser(BuildContext context, String schoolName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Switched to $schoolName')),
    );
  }

  void deleteUser(BuildContext context, String schoolName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deleted $schoolName')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: SimpleAppBar(titleText: 'ADD NEW USER', routeName: 'back')),
      body:BackgroundWrapper(child:
      Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saved Schools',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return GlassCard(
                        schoolName: user['school_name']!,
                        baseUrl: user['base_url']!,
                        onDelete: () => deleteUser(context, user['school_name']!),
                        onSwitch: () => switchUser(context, user['school_name']!),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.person_add_alt, color: Colors.white),
                  label: Text("Add User (Same School)"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.school_outlined),
                  label: Text("Add User (New School)"),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    side: BorderSide(color: Colors.white),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class GlassCard extends StatelessWidget {
  final String schoolName;
  final String baseUrl;
  final VoidCallback onDelete;
  final VoidCallback onSwitch;

  const GlassCard({
    required this.schoolName,
    required this.baseUrl,
    required this.onDelete,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
          ),
          padding: EdgeInsets.all(8),
          child: Icon(Icons.school, color: Colors.black87, size: 28),
        ),
        title: Text(
          schoolName,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          baseUrl,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 13,
          ),
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            Tooltip(
              message: "Switch User",
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onSwitch,
                child: CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: Icon(Icons.sync, color: Colors.green),
                ),
              ),
            ),
            Tooltip(
              message: "Delete User",
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onDelete,
                child: CircleAvatar(
                  backgroundColor: Colors.red.shade100,
                  child: Icon(Icons.delete, color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
