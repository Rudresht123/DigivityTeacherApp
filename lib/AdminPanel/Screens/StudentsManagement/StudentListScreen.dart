import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Components/SearchBox.dart';
import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentsManagement/StudentListBottomSheet.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Providers/StudentDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentListScreen extends StatefulWidget {


  const StudentListScreen({Key? key}) : super(key: key);

  @override
  State<StudentListScreen> createState() => _StudentListScreen();
}

class _StudentListScreen extends State<StudentListScreen> {
  final TextEditingController _studentSearchController = TextEditingController();

  List<Map<String, dynamic>> _originalList = [];
  List<Map<String, dynamic>> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _studentSearchController.addListener(_filterStudentList);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final students = Provider.of<StudentDataProvider>(context, listen: false).students;

      _updateStudentList(students);
    });
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
        'roll_no': student.rollNo ?? '',
        'student_name': student.studentName ?? '',
        'course': student.course ?? '',
        'contact_no': student.contactNo ?? '',
        'student_id': student.studentId ?? 0,
      };
    }).toList();
  }

  void _filterStudentList() {
    final query = _studentSearchController.text.toLowerCase();
    setState(() {
      _filteredList = _originalList.where((student) {
        return (student['student_name']?.toLowerCase().contains(query) ?? false) ||
            (student['roll_no']?.toString().toLowerCase().contains(query) ?? false) ||
            (student['admission_no']?.toString().toLowerCase().contains(query) ?? false) ||
            (student['course']?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  @override
  void dispose() {
    _studentSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: "Search Student List",
          routeName: 'back',
        ),
      ),
      body: BackgroundWrapper(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
              SearchBox(controller: _studentSearchController),
                const SizedBox(height: 16),
                Expanded(
                  child: _filteredList.isNotEmpty
                      ? ListView.builder(
                    itemCount: _filteredList.length,
                    itemBuilder: (context, index) {
                      final student = _filteredList[index];
                      return Card(
                        color: index % 2 == 0
                            ? const Color(0xFFDBF3E2) // First color
                            : const Color(0xFFE2E6EF), // Second color
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          onTap: () {
                            showStudentOptionsBottomSheet(
                              context,
                              student['student_name'] ?? 'Unknown Student',
                              student['student_id'].toString(),
                              student['contact_no'].toString(),
                              student['student_status'],
                            );
                          },
                          leading: PopupNetworkImage(
                            imageUrl: student['profile_img'],
                            radius: 30,
                          ),
                          title: Text(
                            student['student_name'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text("Roll No: ${student['roll_no']}")),
                                  Expanded(child: Text("Adm. No.: ${student['admission_no']}")),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child: Text("Father: ${student['father_name']}")),
                                  Expanded(child: Text("DOB: ${student['dob']}")),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child: Text("Course: ${student['course']}")),
                                  Expanded(child: Text("Mobile: ${student['contact_no']}")),
                                ],
                              ),
                            ],
                          ),
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
    );
  }
}
