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
import 'package:digivity_admin_app/Components/MultipleDesignationSelect.dart';
import 'package:digivity_admin_app/Components/MultiselectCourse.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Components/TimePickerField.dart';
import 'package:digivity_admin_app/helpers/FilePickerHelper.dart';
import 'package:digivity_admin_app/helpers/PickAndResizeImage.dart';
import 'package:digivity_admin_app/helpers/UploadHomeWorksEtc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Addcircularscreen extends StatefulWidget {
  const Addcircularscreen({super.key});

  @override
  State<Addcircularscreen> createState() => _Addcircularscreen();
}

class _Addcircularscreen extends State<Addcircularscreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<NotifyBySectionState> notifyKey =
      GlobalKey<NotifyBySectionState>();
  final GlobalKey<DynamicUrlInputListState> dynamicurls =
      GlobalKey<DynamicUrlInputListState>();
  TextEditingController _circularNo = TextEditingController();
  TextEditingController _circularTitleController = TextEditingController();
  TextEditingController _circularDescriptionController =
      TextEditingController();
  TextEditingController _circularDate = TextEditingController();
  TextEditingController _circularTime = TextEditingController();
  TextEditingController _circularShowDateTime = TextEditingController();
  TextEditingController _circularShowEndDateTime = TextEditingController();
  List<String> selectedCourses = [];
  List<String> selectedAdmissionTypes = [];
  List<File> selectedFiles = [];
  List<String> selectedstafss = [];
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
        child: SimpleAppBar(titleText: 'Upload Circular', routeName: 'back'),
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
                  label: 'Circular No',
                  hintText: 'Enter Circular Number',
                  controller: _circularNo,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Circular Number First";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                DatePickerField(
                  label: 'Circular Date',
                  controller: _circularDate,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Circular Date First";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Timepickerfield(controller: _circularTime),
                const SizedBox(height: 20),
                AssignmentTypeSelector(
                  label: 'Circular Type',
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
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
                  label: 'Circular Title',
                  hintText: 'Enter Circular Title',
                  controller: _circularTitleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Circular Title First";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  maxline: 4,
                  label: 'Circular Description',
                  hintText: 'Enter Circular Description',
                  controller: _circularDescriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Circular Description First";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                MultiSelectStaff(
                  initialValues: selectedstafss,
                  onChanged: (value) {
                    selectedstafss = value;
                    setState(() {});
                  },
                ),

                const SizedBox(height: 16),

                DatePickerField(
                  label: 'Circular Show Date',
                  controller: _circularShowDateTime,
                ),
                const SizedBox(height: 16),

                DatePickerField(
                  label: 'Circular Show End Date',
                  controller: _circularShowEndDateTime,
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
                  'circular_no': _circularNo.text,
                  'course_id': selectedCourses.join('~'),
                  'student_type': selectedAdmissionTypes.join('@'),
                  'circular_title': _circularTitleController.text,
                  'circular_time': _circularTime.text,
                  'circular': _circularDescriptionController.text,
                  'circular_date': _circularDate.text,
                  'circular_type': _selectedType.name,
                  'authorize_by': selectedstafss.join('@'),
                  'staff_type': 'null',
                  'status': 'yes',
                  'show_date': _circularShowDateTime.text,
                  'end_date': _circularShowEndDateTime.text,
                  'url_link': dynamicurlslink,
                  ...notifyData,
                };

                final response = await UploadHomeWorksEtc().uploadData(
                  'circular',
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
                print("Bug Occurred During The Submission of Circular ${e}");
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
      _circularNo.clear();
      _circularDate.clear();
      _circularTitleController.clear();
      _circularDescriptionController.clear();
      _circularShowDateTime.clear();
      _circularShowEndDateTime.clear();
      selectedCourses = []; // ← Replace with new empty list
      selectedAdmissionTypes = [];
      selectedFiles = [];
      selectedstafss = [];
    });
    _selectedType = AssignmentType.student;
    dynamicurls.currentState?.resetUrls();
    notifyKey.currentState?.resetNotifySelection();
  }
}
