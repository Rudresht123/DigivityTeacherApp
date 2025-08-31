import 'dart:io';
import 'package:digivity_admin_app/AdminPanel/Components/CustomPickerBottomSheetForUploads.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/DynamicUrlInputList.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FilePickerBox.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/NotifyBySection.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/AssignmentTypes.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/MulitipleSelectStudentType.dart';
import 'package:digivity_admin_app/Components/MultiSelectStaff.dart';
import 'package:digivity_admin_app/Components/MultiselectCourse.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Components/TimePickerField.dart';
import 'package:digivity_admin_app/helpers/FilePickerHelper.dart';
import 'package:digivity_admin_app/helpers/PickAndResizeImage.dart';
import 'package:digivity_admin_app/helpers/UploadHomeWorksEtc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddNoticeScreen extends StatefulWidget {
  const AddNoticeScreen({super.key});

  @override
  State<AddNoticeScreen> createState() => _AddNoticeScreen();
}

class _AddNoticeScreen extends State<AddNoticeScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<NotifyBySectionState> notifyKey =
      GlobalKey<NotifyBySectionState>();
  final GlobalKey<DynamicUrlInputListState> dynamicurls =
      GlobalKey<DynamicUrlInputListState>();
  TextEditingController _noticeNo = TextEditingController();
  TextEditingController _noticeTitleController = TextEditingController();
  TextEditingController _noticeDescriptionController = TextEditingController();
  TextEditingController _noticeDate = TextEditingController();
  TextEditingController _noticeTime = TextEditingController();
  List<String> selectedCourses = [];
  List<String> selectedAdmissionTypes = [];
  List<String> selectedstaffs = [];
  List<File> selectedFiles = [];
  AssignmentType _selectedType = AssignmentType.student;

  @override
  void initState() {
    super.initState();
    // Load subject list or other initial data here if needed.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: 'Upload Notice', routeName: 'back'),
      ),
      body: BackgroundWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  label: 'Notice No',
                  hintText: 'Enter Notice Number',
                  controller: _noticeNo,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Notice Number First";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                DatePickerField(
                  label: 'Notice Date',
                  controller: _noticeDate,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Notice Date First";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                Timepickerfield(label: 'Notice Time', controller: _noticeTime),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),

                MultiselectCourse(
                  initialValues: selectedCourses,
                  onChanged: (courses) {
                    setState(() {
                      selectedCourses = courses;
                    });
                  },
                  validator: (courses) {
                    if (courses == null || courses.isEmpty) {
                      return "Please Select Course First";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                MulitipleSelectStudentType(
                  initialValues: selectedAdmissionTypes,
                  onChanged: (types) {
                    setState(() {
                      selectedAdmissionTypes = types;
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Notice Title',
                  hintText: 'Enter Homework Title',
                  controller: _noticeTitleController,
                  validator: (courses) {
                    if (courses == null || courses.isEmpty) {
                      return "Please Enter Notice Title First";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  maxline: 4,
                  label: 'Notice Description',
                  hintText: 'Enter Description',
                  controller: _noticeDescriptionController,
                  validator: (courses) {
                    if (courses == null || courses.isEmpty) {
                      return "Please Enter Notice Description";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                MultiSelectStaff(
                  initialValues: selectedstaffs,
                  onChanged: (value) {
                    selectedstaffs = value;
                    setState(() {});
                  },
                ),

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
                DynamicUrlInputList(key: dynamicurls),
                const SizedBox(height: 20),
                NotifyBySection(key: notifyKey),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: CustomBlueButton(
          width: double.infinity,
          text: 'Save',
          icon: Icons.save,
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              showLoaderDialog(context);
              try {
                final notifyData =
                    notifyKey.currentState?.getSelectedNotifyValues() ?? {};
                final dynamicurlslink =
                    dynamicurls.currentState?.getUrlLinks() ?? {};
                final dataInsert = {
                  'notice_no': _noticeNo.text,
                  'course_id': selectedCourses.join('~'),
                  'student_type': selectedAdmissionTypes.join('@'),
                  'notice_title': _noticeTitleController.text,
                  'notice': _noticeDescriptionController.text,
                  'notice_date': _noticeDate.text,
                  'notice_time': _noticeTime.text,
                  'notice_type': _selectedType.name,
                  'authorize_by': selectedstaffs.join('@'),
                  'status': 'yes',
                  'show_date_time': null,
                  'end_date_time': null,
                  'designation_id': null,
                  'staff_type': null,
                  'url_link': dynamicurlslink,
                  ...notifyData,
                };

                final response = await UploadHomeWorksEtc().uploadData(
                  'notice',
                  dataInsert,
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

  void resetForm() {
    setState(() {
      _noticeNo.clear();
      _noticeDate.clear();
      _noticeTitleController.clear();
      _noticeDescriptionController.clear();

      selectedCourses = []; // ← Replace with new empty list
      selectedAdmissionTypes = [];
      selectedstaffs = [];
      selectedFiles = [];
    });

    dynamicurls.currentState?.resetUrls();
    notifyKey.currentState?.resetNotifySelection();
  }
}
