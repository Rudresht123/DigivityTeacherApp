import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/DateChangeComponent.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentBirthdayList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StudentBirthdayListState();
  }
}

class _StudentBirthdayListState extends State<StudentBirthdayList> {

   String?  selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: "Today Students Birthday List",
          routeName: "back",
        ),
      ),
      body: BackgroundWrapper(
        child: SingleChildScrollView(
          child: CardContainer(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                /// Grade/Class dropdown (your existing CourseComponent)
                CourseComponent(),

                const SizedBox(height: 20),

                /// Date navigation
                DateChangeComonent(selectedDate:selectedDate,onTap:(){

                }),

                const SizedBox(height: 20),
                Divider(),

                /// Record not found message
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Center(
                    child: Text(
                      "Record Not Found !!",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
