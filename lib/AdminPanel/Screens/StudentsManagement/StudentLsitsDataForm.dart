import 'dart:async';

import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Components/ShortByDropdown.dart';
import 'package:digivity_admin_app/Components/StudentSortBy.dart';
import 'package:digivity_admin_app/Components/StatusDropDown.dart';
import 'package:digivity_admin_app/Providers/StudentDataProvider.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class StudentListsDataForm extends StatefulWidget {
  const StudentListsDataForm({super.key});

  @override
  State<StudentListsDataForm> createState() => _StudentListsDataFormState();
}

class _StudentListsDataFormState extends State<StudentListsDataForm> {
  final _formKey = GlobalKey<FormState>();

  String? selectedCourseId;     // Required
  String? selectedSortBy;       // Required
  String? selectedStudentSort;  // Optional
  String? selectedStatus;       // Optional

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: "Search Student List",
            routeName: 'back'
        ),
      ),
      body: BackgroundWrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children :[
            CardContainer(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // COURSE SELECTOR
                    CourseComponent(
                      initialValue: '',
                      onChanged: (val) {
                        selectedCourseId = val;
                      },
                    ),
                    const SizedBox(height: 20),

                    // SORT FIELD
                    ShortByDropdown(
                      onChanged: (value) {
                        selectedSortBy = value;
                      },
                    ),

                    const SizedBox(height: 20),

                    // OPTIONAL: STUDENT-SPECIFIC SORTING
                    Studentsortby(
                      onChanged: (value) {
                        selectedStudentSort = value;
                      },
                    ),
                    const SizedBox(height: 20),

                    // OPTIONAL: STATUS FILTER
                    Statusdropdown(
                      onChange: (value) {
                        selectedStatus = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(25),
        child: CustomBlueButton(
          text: 'Search',
          icon: Icons.search,
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              showLoaderDialog(context);
              try {
                await Provider.of<StudentDataProvider>(context, listen: false)
                    .fetchStudents(
                  courseId: selectedCourseId!,
                  orderByMethod: selectedSortBy!,
                   sortByMethod: selectedStudentSort ?? 'sortBy',
                  selectedStatus: selectedStatus ?? 'active',
                );
              }catch(e){
                showBottomMessage(context, "${e}", true);
              }
              finally {
                hideLoaderDialog(context);
                context.pushNamed('student-search');
              }
            }
          },
        ),
      ),
    );
  }
}
