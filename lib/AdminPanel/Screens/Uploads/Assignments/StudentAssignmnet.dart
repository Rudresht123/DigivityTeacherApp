import 'package:digivity_admin_app/AdminPanel/Components/CommonBottomSheetForUploads.dart';
import 'package:digivity_admin_app/AdminPanel/Components/SearchBox.dart';
import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/AssignmentModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Assignments/AssignmentCard.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Assignments/AssignmentFilterBottomSheet.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Syllabus/SyllabusCard.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/UploadsDocumentsHelpers/AssignmentHelper.dart';
import 'package:digivity_admin_app/helpers/UploadsDocumentsHelpers/SyllabusHelper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentAssignmnet extends StatefulWidget {
  @override
  State<StudentAssignmnet> createState() => _StudentAssignmnet();
}

class _StudentAssignmnet extends State<StudentAssignmnet> {
  TextEditingController _searchassignment = TextEditingController();
  List<AssignmentModel> _assignments = [];
  List<AssignmentModel> _filteredassignments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSyllabus({});
  }

  Future<void> _fetchSyllabus(Map<String, dynamic>? bodydata) async {
    setState(() => _isLoading = true);
    try {
      final helper = Assignmenthelper();
      final data = await helper.getCreatedAssignments(bodydata);
      setState(() {
        _assignments = data;
        _filteredassignments = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching homeworks: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: 'Student Assignments', routeName: 'back'),
      ),
      body: BackgroundWrapper(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              SearchBox(
                controller: _searchassignment,
                onChanged: (value) {
                  final query = value.toLowerCase();
                  setState(() {
                    _filteredassignments = _assignments.where((assign) =>
                        (assign.subject ?? '').toLowerCase().contains(query) ||
                        (assign.assignmentTitle ?? '').toLowerCase().contains(query) ||
                        (assign.assignment ?? '').toLowerCase().contains(query)

                    ).toList();
                  });
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredassignments.isEmpty
                    ? const Center(child: Text('No homework found'))
                    : ListView.builder(
                  itemCount: _filteredassignments.length,
                  itemBuilder: (context, index) {
                    final assign = _filteredassignments[index];
                    return Assignmentcard(
                      assignmentId: assign.assignmentId,
                      course: assign.course ?? '',
                      assigmetSubmissionDate:assign.submittedDate ?? '',
                      assignmentDate:assign.assignmentDate,
                      subject: assign.subject ?? '',
                      assignmentTitle: assign.assignmentTitle ?? '',
                      assignmentDetail: assign.assignment ?? '',
                      submittedBy: assign.submittedBy ?? '',
                      submittedByProfile: assign.submittedByProfile ?? '',
                      attachments: assign.attachment,
                      withapp: assign.withApp,
                      withWebsite: assign.withWebsite,
                      withEmail:assign.withEmail,
                      withtextSms:assign.withTextSms,

                      onDelete: () async {
                        final helper = Assignmenthelper();
                        final response = await helper.deleteAssignment(assign.assignmentId); // delete from backend
                        if (response['result'] == 1) {
                          await _fetchSyllabus({}); // refresh list
                        }
                        return response;
                      },
                    );

                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CommonBottomSheetForUploads(
        onFilter: () async {
          final filterData = await showModalBottomSheet<Map<String, dynamic>>(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => AssignmentFilterBottomSheet(),
          );

          if (filterData != null) {
            showLoaderDialog(context);
            await _fetchSyllabus(filterData);
            hideLoaderDialog(context);
          }
        },
        onAdd: () {
          context.pushNamed('add-assignment');
        },
        addText: "Add Assignment",
      ),
    );
  }
}
