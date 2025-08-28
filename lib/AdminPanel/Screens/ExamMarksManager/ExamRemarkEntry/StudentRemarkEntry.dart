
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/ExamRemarkListModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/StudentRemarkEntry.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/ExamRemarkEntry/StudentRemakEntryCard.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/MarksManagerHelpers/StudentMarksManagerCommonHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Studentremarkentry extends StatefulWidget {
  late final String? course;
  late final String? remarkEntryMode;
  late final String? examterm;
  late final String? courseId;
  late final int? examtermId;
  Studentremarkentry({
    required this.courseId,
    required this.examtermId,
    required this.course,
    required this.remarkEntryMode,
    required this.examterm,
  });

  @override
  State<Studentremarkentry> createState() {
    return _Studentremarkentry();
  }
}

class _Studentremarkentry extends State<Studentremarkentry> {
  Map<String, TextEditingController> remarksControllers = {};
  Map<String, TextEditingController> remarksidControllers = {};
  List<StudentRemarkEntry> studentList = [];
  List<ExamRemarkList> remarkList=[];
  late final TextEditingController commonRemarkController;

  @override
  void initState() {
    super.initState();

    commonRemarkController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getStudentList(); // Wait for studentList first
      if (widget.remarkEntryMode == 'dropdown') {
        await getExamRemarkList();
      }

      // When common remark changes, update all student remark fields
      commonRemarkController.addListener(() {
        for (var controller in remarksControllers.values) {
          controller.text = commonRemarkController.text;
        }
      });
    });
  }


  Future<void> getStudentList() async {
    final bodydata = {
      "course_section_id": widget.courseId,
      "exam_term_id": widget.examtermId,
      "exam_type_id":widget.remarkEntryMode
    };
    final response = await StudentMarksManagerCommonHelper().apistudentlistremarksentry(bodydata);
    if (response != null) {
      setState(() {
        studentList = response;

        // Initialize controllers
        for (var student in studentList) {
          remarksControllers[student.studentId.toString()] =
              TextEditingController(text: student.remark?.toString() ?? '');
          remarksidControllers[student.studentId.toString()] =
              TextEditingController(text: student.remark?.toString() ?? '');
        }
      });
    }
  }

  Future<void> getExamRemarkList() async {
    final remarks = await StudentMarksManagerCommonHelper().getExamRemarks();
    print(remarks);
    if (remarks != null) {
      setState(() {
        remarkList = remarks;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: 'Student Marks Entry',
          routeName: 'back',
        ),
      ),
      body: BackgroundWrapper(
        child: Column(
          children: [
            // Top Exam Info
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoRow(
                          "Class/Course",
                          widget.course ?? '',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildInfoRow(
                          "Exam Term",
                          widget.examterm ?? '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(

            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 widget.remarkEntryMode =='typing' ?
                     CustomTextField(label: 'Remark', hintText: 'Enter Common Remark', controller: commonRemarkController)
                     :Column(
                   children: [
                     InkWell(
                         onTap: () async{
                           showLoaderDialog(context);
                           await getExamRemarkList();
                           hideLoaderDialog(context);
                         },
                       child:  Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                           Icon(Icons.refresh, color: Colors.blue, size: 18),
                           SizedBox(width: 4),

                           Text("Refresh",
                               style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)),

                         ],
                       ),
                     ),
                     Divider(),
                     CustomDropdown(items:
                     remarkList.map((e){
                       return {
                         'id':e.Id.toString(),
                         'value':e.examremark
                       };
                     }).toList(), displayKey: 'value', valueKey: 'id', onChanged: (value) async {
                       showLoaderDialog(context); // Show loader

                       // Update all remark ID controllers
                       for (var controller in remarksidControllers.values) {
                         controller.text = value;
                       }

                       // Give the UI a moment to update (awaiting next frame)
                       await Future.delayed(Duration(milliseconds: 100));

                       // Call setState if needed to rebuild the UI
                       if (mounted) setState(() {});

                       hideLoaderDialog(context); // Now hide the loader
                     },
                         hint: 'Select a Option')
                   ],
                 )
                ],
              ),
            ),
            Divider(),


            /// Student List
            Expanded(
              child: studentList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                itemCount: studentList.length,
                itemBuilder: (context, index) {
                  final student = studentList[index];
                  final key = student.studentId.toString();
                  final remarksController = remarksControllers[student.studentId.toString()]!;
                  final remarksidController = remarksidControllers[student.studentId.toString()]!;
                  return StudentRemakEntryCard(
                    admissionNo: student.admissionNo.toString(),
                    studentName: student.studentName,
                    fatherName: student.fatherName,
                    profileImg: student.profileImg,
                    remarksController: remarksController,
                    remarksidController:remarksidController,
                    remarkEntryMode: student.remarkEntryMode,
                    entrymode :widget.remarkEntryMode,
                    remarkList:remarkList!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: CustomBlueButton(
            text: 'Save Remarks',
            icon: Icons.save,
            onPressed: () async{
              showLoaderDialog(context);
              final List<Map<String, dynamic>> updatedatalist = [];
              for (var student in studentList) {
                final studentId = student.studentId.toString();
                final remarks = remarksControllers[student.studentId.toString()]!;
                final remarksid = remarksidControllers[student.studentId.toString()]!;
                final remarkEntryMode = student.remarkEntryMode.toString();
                updatedatalist.add({
                  "student_id": studentId,
                  "remarks": remarks.text.isEmpty ? null : remarks.text,
                  "remark_id":remarksid.text.isEmpty ? null : remarksid.text,
                  "remark_entry_mode": remarkEntryMode.isNotEmpty ? remarkEntryMode : widget.remarkEntryMode,
                });
              }
              final Map<String, dynamic> bodydata = {
                'course_section_id': widget.courseId,       // example: '1@1'
                'exam_term_id': widget.examtermId,
                'updatedatalist': updatedatalist,
              };

              print(bodydata);
              final response =await StudentMarksManagerCommonHelper().storeStudentRemarks(bodydata);

              hideLoaderDialog(context);
              if(response['result']==1){
                getStudentList();
                showBottomMessage(context, response['message'], false);
              }else{
                showBottomMessage(context, response['message'], true);
              }
            }

        ),
      ),
    );
  }
}

Widget _buildInfoRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Expanded(
          flex: 2,
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
          flex: 2,

          child: Row(
            children: [
              Text(": "),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    "$value",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
