import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/SubjectModel.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:flutter/material.dart';

class SchoolNewsFillterBottomSheet extends StatefulWidget {
  @override
  State<SchoolNewsFillterBottomSheet> createState() =>
      _SchoolNewsFillterBottomSheet();
}

class _SchoolNewsFillterBottomSheet
    extends State<SchoolNewsFillterBottomSheet> {
  final TextEditingController _fromDate = TextEditingController();
  final TextEditingController _toDate = TextEditingController();
  String? selectedCourse;
  List<SubjectModel> subjectList = [];
  int? _selectedSubjectId;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.50,
      maxChildSize: 0.80,
      minChildSize: 0.5,
      builder: (_, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              Center(
                child: Chip(
                  label: Text('Filter Data'),
                  backgroundColor: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              DatePickerField(label: 'From Date', controller: _fromDate),
              const SizedBox(height: 20),
              DatePickerField(label: 'To Date', controller: _toDate),
              const SizedBox(height: 20),
              CustomBlueButton(
                width: double.infinity,
                text: 'Search',
                icon: Icons.search,
                onPressed: () {
                  final filterData = {
                    'news_from_date': _fromDate.text,
                    'news_to_date': _toDate.text,
                  };
                  Navigator.of(context).pop(filterData);
                },
              ),
              // Add filter fields here...
            ],
          ),
        );
      },
    );
  }
}
