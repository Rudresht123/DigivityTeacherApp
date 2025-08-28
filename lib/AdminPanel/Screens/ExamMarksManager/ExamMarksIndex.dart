import 'package:digivity_admin_app/AdminPanel/Components/ReportCardBox.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExamMarksIndex extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: SimpleAppBar(titleText: 'Student Marks Manager', routeName: 'back')),
      body: BackgroundWrapper(child:
     Container(
       margin: EdgeInsets.all(10),
       child:  Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Container(
             width: double.infinity,
             padding: const EdgeInsets.all(12),
             decoration: BoxDecoration(
               color: Colors.grey[300],
               borderRadius: BorderRadius.circular(6),
             ),
             child: Text(
               'Student Exam Entry',
               style: TextStyle(
                 fontWeight: FontWeight.w600,
                 fontSize: 16,
               ),
             ),
           ),
           SizedBox(height: 20,),
           ReportCardBox(icon: Icons.edit_note, title: 'Marks Entry', onTap: (){
             context.pushNamed('search-for-marks-entry');
           }),
           SizedBox(height: 10,),
           ReportCardBox(icon: Icons.edit_note, title: 'Remark Entry', onTap: (){
             context.pushNamed('search-for-remark-entry');
           }),
           SizedBox(height: 10,),
           ReportCardBox(icon: Icons.edit_note, title: 'Exam Other Entry', onTap: (){
             context.pushNamed('student-exam-other-entry-search');
           }),
         ],
       ),
     )
      ),
    );
  }
}