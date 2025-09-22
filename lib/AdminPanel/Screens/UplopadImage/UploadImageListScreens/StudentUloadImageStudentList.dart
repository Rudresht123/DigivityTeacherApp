import 'package:digivity_admin_app/AdminPanel/Components/CustomImagePicker.dart';
import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentModel.dart';

import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Providers/StudentDataProvider.dart';
import 'package:digivity_admin_app/helpers/ImagePicker.dart';
import 'package:digivity_admin_app/helpers/StudentsData.dart';
import 'package:digivity_admin_app/helpers/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class StudentUloadImageStudentList extends StatefulWidget{

  final String? course;
  final String? shortByMethod;
  final String? orderByMethod;
  final String? selectedStatus;

  StudentUloadImageStudentList({this.course,this.shortByMethod,this.orderByMethod,this.selectedStatus});
  @override
  State<StudentUloadImageStudentList> createState() {
    return _StudentUloadImageStudentList();
  }
}


class _StudentUloadImageStudentList extends State<StudentUloadImageStudentList>{
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
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: "Student Image Upload",
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

                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? const Color(0xFFDBF3E2) // First color
                              : const Color(0xFFE2E6EF), // Second color
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            PopupNetworkImage(imageUrl: student['profile_img'],radius: 30,),
                            // Profile image

                            const SizedBox(width: 14),

                            // Student details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Adm No. and Roll No.
                                  Text(
                                    "Adm No.: ${student['admission_no'] ?? '-'} | Roll No.: ${student['roll_no'] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),

                                  // Name & Class
                                  Text(
                                    "${student['student_name'] ?? ''} (${student['course'] ?? ''})",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),

                                  // Father's Name
                                  Text(
                                    "Father : ${student['father_name'] ?? ''}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Color(0xFF514197).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child:  IconButton(
                                onPressed: () {
                                  showImagePickerBottomSheet(
                                    context: context,
                                    condidatename:  "${student['student_name'] ?? ''} (${student['course'] ?? ''})",
                                    onCameraTap: () async{
                                        final imageHandler = ImageHandler();
                                        await imageHandler.pickAndResizeImage(
                                            source: ImageSource.camera);

                                        if (imageHandler.resizedImageFile !=
                                            null) {
                                          showLoaderDialog(context);

                                          final response = await imageHandler
                                              .uploadResizedImage(
                                              'student', student['dbId']);

                                          if (response['result'] == 1) {
                                            final provider = Provider.of<
                                                StudentDataProvider>(
                                                context, listen: false);

                                            await provider.fetchStudents(
                                              courseId: widget.course,
                                              sortByMethod: widget
                                                  .shortByMethod,
                                              orderByMethod: widget
                                                  .orderByMethod,
                                              selectedStatus: widget
                                                  .selectedStatus,
                                            );

                                            _updateStudentList(provider
                                                .students);
                                            hideLoaderDialog(context);// This updates the UI list properly
                                            showBottomMessage(
                                                context, response['message'],
                                                false);
                                            hideLoaderDialog(context);
                                          } else {
                                            hideLoaderDialog(context);
                                            showBottomMessage(
                                                context, response['message'],
                                                true);
                                          }
                                        } else {
                                          ScaffoldMessenger
                                              .of(context)
                                              .showSnackBar(
                                            const SnackBar(content: Text(
                                                "⚠️ No image selected")),
                                          );
                                        }




                                    },
                                    onGalleryTap: () async {
                                      final imageHandler = ImageHandler();
                                      await imageHandler.pickAndResizeImageFromGalery(
                                        source: ImageSource.gallery,
                                      );

                                      if (imageHandler.resizedImageFile == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("⚠️ No image selected from gallery")),
                                        );
                                        return;
                                      }

                                      showLoaderDialog(context);

                                      final response = await imageHandler.uploadResizedImage(
                                        'student',
                                        student['dbId'],
                                      );

                                      final provider =
                                      Provider.of<StudentDataProvider>(context, listen: false);

                                      hideLoaderDialog(context);

                                      if (response['result'] == 1) {
                                        await provider.fetchStudents(
                                          courseId: widget.course,
                                          sortByMethod: widget.shortByMethod,
                                          orderByMethod: widget.orderByMethod,
                                          selectedStatus: widget.selectedStatus,
                                        );

                                        _updateStudentList(provider.students);

                                        showBottomMessage(context, response['message'], false);
                                      } else {
                                        showBottomMessage(context, response['message'], true);
                                      }
                                    },

                                  );
                                },
                                icon: const Icon(Icons.camera_alt_outlined, color: Colors.green),
                              ),
                            ),
                            // Camera icon button

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
    );
  }
}