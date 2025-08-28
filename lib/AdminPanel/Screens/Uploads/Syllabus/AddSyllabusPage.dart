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

class AddSyllabusPage extends StatefulWidget {
  const AddSyllabusPage({super.key});

  @override
  State<AddSyllabusPage> createState() {
    return _AddSyllabusPage();
  }
}

class _AddSyllabusPage extends State<AddSyllabusPage> {
  final _formkye = GlobalKey<FormState>();
  final GlobalKey<NotifyBySectionState> notifyKey =
      GlobalKey<NotifyBySectionState>();
  final GlobalKey<DynamicUrlInputListState> urlKey =
      GlobalKey<DynamicUrlInputListState>();

  bool isSubmissionEnabled = false;
  TextEditingController _referenceController = TextEditingController();
  TextEditingController _syllabusPripority = TextEditingController();
  TextEditingController _syllabusTitleController = TextEditingController();
  TextEditingController _syllabusDescriptionController =
      TextEditingController();
  String? courseId;
  int? _selectedSubjectId;
  List<SubjectModel> subjectList = [];
  List<File> selectedFiles = [];

  @override
  void initState() {
    super.initState();
    _syllabusPripority.text = '1';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: 'Upload Syllabus', routeName: 'back'),
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
                  onChanged: (value) {
                    courseId = value;
                    setState(() {});
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Select The Course First";
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
                      return "Please Select The Subject First";
                    }
                    return null;
                  },
                  itemMapper: (item) => {
                    'id': item.id,
                    'subject': item.subject,
                  },
                ),

                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Syllabus Priority',
                  hintText: 'Enter Syllabus Priority..',
                  controller: _syllabusPripority,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Select The Priority First";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Reference (optional)',
                  hintText: 'Enter Reference..',
                  controller: _referenceController,
                ),

                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Syllabus Title',
                  hintText: 'Enter Syllabus Title..',
                  controller: _syllabusTitleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Syllabus Title First";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                CustomTextField(
                  maxline: 4,
                  label: 'Syllabus Description',
                  hintText: 'Enter Description..',
                  controller: _syllabusDescriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Syllabus Description First";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Upload card
                const SizedBox(height: 24),
                FilePickerBox(
                  onTaped: () {
                    showDocumentPickerBottomSheet(
                      context: context,
                      title: "Upload File",
                      onCameraTap: () =>
                          FilePickerHelper.pickFromCamera((file) {
                            setState(() => selectedFiles.add(file));
                          }),
                      onGalleryTap: () =>
                          FilePickerHelper.pickFromGallery((file) {
                            setState(() => selectedFiles.add(file));
                          }),
                      onPickDocument: () =>
                          FilePickerHelper.pickDocuments((files) {
                            setState(() => selectedFiles.addAll(files));
                          }),
                    );
                  },
                  selectedFiles: selectedFiles,
                  onRemoveFile: (index) {
                    setState(() => selectedFiles.removeAt(index));
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
                  'priority': _syllabusPripority.text,
                  'course_id': courseId,
                  'subject_id': _selectedSubjectId,
                  'syllabus_title': _syllabusTitleController.text,
                  'syllabus_details': _syllabusDescriptionController.text,
                  'status': 'yes',
                  ...notifyData,
                };

                final response = await UploadHomeWorksEtc().uploadData(
                  'syllabus',
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
                print("Bug Occured During The Upload of Syllabus ${e}");
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
      _syllabusPripority.clear();
      courseId = null;
      _selectedSubjectId = null;
      _syllabusTitleController.clear();
      _syllabusDescriptionController.clear();
      selectedFiles.clear();
    });
    // Reset the Notify Section
    notifyKey.currentState?.resetNotifySelection();
  }
}
