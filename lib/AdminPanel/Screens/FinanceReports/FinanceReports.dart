import 'package:digivity_admin_app/AdminPanel/Components/ReportCardBox.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FinanceReports extends StatefulWidget {
  @override
  State<FinanceReports> createState() {
    return _FinanceReports();
  }
}

class _FinanceReports extends State<FinanceReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: 'Attendance Reports', routeName: 'back'),
      ),
      body: BackgroundWrapper(child:
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Fee Collection Reports',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Card 1
              ReportCardBox(
                icon: Icons.description,
                title: 'Fee Collection Report',
                onTap: () {
                  context.pushNamed('fee-collection-report-form');
                },
              ),


              // Card 2
              ReportCardBox(
                icon: Icons.event_note,
                title: 'Daybook Report',
                onTap: () {
                  context.pushNamed('daybook-report');
                },
              ),

              ReportCardBox(
                icon: Icons.event_note,
                title: 'Fee Head Wise Fee Collection Report',
                onTap: () {
                  context.pushNamed('feehead-wise-collection-report');
                },
              ),

              ReportCardBox(
                icon: Icons.event_note,
                title: 'Paymode Wise Fee Collection Report',
                onTap: () {
                  context.pushNamed('paymode-wise-collection-report');
                },
              ),

              ReportCardBox(
                icon: Icons.event_note,
                title: 'Class/Course-Section Wise Fee Collection Report',
                onTap: () {
                  context.pushNamed('class-section-wise-collection-report');
                },
              ),


              ReportCardBox(
                icon: Icons.event_note,
                title: 'Monthly Fee Collection Report',
                onTap: () {
                  context.pushNamed('monthly-fee-collection-report');
                },
              ),

              ReportCardBox(
                icon: Icons.event_note,
                title: 'Daily Receipt Consession Report',
                onTap: () {
                  context.pushNamed('daily-concession-report');
                },
              ),


              ReportCardBox(
                icon: Icons.event_note,
                title: 'Class Wise Consolidate Report',
                onTap: () {
                  context.pushNamed('classwise-consolidate-report');
                },
              ),


              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Fee Defaulter Reports',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ReportCardBox(
                icon: Icons.event_note,
                title: 'Class/Course Wise Student Fee Defaulter Report',
                onTap: () {
                  context.pushNamed('classwise-student-fee-defaulter-report');
                },
              ),

            ],
          ),
        ),
      )),
    );
  }

}
