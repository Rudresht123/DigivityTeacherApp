import 'dart:core';

import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/FieldSet.dart';
import 'package:flutter/material.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/CourseModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/ExamTermModel.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/MarksManagerHelpers/StudentMarksManagerCommonHelper.dart';
import 'package:go_router/go_router.dart';

class SearchForMarksEntry extends StatefulWidget {
  @override
  State<SearchForMarksEntry> createState() => _SearchForMarksEntryState();
}

class _SearchForMarksEntryState extends State<SearchForMarksEntry> {
  List<CourseModel> courseList = [];
  List<Examtermmodel> examTermList = [];

  String? selectedCourse;
  int? selectedExamTerm;
  int? selectedExamType;
  int? selectedAssessment;
  int? selectedSubject;
  String? course;
  String? examtype;
  String? assessment;
  String? Subject;
  String? examterm;

  List<Map<String, dynamic>> examTypeList = [];
  List<Map<String, dynamic>> assessmentList = [];
  List<Map<String, dynamic>> subjectList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchInitialData());
  }

  void fetchInitialData() async {
    showLoaderDialog(context);
    final data = await StudentMarksManagerCommonHelper().getMarksmanagerData();
    hideLoaderDialog(context);
    if (data.isNotEmpty) {
      setState(() {
        courseList = data['courseList'];

        examTermList = data['examTermList'];
      });
    }
  }

  Future<void> _fetchDropdownData({
    required String type,
    required Function(List<Map<String, dynamic>>) onSuccess,
  }) async {
    showLoaderDialog(context);

    final bodyData = {
      'getdata': type,
      'course_section_id': selectedCourse,
      'exam_term_id': selectedExamTerm?.toString(),
      'exam_type_id': selectedExamType?.toString(),
      'exam_assessment_id': selectedAssessment?.toString(),
    };

    final data = await StudentMarksManagerCommonHelper().getExamDynamicData(
      bodyData,
    );
    onSuccess(data);

    hideLoaderDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: 'Search For Marks Entry',
          routeName: 'back',
        ),
      ),
      body: BackgroundWrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CardContainer(
                padding: EdgeInsets.all(5),
                child: FieldSet(

                title: 'Search', child: Column(
              children: [
                CustomDropdown(
                  label: 'Grade/Class',
                  items: courseList
                      .map((e) => {'id': e.courseId, 'value': e.Course})
                      .toList(),
                  displayKey: 'value',
                  valueKey: 'id',
                  onChanged: (value) {
                    selectedCourse = value;
                    final selected = courseList.firstWhere((e) => e.courseId == value);
                    course = selected.Course; // Save display value
                    setState(() {});
                  },
                  hint: 'Select a Option',
                ),

                SizedBox(height: 20),
                CustomDropdown(
                  selectedValue: selectedExamTerm,
                  label: 'Exam Term',
                  items: examTermList
                      .map((e) => {'id': e.examtermId, 'value': e.examTerm})
                      .toList(),
                  displayKey: 'value',
                  valueKey: 'id',
                  onChanged: (value) async {
                    setState(() {
                      selectedExamTerm = value;
                      final selected = examTermList.firstWhere((e) => e.examtermId == value);
                      examterm = selected.examTerm;
                      examTypeList = [];
                      selectedExamType = null;
                      assessmentList = [];
                      selectedAssessment = null;
                      subjectList = [];
                      selectedSubject = null;
                    });
                    await _fetchDropdownData(
                      type: 'examtypelist',
                      onSuccess: (data) => setState(() => examTypeList = data),
                    );
                  },
                  hint: 'Select a Option',
                ),
                SizedBox(height: 20),

                _buildDropdown(
                  label: 'Exam Type',
                  items: examTypeList,
                  selectedValue: selectedExamType,
                  onChanged: (value) async {
                    setState(() {
                      selectedExamType = value;
                      assessmentList = [];
                      selectedAssessment = null;
                      subjectList = [];
                      selectedSubject = null;
                    });
                    await _fetchDropdownData(
                      type: 'examassessmentlist',
                      onSuccess: (data) => setState(() => assessmentList = data),
                    );
                  },
                  onValueSelected: (name) => examtype = name,
                ),
                _buildDropdown(
                  label: 'Exam Assessment',
                  items: assessmentList,
                  selectedValue: selectedAssessment,
                  onChanged: (value) async {
                    setState(() {
                      selectedAssessment = value;
                      subjectList = [];
                      selectedSubject = null;
                    });
                    await _fetchDropdownData(
                      type: 'examsubjectlist',
                      onSuccess: (data) => setState(() => subjectList = data),
                    );
                  },
                    onValueSelected: (name) => assessment = name
                ),
                _buildDropdown(
                  label: 'Exam Subject',
                  items: subjectList,
                  selectedValue: selectedSubject,
                  onChanged: (value) => setState(() => selectedSubject = value),
                  onValueSelected: (name) => Subject = name
                ),
              ],
            )))
          ],
        ),
      ),
      bottomNavigationBar: Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      child: CustomBlueButton(text: 'Submit', icon: Icons.search, onPressed: () async {
        List<String> keys = [
          'selectedCourse',
          'selectedExamTerm',
          'selectedAssessment',
          'selectedExamType',
          'selectedSubject'
        ];

        for (String key in keys) {
          final value = getValueByKey(key); // create this helper
          if (value == null) {
            final message = await getMessageForSubmit(key);
            if (message != null) {
              showBottomMessage(context, message, true);
              return;
            }
          }
        }

        context.pushNamed(
        'student-list-for-marks-entry',
        extra: {
        'course':course ?? '',
        'examtype':examtype ?? '',
          'examterm':examterm ?? '',
        'assessment':assessment ?? '',
        'Subject':Subject ?? '',
        'courseId':selectedCourse,
        'examtypeId':selectedExamType,
        'examtermId':selectedExamTerm,
        'assessmentId':selectedAssessment,
        'SubjectId':selectedSubject
        }
        );

      }),),
    );
  }

  Future<String?> getMessageForSubmit(String key) async{
    if(key=='selectedCourse'){
      return 'Please Select Course Section Firts';
    }else if(key=='selectedExamTerm'){
      return "Please Select Exam Term First";
    }
    else if(key=='selectedAssessment'){
      return 'Please Select Exam Assessment First';
    }
    else if(key=='selectedExamType'){
      return 'Please Select Exam Type First';
    }else if(key=='selectedSubject'){
      return 'Pelase Select Exam Subject First';
    }
    return null;
  }
  dynamic getValueByKey(String key) {
    switch (key) {
      case 'selectedCourse':
        return selectedCourse;
      case 'selectedExamTerm':
        return selectedExamTerm;
      case 'selectedAssessment':
        return selectedAssessment;
      case 'selectedExamType':
        return selectedExamType;
      case 'selectedSubject':
        return selectedSubject;
    }
  }

  Widget _buildDropdown({
    required String label,
    required List<Map<String, dynamic>> items,
    required dynamic selectedValue,
    required Function(dynamic) onChanged,
    Function(String)? onValueSelected, // <-- Add this
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: CustomDropdown(
        label: label,
        items: items.map((e) {
          return {'id': e['id'], 'value': e['name']};
        }).toList(),
        selectedValue: selectedValue ?? '',
        displayKey: 'value',
        valueKey: 'id',
        onChanged: (value) {
          onChanged(value);
          final selected = items.firstWhere((item) => item['id'] == value, orElse: () => {});
          if (onValueSelected != null && selected.isNotEmpty) {
            onValueSelected(selected['name']);
          }
        },
        hint: 'Select a Option',
      ),
    );
  }

}
