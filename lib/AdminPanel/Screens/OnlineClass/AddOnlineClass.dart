import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/SubjectModel.dart';
import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/FieldSet.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Components/StaffDropdown.dart';
import 'package:digivity_admin_app/Helpers/OnlineClassHelpers/OnlineClassHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddOnlineClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddOnlineClass();
  }
}

class _AddOnlineClass extends State<AddOnlineClass> {
  final _formkey = GlobalKey<FormState>();
  String? courseId;
  int? _selectedSubjectId;
  List<SubjectModel> subjectList = [];
  TextEditingController _classTimingController = TextEditingController();
  TextEditingController _classLinkController = TextEditingController();
  TextEditingController _classPeriodTimeController = TextEditingController();
  String? selectedStaff;

  void _resetForm() {
    setState(() {
      // Reset controllers
      _classTimingController.clear();
      _classLinkController.clear();
      _classPeriodTimeController.clear();

      // Reset dropdown/selected values
      _selectedSubjectId = null;
      selectedStaff = "";

      // Reset courseId if needed
      courseId = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: "Schedule Online Class Subject",
          routeName: "back",
        ),
      ),
      body: BackgroundWrapper(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CardContainer(
                child: FieldSet(
                  title: "Online Class Information",
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        CourseComponent(
                          isSubject: true,
                          forData: "subjects",
                          initialValue: courseId,
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
                          onSubjectListChanged: (List<SubjectModel> subjects) {
                            setState(() {
                              subjectList = subjects;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomDropdown(
                          items: subjectList,
                          selectedValue: _selectedSubjectId,
                          displayKey: 'subject',
                          valueKey: 'id',
                          hint: 'Subject',
                          onChanged: (value) {
                            _selectedSubjectId = value;
                            setState(() {});
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Select First Subject";
                            }
                            return null;
                          },
                          itemMapper: (item) => {
                            'id': item.id,
                            'subject': item.subject,
                          },
                        ),

                        SizedBox(height: 15),
                        StaffDropdown(
                          label: "Teacher (Host)",
                          onChange: (value) {
                            selectedStaff = value;
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 15),
                        CustomTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter The Class Timing Here";
                            }
                            return null;
                          },
                          label: "Class Timing",
                          hintText: "Enter Class Timing (8:30 AM To 10:30 AM)",
                          controller: _classTimingController,
                        ),
                        SizedBox(height: 15),
                        CustomTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter The Class Link Here";
                            }
                            return null;
                          },
                          label: "Class Links",
                          hintText: "Enter Class Links (google meet)",
                          controller: _classLinkController,
                        ),
                        SizedBox(height: 15),
                        CustomTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter The Period Time Here";
                            }
                            return null;
                          },
                          label: "Period Time",
                          hintText: "Enter Period Time (In min.)",
                          controller: _classPeriodTimeController,
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: CustomBlueButton(
          text: "Add Online Class",
          icon: Icons.save,
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              showLoaderDialog(context);
              final formdata = {
                "course_section_id": courseId,
                "subject_id": _selectedSubjectId,
                "staff_id": selectedStaff,
                "online_class_timings": _classTimingController.text,
                "online_class_links": _classLinkController.text,
                "period_time": _classPeriodTimeController.text,
              };
              try {
                final response = await OnlineClassHelper().createOnlineClass(
                  formdata!,
                );
                if (response['result'] == 1) {
                  _resetForm();
                  showBottomMessage(context, "${response['message']}", false);
                } else {
                  showBottomMessage(context, "${response['message']}", false);
                }
              } catch (e) {
                showBottomMessage(context, "${e}", false);
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
