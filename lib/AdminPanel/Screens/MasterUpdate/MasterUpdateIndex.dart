import 'package:digivity_admin_app/AdminPanel/Components/ReportCardBox.dart';
import 'package:digivity_admin_app/AdminPanel/Components/ReportCardBox.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MasterUpdateIndex extends StatefulWidget{
  @override
  State<MasterUpdateIndex> createState() {
    return _MasterUpdateIndex();
  }
}
class _MasterUpdateIndex extends State<MasterUpdateIndex>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: 'Master Update', routeName: 'back'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ReportCardBox(
              icon: Icons.description,
              title: 'Student Roll Number Updation',
              onTap: () {
                context.pushNamed('search-student-for-roll-number');
              },
            ),
            const SizedBox(height: 16),
            // Card 1
            ReportCardBox(
              icon: Icons.description,
              title: 'Student Field Updation',
              onTap: () {
                context.pushNamed('student-field-update-form-search');
              },
            ),



          ],
        ),
      ),
    );
  }
}