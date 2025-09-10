import 'dart:io';
import 'package:digivity_admin_app/AdminPanel/Components/CustomPickerBottomSheetForUploads.dart';
import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/SubjectModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/DynamicUrlInputList.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FilePickerBox.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/IsSubmission.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/NotifyBySection.dart';
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
import 'package:intl/intl.dart';

class AddHomeworkPage extends StatefulWidget {
  const AddHomeworkPage({super.key});

  @override
  State<AddHomeworkPage> createState() {
    return _AddHomeworkPage();
  }
}

class _AddHomeworkPage extends State<AddHomeworkPage> {
  final _formkye = GlobalKey<FormState>();
  final GlobalKey<NotifyBySectionState> notifyKey =
      GlobalKey<NotifyBySectionState>();
  final GlobalKey<DynamicUrlInputListState> urlKey =
      GlobalKey<DynamicUrlInputListState>();

  bool isSubmissionEnabled = false;
  TextEditingController _submissionDate = TextEditingController();
  TextEditingController _submissionTime = TextEditingController();
  TextEditingController _homeworkController = TextEditingController();
  TextEditingController _homeworkDescriptionController =
      TextEditingController();
  TextEditingController _hw_date = TextEditingController();
  TextEditingController _to_date = TextEditingController();
  String? courseId;
  int? _selectedSubjectId;
  List<SubjectModel> subjectList = [];
  List<File> selectedFiles = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: 'Upload Homework', routeName: 'back'),
      ),
      body: BackgroundWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formkye,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CourseComponent(
                  isSubject: true,
                  forData: "subjects",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Select First Course";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    courseId = value;
                    setState(() {});
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
                    setState(() {});
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Select First Subject";
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
                  label: 'Homework Title',
                  hintText: 'Enter Homework Title..',
                  controller: _homeworkController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter The Homework Title First";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  maxline: 4,
                  label: 'Homework Description',
                  hintText: 'Enter Description..',
                  controller: _homeworkDescriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter The Homework Description First";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Upload card
                IsSubmission(
                  submissionDateController: _submissionDate,
                  submissionTimeController: _submissionTime,
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
                final urlLinks = urlKey.currentState?.getUrlLinks() ?? '';
                final datainsert = {
                  'course_id': courseId,
                  'subject_id': _selectedSubjectId,
                  'hw_date': _hw_date.text,
                  'submission_date': _submissionDate.text,
                  'submission_time': _submissionTime.text,
                  'to_date': _to_date.text,
                  'hw_title': _homeworkController.text,
                  'homework': _homeworkDescriptionController.text,
                  'status': 'yes',
                  ...notifyData,
                };

                final response = await UploadHomeWorksEtc().uploadData(
                  'homework',
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
                print("Bug Occured During The Save Homework ${e}");
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
      _hw_date.clear();
      _submissionDate.clear();
      _submissionTime.text = DateFormat.jm().format(DateTime.now());
      _to_date.clear();
      _homeworkController.clear();
      _homeworkDescriptionController.clear();
      selectedFiles.clear();
    });

    // Reset the Notify Section
    notifyKey.currentState?.resetNotifySelection();
  }
}
