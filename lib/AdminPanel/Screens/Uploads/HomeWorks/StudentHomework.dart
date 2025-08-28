import 'package:digivity_admin_app/AdminPanel/Components/CommonBottomSheetForUploads.dart';
import 'package:digivity_admin_app/AdminPanel/Components/SearchBox.dart';
import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/HomeworkModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Assignments/AssignmentFilterBottomSheet.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/HomeWorks/HomeworkCard.dart';
import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/UploadsDocumentsHelpers/HomeWorkHelper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentHomework extends StatefulWidget {
  @override
  State<StudentHomework> createState() => _StudentHomeworkState();
}

class _StudentHomeworkState extends State<StudentHomework> {
  TextEditingController _searchHomework = TextEditingController();
  List<HomeworkModel> _homeworks = [];
  List<HomeworkModel> _filteredHomeworks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchHomeworks({});
    });// pass empty map initially
  }

  Future<void> _fetchHomeworks(Map<String, dynamic>? bodydata) async {
    setState(() => _isLoading = true);
    try {
      final helper = HomeWorkHelper();
      final data = await helper.getCreatedHomeworks(bodydata);
      setState(() {
        _homeworks = data;
        _filteredHomeworks = data;
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
        child: SimpleAppBar(titleText: 'Student Homework', routeName: 'back'),
      ),
      body: BackgroundWrapper(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              SearchBox(
                controller: _searchHomework,
                onChanged: (value) {
                  final query = value.toLowerCase();
                  setState(() {
                    _filteredHomeworks = _homeworks.where((hw) =>
                    (hw.hwTitle ?? '').toLowerCase().contains(query) ||
                        (hw.course ?? '').toLowerCase().contains(query) ||
                        (hw.subject ?? '').toLowerCase().contains(query)
                    ).toList();
                  });
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredHomeworks.isEmpty
                    ? const Center(child: Text('No homework found'))
                    : ListView.builder(
                  itemCount: _filteredHomeworks.length,
                  itemBuilder: (context, index) {
                    final hw = _filteredHomeworks[index];
                    return HomeworkCard(
                      homeworkId: hw.id,
                      course: hw.course ?? '',
                      subject: hw.subject ?? '',
                      hwDate: hw.hwDate ?? '',
                      hwTitle: hw.hwTitle ?? '',
                      homework: hw.homework ?? '',
                      submittedBy: hw.submittedBy ?? '',
                      submittedByProfile: hw.submittedByProfile ?? '',
                      attachments: hw.attachments.map((e) => {
                        'file_name': e.fileName,
                        'file_path': e.filePath,
                        'extension': e.extension,
                      }).toList(),
                      withapp: hw.withApp,
                      withEmail: hw.withEmail,
                      withtextSms: hw.withTextSms,
                      withWebsite: hw.withWebsite,
                      onDelete: () async {
                        final helper = HomeWorkHelper();
                        final response = await helper.deleteHomeWork(hw.id);
                        if (response['result'] == 1) {
                          await _fetchHomeworks({}); // refresh list
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
            await _fetchHomeworks(filterData);
            hideLoaderDialog(context);
          }
        },
        onAdd: () {
          context.pushNamed('add-homework');
        },
        addText: "Add Homework",
      ),
    );
  }
}
