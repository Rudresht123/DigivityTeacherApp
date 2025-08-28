import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/MarksManagerComponent/CoursesDropDown.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/MarksManagerComponent/ExamTermDropdown.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentPtmSearch extends StatefulWidget{
  @override
  State<StudentPtmSearch> createState() {
    return _StudentPtmSearch();
  }
}



class _StudentPtmSearch extends State<StudentPtmSearch>{

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedCourse;
  int? selectedExamTerm;
  String? course;
  String? examTerm;
  String? selectdForAttendance;
  bool isLoading = false;
  final List<Map<String,dynamic>> forattendance = [
    {"id":'student','value':"Student Total Attend PTM"},
    {"id":'class','value':"Class Total PTM"},
  ];

  @override
  void initState() {
    super.initState(); // Keep only this
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: SimpleAppBar(titleText: 'Search For PTM', routeName: 'back')),
      body: BackgroundWrapper(child:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CardContainer(child:Form(
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
                  CustomDropdown(
                      label: 'PTM Submit For', items:
                  forattendance.map((e){
                    return {
                      'id':e['id'],
                      'value':e['value']
                    };
                  }).toList()
                      , displayKey: 'value', valueKey: 'id', onChanged: (value){
                    selectdForAttendance=value;
                    setState(() {

                    });
                  },
                      validator:(selectdForAttendance){
                        if(selectdForAttendance==null){
                          return "Please Select Attendance For First";
                        }
                        return null;
                      },hint: 'Select a Option')
                ],
              )))
        ],
      )
      ),
      bottomNavigationBar: Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
        child: CustomBlueButton(text: 'Search', icon: Icons.search, onPressed: (){
          if(_formKey.currentState!.validate()){

            if(selectdForAttendance=='student'){
              context.pushNamed('student-total-attend-ptm-entry',
                  extra: {
                    'courseId':selectedCourse,
                    'examTermId':selectedExamTerm,
                    'course':course,
                    'examTerm':examTerm
                  }
              );
            }
            else if(selectdForAttendance=='class'){
              context.pushNamed('class-total-conducted-ptm-entry',
                  extra: {
                    'courseId':selectedCourse,
                    'examTermId':selectedExamTerm,
                    'course':course,
                    'examTerm':examTerm
                  }
              );
            }
          }
        }),),
    );
  }
}