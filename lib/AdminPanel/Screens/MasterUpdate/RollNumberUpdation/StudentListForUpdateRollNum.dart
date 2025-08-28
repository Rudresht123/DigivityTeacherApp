import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentModel.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/MasterUpdate.dart';
import 'package:digivity_admin_app/helpers/StudentsData.dart';
import 'package:flutter/material.dart';

class StudentListForUpdateRollNum extends StatefulWidget {
  final String? course;
  final String? shortByMethod;
  final String? orderByMethod;
  final String? selectedStatus;

  StudentListForUpdateRollNum({this.course, this.shortByMethod, this.orderByMethod, this.selectedStatus});

  @override
  State<StudentListForUpdateRollNum> createState() => _StudentListForUpdateRollNum();
}

class _StudentListForUpdateRollNum extends State<StudentListForUpdateRollNum> {
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
    if (widget.course == null || widget.shortByMethod == null) {
      print("Course or sortByMethod is null");
      hideLoaderDialog(context);
      return;
    }

    try {
      final students = await StudentsData().fetchStudents(
        courseId: widget.course!,
        sortByMethod: widget.shortByMethod!,
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
        'roll_no_controller': TextEditingController(
          text: student.rollNo != null ? student.rollNo.toString() : null,
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
      (student['roll_no_controller'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  void _submitUpdatedRollNumbers() async {
    final updatedList = _filteredList.map((student) {
      final rollController = student['roll_no_controller'];
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
      final response = await Masterupdate().updateStudentRollNo(data);

      if (response == true) {
        print(response);
        showBottomMessage(context, 'Roll Number Updated Successfully Done!', false);
        _fetchlatestdata();
      } else {
        showBottomMessage(context, 'Roll Number Not Updated Successfully Done!', true);
      }
    } catch (e) {
      showBottomMessage(context, "Failed to update roll numbers.", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: "Student Roll Number Update",
          routeName: 'back',
        ),
      ),
      body: BackgroundWrapper(
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
                      final controller = student['roll_no_controller'] as TextEditingController;

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? const Color(0xFFDBF3E2)
                              : const Color(0xFFE2E6EF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
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
                            Container(
                              height: 40,
                              width: 70,
                              padding: const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color(0xFFD2EADC),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: CustomTextField(
                                label: '',
                                hintText: 'Ex. 1',
                                controller: controller,
                              ),
                            ),
                          ],
                        ),
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
      child:CustomBlueButton(text: 'Update Roll No.', icon: Icons.edit, onPressed:_submitUpdatedRollNumbers,
       ),),
    );
  }
}
