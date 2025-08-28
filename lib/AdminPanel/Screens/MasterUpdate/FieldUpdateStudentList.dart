import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentModel.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Helpers/MasterUpdate.dart';
import 'package:digivity_admin_app/Helpers/StudentsData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FieldUpdateStudentList extends StatefulWidget{
  final String? selectedCourseId;
  final String? shortByMethod;
  final String? orderByMethod;
  final String? selectedStatus;
  final String? selectedField;

  FieldUpdateStudentList({required this.selectedCourseId,this.shortByMethod,this.orderByMethod,this.selectedStatus,required this.selectedField});


  @override
  State<StatefulWidget> createState() {
    return _FieldUpdateStudentList();
  }
}



class _FieldUpdateStudentList extends State<FieldUpdateStudentList>{
  final TextEditingController _studentSearchController = TextEditingController();
  List<Map<String, dynamic>> _originalList = [];
  List<Map<String, dynamic>> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _studentSearchController.addListener(_filterStudentList);

    WidgetsBinding.instance.addPostFrameCallback((_) async{
      _fetchlatestdata();
    });
  }

  void _fetchlatestdata() async {
    showLoaderDialog(context);

    if (widget.selectedCourseId == null) {
      print("Course or sortByMethod is null");
      hideLoaderDialog(context);
      return;
    }

    try {
      final students = await StudentsData().fetchStudents(
        courseId: widget.selectedCourseId!,
        sortByMethod: widget.shortByMethod ?? 'first_name',
        orderByMethod: widget.orderByMethod ?? 'asc',
        selectedStatus: widget.selectedStatus ?? 'active',
      );

      hideLoaderDialog(context);

      _updateStudentList(students);
    } catch (e) {
      hideLoaderDialog(context);
      print("Error fetching students: $e");
    }
  }

  void _updateStudentList(List<StudentModel> students) {
    final mappedList = _mapStudentList(students);
    setState(() {
      _originalList = mappedList;
      _filteredList = mappedList;
    });
  }
  List<Map<String, dynamic>> _mapStudentList(List<StudentModel> students) {
    return students.map((student) {
      return {
        'profile_img': student.profileImg ?? '',
        'student_status': student.studentStatus ?? '',
        'father_name': student.fatherName ?? '',
        'dob': student.dob ?? '',
        'admission_no': student.admissionNo ?? '',
        'roll_no': student.rollNo ?? 0,
        'student_name': student.studentName ?? '',
        'course': student.course ?? '',
        'contact_no': student.contactNo ?? '',
        'student_id': student.studentId ?? 0,
        'dbId': student.dbId ?? 0,
        'field_controller': TextEditingController(
          text: StudentsData().getFieldValueFromStudent(student,widget.selectedField!.toString()),
        ),
      };
    }).toList();
  }
  void _filterStudentList() {
    final query = _studentSearchController.text;
    setState(() {
      _filteredList = StudentsData().filterStudents(originalList: _originalList, query: query);
    });
  }

  @override
  void dispose() {
    _studentSearchController.dispose();
    for (var student in _originalList) {
      (student['field_controller'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  void _submitUpdatedFieldRecord() async {
    final updatedList = _filteredList.map((student) {
      final rollController = student['field_controller'];
      final rollText = (rollController is TextEditingController)
          ? rollController.text.trim()
          : '';
      return {
        'student_id': student['student_id'],
        'roll_no': rollText.isEmpty ? null : rollText,
      };
    }).toList();

    final data = {
      'updatedatalist': updatedList,
    };

    try {
      final response = await Masterupdate().updateStudentFieldData(widget.selectedField,data);

      if (response == true) {
        print(response);
        showBottomMessage(context, 'Data Updated Successfully Done!', false);
         _fetchlatestdata();
      } else {
        showBottomMessage(context, 'Data Not Updated Successfully Done!', true);
      }
    } catch (e) {
      showBottomMessage(context, "Failed to update data.", true);
    }
  }



  @override
  Widget build(BuildContext context) {
    bool isDob= widget.selectedField == 'dob' ? true : false;
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: SimpleAppBar(titleText: 'Student Update Data ${widget.selectedField?.toUpperCase() ?? ''}', routeName: 'back')),
      body:  BackgroundWrapper(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextField(
                  label: 'Search Student',
                  hintText: 'Search by name...',
                  controller: _studentSearchController,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _filteredList.isNotEmpty
                      ? ListView.separated(
                    itemCount: _filteredList.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.grey.shade300, height: 1),
                    itemBuilder: (context, index) {
                      final student = _filteredList[index];
                      final controller = student['field_controller'] as TextEditingController;

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? const Color(0xFFDBF3E2)
                              : const Color(0xFFE2E6EF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:Column(
                          children: [
                            Row(
                              children: [
                                PopupNetworkImage(imageUrl: student['profile_img'], radius: 20),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Adm No.: ${student['admission_no'] ?? '-'} | Roll No.: ${student['roll_no'] ?? 'N/A'}",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "${student['student_name'] ?? ''} (${student['course'] ?? ''})",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "D/O : ${student['father_name'] ?? ''}",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),

                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              height: 40,
                              width: double.infinity,
                              padding: const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                borderRadius:isDob ? BorderRadius.circular(8) : BorderRadius.circular(5),
                                color: const Color(0xFFD2EADC),
                                border: Border.all(color: Colors.grey),
                              ),
                              child:isDob ? DatePickerField(
                                controller:controller,
                              ) : CustomTextField(
                                label: '',
                                hintText: 'Ex. 1',
                                controller: controller,
                              ),
                            ),
                          ],
                        )

                      );
                    },
                  )
                      : const Center(child: Text("No students found")),
                ),
              ],
            ),
          ),
        ),

      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child:CustomBlueButton(text: 'Update Field Record.', icon: Icons.save, onPressed:_submitUpdatedFieldRecord,
        ),),
    );

  }
}
