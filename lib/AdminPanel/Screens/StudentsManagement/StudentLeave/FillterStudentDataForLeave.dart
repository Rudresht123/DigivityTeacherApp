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
import 'package:digivity_admin_app/Helpers/formatDate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
        child: Column(
          children: [
            Form(
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
                              return null;
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
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                  "start_date": formatDate(
                    date: DateFormat("dd-MM-yyyy").parse(_from_date.text),
                    format: "yyyy-MM-dd",
                  ),
                  "end_date": formatDate(
                    date: DateFormat("dd-MM-yyyy").parse(_to_date.text),
                    format: "yyyy-MM-dd",
                  ),
                };
                hideLoaderDialog(context);
                context.pushNamed("student-leave-record", extra: filterdata);
              } catch (e) {
                print("${e}");
                if (mounted) {
                  showBottomMessage(context, "$e", true);
                }
              }
            }
          },
        ),
      ),
    );
  }
}
