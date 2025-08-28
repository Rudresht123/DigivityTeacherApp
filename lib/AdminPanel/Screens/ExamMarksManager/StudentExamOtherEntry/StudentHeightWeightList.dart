import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/MarksManagerComponent/CoursesDropDown.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/MarksManagerComponent/ExamTermDropdown.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentHeightWeightList extends StatefulWidget{

  @override
  State<StudentHeightWeightList> createState() {
    return _StudentHeightWeightList();
  }
}

class _StudentHeightWeightList extends State<StudentHeightWeightList>{

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedCourse;
  int? selectedExamTerm;
  bool isLoading = false;
  String? course;
  String? examTerm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: SimpleAppBar(titleText: 'Student Search', routeName: 'back')),
      body: BackgroundWrapper(child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CardContainer(child:
          Form(
              key: _formKey,
              child:  Column(
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
                  SizedBox(height: 20,),
                  ExamTermDropdown(
                    onExamTermSelected: (examTermId,examTermName){
                      selectedExamTerm=int.tryParse(examTermId);
                      examTerm=examTermName.toString();
                      setState(() {

                      });
                    },
                  ),
                  SizedBox(height: 20,),

                ],
              )))
        ],
      )),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: CustomBlueButton(
            text: 'Search',
            icon: Icons.search,
            onPressed: () async{
              if(_formKey.currentState!.validate()){
                  context.pushNamed('student-height-weight-entry',
                      extra: {
                        'courseId':selectedCourse,
                        'examTermId':selectedExamTerm,
                        'course':course,
                        'examTerm':examTerm
                      }
                  );
                }
              }



        ),
      ),
    );
  }
}