import 'dart:async';

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
import 'package:digivity_admin_app/helpers/StudentsData.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SearchStudentListForRollNum extends StatefulWidget {
  const SearchStudentListForRollNum({super.key});

  @override
  State<SearchStudentListForRollNum> createState() => _SearchStudentListForRollNum();
}

class _SearchStudentListForRollNum extends State<SearchStudentListForRollNum> {
  String? selectedCourseId;
  String? selectedSortBy;
  String? selectedStudentSort;
  String? selectedStatus;





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: "Student Roll Number Updation",
          routeName: 'back',
        ),
      ),
      body: BackgroundWrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CardContainer(
              height: 450,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // COURSE SELECTOR
                    CourseComponent(
                      initialValue: '',
                      validator: (value) {
                        if (value == null) {
                          return "Please Select Course";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        selectedCourseId=val;
                        setState(() {

                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // SORT FIELD (like admission_no, name, etc.)
                    ShortByDropdown(
                      onChanged: (value) {
                        setState(() {
                          selectedSortBy = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // OPTIONAL: STUDENT-SPECIFIC SORTING
                    Studentsortby(
                      onChanged: (value) {
                        setState(() {
                          selectedStudentSort = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // OPTIONAL: STATUS FILTER
                    Statusdropdown(
                      onChange: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(25),
        child: CustomBlueButton(
          text: 'Search',
          icon: Icons.search,
          onPressed: () async {
            showLoaderDialog(context);
            if (selectedCourseId != null && selectedSortBy != null) {
              context.pushNamed(
                'student-roll-num-update',
                extra:{'course_id':selectedCourseId.toString(),'selectedSortBy':selectedSortBy.toString(),'orderByMethod':selectedStudentSort.toString(),'selectedStatus':selectedStatus.toString()},
              );

            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please select Course and Sort By"),
                ),
              );
            }

            hideLoaderDialog(context);
          },

        ),
      ),
    );
  }
}
