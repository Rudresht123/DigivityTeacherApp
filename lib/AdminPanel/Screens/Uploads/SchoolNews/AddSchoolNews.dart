import 'dart:io';

import 'package:digivity_admin_app/AdminPanel/Components/CustomPickerBottomSheetForUploads.dart';
import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/SubjectModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/DynamicUrlInputList.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FilePickerBox.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/NotifyBySection.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ShowBySection.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/AssignmentTypes.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/Uploads/BannerInApp.dart';
import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:digivity_admin_app/Components/FieldSet.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Components/TimePickerField.dart';
import 'package:digivity_admin_app/Helpers/FilePickerHelper.dart';
import 'package:digivity_admin_app/Helpers/UploadHomeWorksEtc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddSchoolNews extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddSchoolNews();
  }
}

class _AddSchoolNews extends State<AddSchoolNews> {
  AssignmentType _selectedType = AssignmentType.student;
  BannerInAppType _selectedBannerType = BannerInAppType.yes;
  String? courseId;
  int? _selectedSubjectId;
  final _formkye = GlobalKey<FormState>();
  List<SubjectModel> subjectList = [];
  List<File> selectedFiles = [];
  TextEditingController _from_date = TextEditingController();
  TextEditingController _to_date = TextEditingController();
  TextEditingController _referenceController = TextEditingController();
  TextEditingController _referenceWroteBy = TextEditingController();
  TextEditingController _newsTitle = TextEditingController();
  TextEditingController _newsDescription = TextEditingController();
  TextEditingController _newsTime = TextEditingController();

  final GlobalKey<ShowBySectionState> showBykey =
      GlobalKey<ShowBySectionState>();
  final GlobalKey<DynamicUrlInputListState> dynamicurls =
      GlobalKey<DynamicUrlInputListState>();

  void resetForm() {
    setState(() {
      _formkye.currentState?.reset();
      _from_date.clear();
      _to_date.clear();
      _referenceController.clear();
      _referenceWroteBy.clear();
      _newsTitle.clear();
      _newsDescription.clear();
      _newsTime.clear();
      _selectedType = AssignmentType.student;
      _selectedBannerType = BannerInAppType.yes;
      selectedFiles.clear();

      // Reset dynamic URLs and notify section
      dynamicurls.currentState?.resetUrls();
      showBykey.currentState?.resetShowBySelection();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: "Add School news", routeName: "back"),
      ),
      body: BackgroundWrapper(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CardContainer(
                child: FieldSet(
                  title: "School News Details",
                  child: Form(
                    key: _formkye,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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

                        const SizedBox(height: 16),
                        DatePickerField(
                          label: 'From Date',
                          controller: _from_date,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Select From Date First";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),
                        DatePickerField(
                          label: 'To Date',
                          controller: _to_date,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Select From Date First";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),
                        Timepickerfield(controller: _newsTime),

                        const SizedBox(height: 16),
                        CustomTextField(
                          label: "Reference (Optional)",
                          hintText: "Enter Reference",
                          controller: _referenceController,
                        ),

                        const SizedBox(height: 16),
                        CustomTextField(
                          label: "News Wrote By (Optional)",
                          hintText: "News Wrote By",
                          controller: _referenceWroteBy,
                        ),

                        const SizedBox(height: 16),
                        CustomTextField(
                          label: "News Title",
                          hintText: "Enter News Title",
                          controller: _newsTitle,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Select From Date First";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),
                        CustomTextField(
                          label: "News Description",
                          hintText: "Enter News Description",
                          controller: _newsDescription,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Select From Date First";
                            }
                            return null;
                          },
                          maxline: 3,
                        ),

                        const SizedBox(height: 16),
                        FilePickerBox(
                          onTaped: () {
                            showDocumentPickerBottomSheet(
                              context: context,
                              title: "Upload File",
                              onCameraTap: () {
                                try {
                                  FilePickerHelper.pickFromCamera((file) {
                                    setState(() {
                                      selectedFiles.add(file);
                                    });
                                  });
                                } catch (e) {
                                  print("${e}");
                                  showBottomMessage(context, "${e}", true);
                                }
                              },
                              onGalleryTap: () {
                                try {
                                  FilePickerHelper.pickFromGallery((file) {
                                    setState(() {
                                      selectedFiles.add(file);
                                    });
                                  });
                                } catch (e) {
                                  print("${e}");
                                  showBottomMessage(context, "${e}", true);
                                }
                              },
                              onPickDocument: () {
                                try {
                                  FilePickerHelper.pickDocuments((files) {
                                    setState(() {
                                      selectedFiles.addAll(files);
                                    });
                                  });
                                } catch (e) {
                                  print("${e}");
                                  showBottomMessage(context, "${e}", true);
                                }
                              },
                            );
                          },
                          selectedFiles: selectedFiles,
                          onRemoveFile: (index) {
                            setState(() {
                              selectedFiles.removeAt(index);
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DynamicUrlInputList(key: dynamicurls),

                        const SizedBox(height: 16),
                        ShowBySection(key: showBykey),
                        const SizedBox(height: 16),
                        BannerInApp(
                          selectedType: _selectedBannerType,
                          onChanged: (value) {
                            if (value != null) {
                              _selectedBannerType = value;
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: CustomBlueButton(
          text: "Save",
          icon: Icons.save,
          onPressed: () async {
            if (_formkye.currentState!.validate()) {
              showLoaderDialog(context);
              try {
                final notifyData =
                    showBykey.currentState?.getSelectedNotifyValues() ?? {};
                final dynamicurlslink =
                    dynamicurls.currentState?.getUrlLinks() ?? {};

                final formdata = {
                  'news_for':  _selectedType.name,
                  'news_date': _from_date.text,
                  'upto_date': _to_date.text,
                  'news_time': _newsTime.text,
                  'reference_by': _referenceController.text,
                  'news_wrote_by': _referenceWroteBy.text,
                  'new_title_subject': _newsTitle.text,
                  'news_description': _newsDescription.text,
                  'url_link': dynamicurlslink,
                  "status":"yes",
                  "show_app_banner": _selectedBannerType.name,
                  ...notifyData,
                };
                final response = await UploadHomeWorksEtc().uploadData(
                  'schoolnews',
                  formdata!,
                  selectedFiles!,
                );
                if (response['result'] == 1) {
                  resetForm();
                  showBottomMessage(context, response['message'], false);
                } else {
                  showBottomMessage(context, response['message'], true);
                }
              } catch (e) {
                print("${e}");
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
}
