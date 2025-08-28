
import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/ExamRemarkListModel.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:flutter/material.dart';

class StudentRemakEntryCard extends StatefulWidget {
  final String admissionNo;
  final String studentName;
  final String fatherName;
  final String remarkEntryMode;
  final String profileImg;
  final String? entrymode;
  final TextEditingController remarksController;
  final TextEditingController remarksidController;
  final List<ExamRemarkList>? remarkList;

  const StudentRemakEntryCard({
    super.key,
    required this.admissionNo,
    required this.studentName,
    required this.fatherName,
    required this.profileImg,
    required this.remarksController,
    required this.remarkEntryMode,
    required this.entrymode,
    this.remarkList,
    required this.remarksidController
  });

  @override
  State<StudentRemakEntryCard> createState() => _StudentRemakEntryCardState();
}

class _StudentRemakEntryCardState extends State<StudentRemakEntryCard> {
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile
        Row(
          children: [
            PopupNetworkImage(imageUrl: widget.profileImg),

            const SizedBox(width: 5),

            // Info
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Adm No.: ${widget.admissionNo}",
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    widget.studentName,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "D/O : ${widget.fatherName}",
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
          Divider(),
          SizedBox(height: 15,),
         Container(
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(15),
             color: Colors.white,
           ),
           child: widget.remarkEntryMode.isNotEmpty && widget.remarkEntryMode == 'typing' || widget.entrymode=='typing' ? CustomTextField(
               maxline: 2,
               label: 'Remarks', hintText: 'Enter Remark Here..', controller: widget.remarksController)
           : CustomDropdown(
             label: 'Remark',
             selectedValue: widget.remarksidController.text.isNotEmpty
                 ? widget.remarksidController.text
                 : null,
             items: widget.remarkList!.isNotEmpty
                 ? widget.remarkList!.map((e) => {'id': e.Id.toString(), 'value': e.examremark}).toList()
                 : [],
             displayKey: 'value',
             valueKey: 'id',
             onChanged: (value) {
               setState(() {
                 widget.remarksidController.text = value.toString(); // Store selected ID

                 // Find the selected remark text from remarkList using the selected ID
                 final selectedRemark = widget.remarkList!
                     .firstWhere((element) => element.Id.toString() == value.toString())
                     .examremark;

                 widget.remarksController.text = selectedRemark; // Store selected remark text
               });
             },
             hint: 'Select a Option',
           ),
         )
],
      ),
    );
  }
}
