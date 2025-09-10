import 'package:digivity_admin_app/AdminPanel/Models/ComplaintModel/ComplaintTypeModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/NotifyBySection.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:digivity_admin_app/Components/FieldSet.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Helpers/ComplaintHelper/StudentComplaintHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddStudentComplaint extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddStudentComplaint();
  }
}

class _AddStudentComplaint extends State<AddStudentComplaint> {
  List<ComplaintTypeModel>? complainttype = [];
  TextEditingController _complaint = TextEditingController();
  int? _complainttype;
  TextEditingController _complaintdate = TextEditingController();
  final _fromkey = GlobalKey<FormState>();
  final GlobalKey<NotifyBySectionState> notifyKey =
      GlobalKey<NotifyBySectionState>();

  String? courseId;
  int? complaintTo; // student being complained about
  List<StudentModel> studentList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getComplaintType();
    });
  }

  Future<void> _getComplaintType() async {
    showLoaderDialog(context);
    try {
      final response = await StudentComplaintHelper().getComplaintType();
      complainttype = response;
      setState(() {});
    } catch (e) {
      print(e);
      showBottomMessage(context, "$e", true);
    } finally {
      hideLoaderDialog(context);
    }
  }

  void _resetForm() {
    _fromkey.currentState?.reset();
    _complaint.clear();
    _complaintdate.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _complainttype = null;
    complaintTo = null;
    courseId = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: "Add Student Complaint",
          routeName: "back",
        ),
      ),
      body: BackgroundWrapper(
        child: SingleChildScrollView(
          child: CardContainer(
            child: FieldSet(
              title: "Student Complaint Information",
              child: Form(
                key: _fromkey,
                child: Column(
                  children: [
                    CourseComponent(
                      isSubject: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Select First Course";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        courseId = value;
                        setState(() {});
                      },
                      forData: "students",
                      onStudentListChanged: (List<StudentModel> students) {
                        setState(() {
                          studentList = students;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomDropdown(
                      selectedValue: _complainttype,
                      validator: (value) {
                        if (value == null) {
                          return "Please Select Complaint Type First";
                        }
                        return null;
                      },
                      items: complainttype!.map((e) {
                        return {
                          "key": e.complaintType,
                          "value": e.complaintTypeId,
                        };
                      }).toList(),
                      displayKey: "key",
                      valueKey: "value",
                      onChanged: (value) {
                        _complainttype = value;
                      },
                      hint: "Select Complaint Type",
                    ),
                    const SizedBox(height: 20),
                    CustomDropdown(
                      items: [
                        {"id": 0, "value": "Please select complaint to"},
                        ...studentList.map((e) {
                          return {
                            "id": e.studentId,
                            "value":
                                "${e.admissionNo} | ${e.studentName} | ${e.course}",
                          };
                        }).toList(),
                      ],
                      validator: (value) {
                        if (value == null || value == 0) {
                          return "Please Select Complaint To First";
                        }
                        return null;
                      },
                      displayKey: "value",
                      valueKey: "id",
                      onChanged: (value) {
                        complaintTo = value;
                        setState(() {});
                      },
                      hint: "Select Complaint To",
                    ),
                    const SizedBox(height: 20),
                    DatePickerField(
                      label: "Complaint Date",
                      controller: _complaintdate,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Select Complaint Date First";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Complaint",
                      hintText: "Enter Complaint",
                      controller: _complaint,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Complaint Description";
                        }
                        return null;
                      },
                      maxline: 4,
                    ),
                    const SizedBox(height: 20),
                    NotifyBySection(key: notifyKey),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: CustomBlueButton(
          text: "Add Complaint",
          icon: Icons.save,
          onPressed: () async {
            if (_fromkey.currentState!.validate()) {
              showLoaderDialog(context);
              try {
                final complaintby = await SharedPrefHelper.getPreferenceValue(
                  'staff_id',
                );

                final notifyData =
                    notifyKey.currentState?.getSelectedNotifyValues() ?? {};

                final formdata = {
                  "complaint_for": "student",
                  "complaint_type_id": _complainttype.toString(),
                  "complaint": _complaint.text,
                  "complaint_date": _complaintdate.text,
                  "complaint_by":
                      complaintby?.toString() ?? "0", // logged-in user
                  "complaint_to": complaintTo ?? 0, // student selected
                  "status": "yes",
                  "course_id": courseId.toString(),
                  ...notifyData,
                };

                final response = await StudentComplaintHelper()
                    .storeStudentComplaint(formdata);

                if (response['result'] == 1) {
                  _resetForm();
                  showBottomMessage(context, response['message'], false);
                } else {
                  showBottomMessage(context, response['message'], true);
                }
              } catch (e) {
                print(e);
                showBottomMessage(context, "$e", true);
              } finally {
                hideLoaderDialog(context);
              }
            }
          },
        ),
      ),
    );
  }
}
