import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:digivity_admin_app/Components/FieldSet.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FillterStudentDataForLeave extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FillterStudentDataForLeave();
  }
}

class _FillterStudentDataForLeave extends State<FillterStudentDataForLeave> {
  final _formkey = GlobalKey<FormState>();
  String? courseId;
  TextEditingController _from_date = TextEditingController();
  TextEditingController _to_date = TextEditingController();
  String? status;
  final statuslist = [
    {"value": "all", "key": "All"},
    {"value": "pending", "key": "Pending"},
    {"value": "approve", "key": "Approve"},
    {"value": "reject", "key": "Reject"},
    {"value": "cancel", "key": "Cancel"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: "Student Applied Leave",
          routeName: "back",
        ),
      ),
      body: BackgroundWrapper(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CardContainer(
                child: FieldSet(
                  title: 'Filter Student',
                  child: Column(
                    children: [
                      CourseComponent(
                        onChanged: (value) {
                          courseId = value;
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Select Course First";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      DatePickerField(
                        label: "From Date",
                        controller: _from_date,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Select The Leave From Date";
                          }
                        },
                      ),
                      SizedBox(height: 15),
                      DatePickerField(
                        controller: _to_date,
                        label: "To Date",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Select The Leave To Date";
                          }
                        },
                      ),

                      SizedBox(height: 15),
                      CustomDropdown(
                        items: statuslist,
                        displayKey: "key",
                        valueKey: "value",
                        onChanged: (value) {
                          status = value;
                          setState(() {});
                        },
                        hint: "Please Select Status",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: CustomBlueButton(
          text: "Filter Student",
          icon: Icons.filter,
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              showLoaderDialog(context);
              try {
                final filterdata = {
                  "leave_to": "student",
                  "course": courseId.toString(),
                  "from_date": _from_date.text,
                  "to_date": _to_date.text,
                  "status": status,
                };
                hideLoaderDialog(context);
                print(filterdata);
                context.pushNamed("student-leave-record", extra: filterdata);
              } catch (e) {
                print("${e}");
                showBottomMessage(context, "${e}", true);
              }
            }
          },
        ),
      ),
    );
  }
}
