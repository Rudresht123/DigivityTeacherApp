import 'dart:io';
import 'package:digivity_admin_app/AdminPanel/Components/CustomPickerBottomSheetForUploads.dart';
import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/SubjectModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/AddStaffModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/DesignationModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/DynamicUrlInputList.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FilePickerBox.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/IsSubmission.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/NotifyBySection.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/AssignmentTypes.dart';
import 'package:digivity_admin_app/ApisController/AddStaffFormData.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/FilePickerHelper.dart';
import 'package:digivity_admin_app/helpers/PickAndResizeImage.dart';
import 'package:digivity_admin_app/helpers/UploadHomeWorksEtc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Addassignment extends StatefulWidget {
  const Addassignment({super.key});

  @override
  State<Addassignment> createState() {
    return _Addassignment();
  }
}

class _Addassignment extends State<Addassignment> {
  AssignmentType _selectedType = AssignmentType.student;
  AddStaffModel? staffformdata;
  final _formkye = GlobalKey<FormState>();
  final GlobalKey<NotifyBySectionState> notifyKey =
      GlobalKey<NotifyBySectionState>();
  final GlobalKey<DynamicUrlInputListState> urlKey =
      GlobalKey<DynamicUrlInputListState>();
  bool isSubmissionEnabled = false;
  TextEditingController _assingmentTitle = TextEditingController();
  TextEditingController _assignmentDescriptionController =
      TextEditingController();
  TextEditingController _hw_date = TextEditingController();
  TextEditingController _to_date = TextEditingController();
  TextEditingController _assignmentMaxMarks = TextEditingController();
  TextEditingController _submissionDateController = TextEditingController();
  TextEditingController _submissionTimeController = TextEditingController();

  String? courseId;
  int? _selectedSubjectId;
  List<SubjectModel> subjectList = [];
  List<File> selectedFiles = [];

  @override
  void initState() {
    super.initState();
    _assignmentMaxMarks.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: 'Upload Assignment', routeName: 'back'),
      ),
      body: BackgroundWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formkye,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AssignmentTypeSelector(
                  selectedType: _selectedType,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedType = value;
                      });
                    }
                  },
                ),
                SizedBox(height: 16),
                CourseComponent(
                  isSubject: true,
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
                  onSubjectListChanged: (List<SubjectModel> subjects) {
                    setState(() {
                      subjectList = subjects;
                    });
                  },
                ),

                const SizedBox(height: 16),
                CustomDropdown(
                  items: subjectList,
                  displayKey: 'subject',
                  valueKey: 'id',
                  hint: 'Subject',
                  onChanged: (value) {
                    _selectedSubjectId = value;
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Please Select Subject First";
                    }
                    return null;
                  },
                  itemMapper: (item) => {
                    'id': item.id,
                    'subject': item.subject,
                  },
                ),

                const SizedBox(height: 16),
                DatePickerField(label: 'From Date', controller: _hw_date),
                const SizedBox(height: 16),
                DatePickerField(label: 'To Date', controller: _to_date),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Assignment Title',
                  hintText: 'Enter Assignment Title..',
                  controller: _assingmentTitle,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Assignment Title First";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                CustomTextField(
                  maxline: 4,
                  label: 'Assignment Description',
                  hintText: 'Enter Assignment Description..',
                  controller: _assignmentDescriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Assignment Description First";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Upload card
                CustomTextField(
                  label: 'Max Marks',
                  hintText: 'Enter Assignment Max Marks..',
                  controller: _assignmentMaxMarks,
                ),
                const SizedBox(height: 24),

                IsSubmission(
                  submissionDateController: _submissionDateController,
                  submissionTimeController: _submissionTimeController,
                ),

                const SizedBox(height: 24),
                FilePickerBox(
                  onTaped: () {
                    showDocumentPickerBottomSheet(
                      context: context,
                      title: "Upload File",
                      onCameraTap: () =>
                          FilePickerHelper.pickFromCamera((file) {
                            setState(() {
                              selectedFiles.add(file);
                            });
                          }),
                      onGalleryTap: () =>
                          FilePickerHelper.pickFromGallery((file) {
                            setState(() {
                              selectedFiles.add(file);
                            });
                          }),
                      onPickDocument: () =>
                          FilePickerHelper.pickDocuments((files) {
                            setState(() {
                              selectedFiles.addAll(files);
                            });
                          }),
                    );
                  },
                  selectedFiles: selectedFiles,
                  onRemoveFile: (index) {
                    setState(() {
                      selectedFiles.removeAt(index);
                    });
                  },
                ),

                const SizedBox(height: 20),
                NotifyBySection(key: notifyKey),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: CustomBlueButton(
          width: double.infinity,
          text: 'Save',
          icon: Icons.save,
          onPressed: () async {
            if (_formkye.currentState!.validate()) {
              showLoaderDialog(context);
              try {
                final notifyData =
                    notifyKey.currentState?.getSelectedNotifyValues() ?? {};
                final datainsert = {
                  'type': _selectedType.name,
                  'course_id': courseId,
                  'subject_id': _selectedSubjectId,
                  'assignment_title': _assingmentTitle.text,
                  'assignment': _assignmentDescriptionController.text,
                  'assignment_date': _hw_date.text,
                  'submitted_date': _to_date.text,
                  'status': 'yes',
                  ...notifyData,
                };

                final response = await UploadHomeWorksEtc().uploadData(
                  'assignment',
                  datainsert,
                  selectedFiles,
                );
                if (response['result'] == 1) {
                  resetForm();
                  showBottomMessage(context, response['message'], false);
                } else {
                  showBottomMessage(context, response['message'], true);
                }
              } catch (e) {
                print("Bug Occured During The Upload Assignment ${e}");
                showBottomMessage(context, "${e}", true);
              } finally {
                hideLoaderDialog(context);
              }
            }
          },
        ),
      ),
    );
  }

  Future<void> resetForm() async {
    setState(() {
      courseId = null;
      _selectedSubjectId = null;
      _assingmentTitle.clear();
      _assignmentDescriptionController.clear();
      selectedFiles.clear();
      _assignmentMaxMarks.clear();
      _hw_date.clear();
      _to_date.clear();
      isSubmissionEnabled = false;
      _selectedType = AssignmentType.student;
    });
    // Reset the Notify Section
    notifyKey.currentState?.resetNotifySelection();
  }
}
