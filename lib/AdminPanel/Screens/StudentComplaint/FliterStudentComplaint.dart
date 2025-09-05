import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilterStudentComplaint extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FilterStudentComplaint();
  }
}

class _FilterStudentComplaint extends State<FilterStudentComplaint> {
  final _formkey = GlobalKey<FormState>();
  String? courseid;
  TextEditingController _from_date = TextEditingController();
  TextEditingController _to_date = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: "Search Complaint", routeName: "back"),
      ),
      body: BackgroundWrapper(
        child: Column(
          children: [
            CardContainer(
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    CourseComponent(
                      onChanged: (value) {
                        courseid = value;
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Please Select Course First";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    DatePickerField(
                      controller: _from_date,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Select From Date First";
                        }
                        return null;
                      },
                      label: "From Date [ dd-mm-yy ]",
                    ),
                    SizedBox(height: 15),
                    DatePickerField(
                      controller: _to_date,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Select To Date First";
                        }
                        return null;
                      },
                      label: "To Date [ dd-mm-yy ]",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: CustomBlueButton(
          text: "Filter Complaint",
          icon: Icons.search,
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              try {
                final formdata = {
                  "course_id": courseid,
                  "from_date": _from_date.text,
                  "to_date": _to_date.text,
                  "complaint_for": "student",
                };
                context.pushNamed("student-raised-complaint", extra: formdata);
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
