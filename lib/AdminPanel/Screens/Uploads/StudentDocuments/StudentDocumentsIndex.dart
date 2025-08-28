import 'package:digivity_admin_app/AdminPanel/Components/ReportCardBox.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Studentdocumentsindex extends StatefulWidget{
  @override
  State<Studentdocumentsindex> createState() {
    return _Studentdocumentsindex();
  }
}
class _Studentdocumentsindex extends State<Studentdocumentsindex>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: 'Student Documents', routeName: 'back'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            ReportCardBox(
              icon: Icons.description,
              title: 'Classwise Uploaded Documents Reports',
              onTap: () {
                context.pushNamed('classwise-student-document-upload-report');
              },
            ),
            const SizedBox(height: 16),
            ReportCardBox(
              icon: Icons.description,
              title: 'Students Uploded Documents ',
              onTap: () {
                context.pushNamed('filter-student-upload-documents');
              },
            ),
            // Card 1
          ],
        ),
      ),
    );
  }
}