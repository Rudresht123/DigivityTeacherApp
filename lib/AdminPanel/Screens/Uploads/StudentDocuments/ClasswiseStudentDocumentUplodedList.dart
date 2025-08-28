import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Components/SearchBox.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StudentDocUploadsModels/StudentDocumentUplodedModel.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/UploadsDocumentsHelpers/StudentDocumentsUploadHelpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClasswiseStudentDocumentUplodedList extends StatefulWidget{
  final String courseId;
  final String? selectedSortBy;
  final String selectedStudentSort;

  ClasswiseStudentDocumentUplodedList({
    required this.courseId,
    this.selectedSortBy,
    required this.selectedStudentSort,
    super.key,
});
  @override
  State<ClasswiseStudentDocumentUplodedList> createState() {
    return _ClasswiseStudentDocumentUplodedList();
  }
}
class _ClasswiseStudentDocumentUplodedList extends State<ClasswiseStudentDocumentUplodedList> {
  Map<String, dynamic> bodydata = {};
  List<StudentDocumentUplodedModel> _students = [];
  TextEditingController _searchController = TextEditingController();
  List<StudentDocumentUplodedModel> _filteredStudents = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudents = _students.where((student) {
        return student.studentName.toLowerCase().contains(query) ||
            student.admissionNo.toLowerCase().contains(query) ||
            student.fatherName.toLowerCase().contains(query);
      }).toList();
    });
  }


  Future<void> _fetchData() async {
    showLoaderDialog(context);
    final helper = Studentdocumentsuploadhelpers();

    bodydata = {
      'course_id': widget.courseId,
      'sort_by_method': "sortBy",
    };

    final result = await helper.getClasswiseStudentUplodedDocuments(bodydata);
    hideLoaderDialog(context);

    setState(() {
      _students = result!;
      _filteredStudents = _students;
    });

  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: 'Student Documents', routeName: 'back'),
      ),
        body: _students.isEmpty
            ? Center(child: Text("No documents found."))
            : BackgroundWrapper(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(10),child: SearchBox(controller: _searchController),),
              // Other widgets here (e.g., filters, headers, etc.)
              Expanded(
                child: ListView.separated(
                  itemCount: _filteredStudents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 1),
                  itemBuilder: (context, index) {
                    final student = _filteredStudents[index];
                    return StudentDocumentItem(
                      name: student.studentName,
                      StudentId:student.studentId,
                      course: student.course,
                      admissionNo: student.admissionNo,
                      parentName: 'Father :  ${student.fatherName}',
                      imageUrl: student.profileImg,
                      uploadedDocs: student.totalUploadedDoc,
                      notUploadedDocs:
                      student.totalDoc - student.totalUploadedDoc,
                      motherName: student.motherName,
                    );
                  },
                ),
              )
            ],
          ),
        ),
    );
  }
}

class StudentDocumentItem extends StatelessWidget {
  final String name;
  final int StudentId;
  final String admissionNo;
  final String course;
  final String parentName;
  final String imageUrl;
  final int uploadedDocs;
  final int notUploadedDocs;
  final String? motherName;

  const StudentDocumentItem({
    required this.name,
    required this.StudentId,
    required this.course,
    required this.admissionNo,
    required this.parentName,
    required this.imageUrl,
    required this.uploadedDocs,
    required this.notUploadedDocs,
    required this.motherName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            PopupNetworkImage(
              imageUrl: imageUrl,
              radius: 25,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 1),
                  Text("Adm. No. ($admissionNo)",
                      style: TextStyle(fontSize: 12, color: Colors.black)),
                  Text(parentName,
                      style: TextStyle(fontSize: 12, color: Colors.black)),
                ],
              ),
            ),
            Column(
              children: [
                Chip(
                  padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                  label: Text(
                    "Uploaded Docs: ($uploadedDocs)",
                    style: const TextStyle(fontSize: 10),
                  ),
                  backgroundColor: Colors.green.shade50,
                  labelStyle: TextStyle(color: Colors.green.shade800),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 1),
               InkWell(
                 onTap: () {
                   context.pushNamed(
                     'student-document-upload',
                     extra: {
                       'studentName': name,
                       'course': course,
                       'studentId': StudentId,
                       'admissionNo': admissionNo,
                       'fatherName': parentName,
                       'motherName': motherName,
                       'imageUrl': imageUrl
                     },
                   );
                 },
                 child:  Chip(
                   label: Text(
                     "Not Uploaded: ($notUploadedDocs)",
                     style: const TextStyle(fontSize: 10),
                   ),
                   backgroundColor: Colors.red.shade50,
                   labelStyle: TextStyle(color: Colors.red.shade800),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(20), // Change this value as needed
                   ),
                 ),
               )
              ],
            )
          ],
        ),
      ),
    );
  }
}
