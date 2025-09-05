import 'package:digivity_admin_app/AdminPanel/Models/ComplaintModel/ComplaintTypeModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/AddStudentModel.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  int? complaintTo;
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
      print("${e}");
      showBottomMessage(context, "${e}", true);
    } finally {
      hideLoaderDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
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
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
                    CustomDropdown(
                      items: studentList.map((e) {
                        return {"id": e.studentId, "value": e.studentName};
                      }).toList(),
                      displayKey: "value",
                      valueKey: "id",
                      onChanged: (value) {},
                      hint: "Select Complaint By",
                    ),
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
                    CustomTextField(
                      label: "Complaint",
                      hintText: "Enter Complaint",
                      controller: _complaint,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Complaint First Description";
                        }
                        return null;
                      },
                      maxline: 4,
                    ),
                    SizedBox(height: 20),
                    NotifyBySection(key: notifyKey),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: CustomBlueButton(
          text: "Add Complaint",
          icon: Icons.save,
          onPressed: () async {
            if (_fromkey.currentState!.validate()) {
              // showLoaderDialog(context);
              try {
                final complaintby = await SharedPrefHelper.getPreferenceValue(
                  'user_id',
                );
                final notifyData =
                    notifyKey.currentState?.getSelectedNotifyValues() ?? {};
                final formdata = {
                  "complaint_for": "student",
                  "complaint_type_id": _complainttype.toString(),
                  "complaint": _complaint.text,
                  "complaint_date": _complaintdate.text,
                  "complaint_by": complaintby.toString() ?? "0",
                  "status": "yes",
                  ...notifyData,
                };

                print(formdata);

                //
                final response = await StudentComplaintHelper()
                    .storeStudentComplaint(formdata);
                //
                // if (response['result'] == 1) {
                //   showBottomMessage(context, response['message'], false);
                // } else {
                //   showBottomMessage(context, response['message'], true);
                // }
              } catch (e) {
                print("${e}");
                showBottomMessage(context, "${e}", true);
              } finally {
                // hideLoaderDialog(context);
              }
            }
          },
        ),
      ),
    );
  }
}
