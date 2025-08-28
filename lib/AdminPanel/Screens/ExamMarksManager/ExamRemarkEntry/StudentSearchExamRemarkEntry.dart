import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/CourseModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/ExamTermModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/MarksManagerComponent/CoursesDropDown.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/MarksManagerComponent/ExamTermDropdown.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/MarksManagerHelpers/StudentMarksManagerCommonHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentSearchExamRemarkEntry extends StatefulWidget{

  @override
  State<StudentSearchExamRemarkEntry> createState() {
    return _StudentSearchExamRemarkEntry();
  }
}


class _StudentSearchExamRemarkEntry extends State<StudentSearchExamRemarkEntry>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<CourseModel> courseList = [];
  List<Examtermmodel> examTermList = [];
  String? selectedCourse;
  int? selectedExamTerm;
  String? course;
  String? examtype;
  String? selectedexamEntryMode;
  String? examterm;
  List<Map<String, dynamic>> examEntryMode = [
    {"id": "typing", "value": "Typing"},
    {"id": "dropdown", "value": "Dropdown"},
  ];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: SimpleAppBar(titleText: 'Search Remark Entry', routeName: 'back')),
      body: BackgroundWrapper(child:
      Column(
        mainAxisAlignment:  MainAxisAlignment.start,
        children: [
        Form(
            key: _formKey,
            child:  CardContainer(child: Column(
          children: [
            CoursesDropdown(
              onCourseSelected: (courseId, courseName) {
                selectedCourse = courseId;
                course = courseName;
                setState(() {});
              },
              onFetchStarted: () {
                setState(() {
                  isLoading = true;
                });
                showLoaderDialog(context);
              },
              onFetchCompleted: () {
                setState(() {
                  isLoading = false;
                });
                hideLoaderDialog(context);
              },
            ),
            SizedBox(height: 20),

            ExamTermDropdown(
             onExamTermSelected: (examTermId,examTerm) async {
               setState(() {
                 selectedExamTerm = int.tryParse(examTermId);
                 examterm = examTerm;
               });
             },
           ),
            SizedBox(height: 20),
            CustomDropdown(
                label: 'Remarks Entry Mode',
                selectedValue: selectedexamEntryMode,
                items:
                examEntryMode.map((e){
                  return {
                    'id':e['id'],
                    'value':e['value']
                  };
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select First Remark Entry Mode';
                  }
                  return null;
                }
                , displayKey: 'value', valueKey: 'id', onChanged: (value){
              selectedexamEntryMode=value;
            }, hint: 'Select a Option')
          ],
        )))
        ],
      )
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: CustomBlueButton(
          text: 'Search',
          icon: Icons.search,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.pushNamed(
                'student-list-for-remark-entry',
                extra: {
                  'courseId': selectedCourse,
                  'examtermId': selectedExamTerm,
                  'remarkEntryMode': selectedexamEntryMode,
                  'course': course,
                  'examterm': examterm,
                },
              );
            }
          },
        ),
      ),

    );
  }



}