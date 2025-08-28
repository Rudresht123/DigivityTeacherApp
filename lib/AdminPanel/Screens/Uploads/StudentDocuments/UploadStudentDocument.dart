import 'package:digivity_admin_app/AdminPanel/Models/StudentDocUploadsModels/StudentDocumentUpload.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/StudentDocuments/UploadDocumentBottomSheet.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/UploadsDocumentsHelpers/StudentDocumentsUploadHelpers.dart';
import 'package:flutter/material.dart';

class UploadStudentDocument extends StatefulWidget {
  final String studentName;
  final String Course;
  final String admissionNo;
  final String imageUrl;
  final String fatherName;
  final String motherName;
  final int StudentId;

  UploadStudentDocument({
    required this.studentName,
    required this.fatherName,
    required this.motherName,
    required this.imageUrl,
    required this.admissionNo,
    required this.StudentId,
    required this.Course,
  });

  @override
  State<UploadStudentDocument> createState() => _UploadStudentDocument();
}

class _UploadStudentDocument extends State<UploadStudentDocument> {
  List<StudentDocumentUpload>? documentsdata = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoaderDialog(context);
      fetchDocumentsRecords();
      hideLoaderDialog(context);
    });
  }

  Future<void> fetchDocumentsRecords() async {
    final docdata = await Studentdocumentsuploadhelpers()
        .getStudentUploadDocuments(widget.StudentId);
    setState(() {
      documentsdata = docdata;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: '${widget.studentName} (${widget.Course})',
          routeName: 'back',
        ),
      ),
      body: BackgroundWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  "Student Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              // Student Card
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: widget.imageUrl.isNotEmpty
                          ? Image.network(
                              widget.imageUrl,
                              height: 110,
                              width: 80,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/default_student.png',
                              height: 100,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow("Adm. No", widget.admissionNo),
                          _buildInfoRow("Grade/Class-Sec.", widget.Course),
                          _buildInfoRow("Student's Name", widget.studentName),
                          _buildInfoRow("Father's Name", widget.fatherName),
                          _buildInfoRow("Mother's Name", widget.motherName),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Documents Title
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Documents",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        showLoaderDialog(context);
                        await fetchDocumentsRecords();
                        hideLoaderDialog(context);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.refresh, color: Colors.blue, size: 18),
                          SizedBox(width: 4),
                          Text("Refresh", style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Document List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DocumentSection(
                  studentId: widget.StudentId,
                  studentName: widget.studentName,
                  documents: documentsdata!,
                  onRefresh: fetchDocumentsRecords,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$title ",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              ": $value",
              style: TextStyle(
                fontSize: 11,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Document Section Widget
class DocumentSection extends StatelessWidget {
  final List<StudentDocumentUpload> documents;
  final String studentName;
  final int studentId;
  final Future<void> Function() onRefresh;
  const DocumentSection({
    super.key,
    required this.documents,
    required this.studentName,
    required this.studentId,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (documents.isEmpty) {
      return Center(child: Text("No documents found."));
    }

    return Column(
      children: List.generate(documents.length, (index) {
        final doc = documents[index];
        final isUploaded =
            doc.documentFile != null && doc.documentFile!.isNotEmpty;

        return InkWell(
          onTap: () async {
            final result = await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => UploadDocumentBottomSheet(
                studentName: studentName,
                documentName: doc.documentName,
                StudentId: studentId,
                documentId: doc.documentId,
                docuemntFile: doc.documentFile,
                onupload: (Map<String, dynamic> bodydata) async {
                  final response = await Studentdocumentsuploadhelpers()
                      .uploadStudentDocuemnt(bodydata);
                  if (response['result'] == 1) {
                    onRefresh();
                  }
                  return response;
                },
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isUploaded ? Colors.green : Colors.red),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Side
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.documentName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      isUploaded ? "Uploaded" : "No Document Found!",
                      style: TextStyle(
                        color: isUploaded ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.cloud_upload_rounded, color: Colors.blue),
              ],
            ),
          ),
        );
      }),
    );
  }
}
