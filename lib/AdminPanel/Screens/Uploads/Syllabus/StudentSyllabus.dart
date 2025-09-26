import 'package:digivity_admin_app/AdminPanel/Components/CommonBottomSheetForUploads.dart';
import 'package:digivity_admin_app/AdminPanel/Components/SearchBox.dart';
import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/SyllabusModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Assignments/AssignmentFilterBottomSheet.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Syllabus/SyllabusCard.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/Syllabus/SyllabusFilterBottomSheet.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/UploadsDocumentsHelpers/SyllabusHelper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Studentsyllabus extends StatefulWidget {
  @override
  State<Studentsyllabus> createState() => _Studentsyllabus();
}

class _Studentsyllabus extends State<Studentsyllabus> {
  TextEditingController _searchSyllabus = TextEditingController();
  List<SyllabusModel> _syllabuss = [];
  List<SyllabusModel> _filteredSyllabus = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSyllabus({});
    });
  }

  Future<void> _fetchSyllabus(Map<String, dynamic>? bodydata) async {
    setState(() => _isLoading = true);
    try {
      final helper = SyllabusHelper();
      final data = await helper.getCreatedSyllabuss(bodydata);
      print(data);
      setState(() {
        _syllabuss = data;
        _filteredSyllabus = data;
      });
    } catch (e) {
      print('Error fetching Student Syllabus: $e');
      showBottomMessage(context, "${e}", true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: 'Student Syllabus', routeName: 'back'),
      ),
      body: BackgroundWrapper(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              SearchBox(
                controller: _searchSyllabus,
                onChanged: (value) {
                  final query = value.toLowerCase();
                  setState(() {
                    _filteredSyllabus = _syllabuss
                        .where(
                          (sy) =>
                              (sy.subject ?? '').toLowerCase().contains(
                                query,
                              ) ||
                              (sy.syllabusTitle ?? '').toLowerCase().contains(
                                query,
                              ) ||
                              (sy.syllabusDetail ?? '').toLowerCase().contains(
                                query,
                              ),
                        )
                        .toList();
                  });
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredSyllabus.isEmpty
                    ? const Center(child: Text('No homework found'))
                    : ListView.builder(
                        itemCount: _filteredSyllabus.length,
                        itemBuilder: (context, index) {
                          final sy = _filteredSyllabus[index];
                          return Syllabuscard(
                            syllabusId: sy.syllabusId,
                            course: sy.course ?? '',
                            subject: sy.subject ?? '',
                            syllabusTitle: sy.syllabusTitle ?? '',
                            syllabusDetail: sy.syllabusDetail ?? '',
                            submittedBy: sy.submittedBy ?? '',
                            submittedByProfile: sy.submittedByProfile ?? '',
                            attachments: sy.attachment,
                            withapp: sy.withApp,
                            withWebsite: sy.withWebsite,

                            // 👇 This function gets passed into the bottom sheet
                            onDelete: () async {
                              final helper = SyllabusHelper();
                              final response = await helper.deleteSyllabus(
                                sy.syllabusId,
                              ); // delete from backend

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
            builder: (_) => SyllabusFilterBottomSheet(),
          );
          if (filterData != null) {
            showLoaderDialog(context);
            try {
              await _fetchSyllabus(filterData);
            } catch (e) {
              showBottomMessage(context, "${e}", true);
            } finally {
              hideLoaderDialog(context);
            }
          }
        },

        onAdd: () {
          context.pushNamed('add-syllabus');
        },
        addText: "Add Syllabus",
      ),
    );
  }
}
