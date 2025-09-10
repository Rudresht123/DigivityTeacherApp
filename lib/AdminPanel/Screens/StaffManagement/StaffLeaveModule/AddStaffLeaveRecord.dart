import 'dart:io';

import 'package:digivity_admin_app/AdminPanel/Components/CommonBottomSheetForUploads.dart';
import 'package:digivity_admin_app/AdminPanel/Components/CustomPickerBottomSheetForUploads.dart';
import 'package:digivity_admin_app/AdminPanel/Models/LeaveRecord/LeaveTypeModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FilePickerBox.dart';
import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:digivity_admin_app/Components/FieldSet.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Helpers/CommonFunctions.dart';
import 'package:digivity_admin_app/Helpers/FilePickerHelper.dart';
import 'package:digivity_admin_app/Helpers/StaffAttendanceHelper/StaffLeaveRecordHelper.dart';
import 'package:digivity_admin_app/Helpers/formatDate.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddStaffLeaveRecord extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddStaffLeaveRecord();
}

class _AddStaffLeaveRecord extends State<AddStaffLeaveRecord> {
  List<LeaveTypeModel> leaveTypes = [];
  TextEditingController _reasonController = TextEditingController();
  List<File> selectedFiles = [];

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();

  int? leavtype;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  int? leaveDays;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getLeaveType();

      // Initialize controllers with formatted dates
      _startDateController.text = formatDate(
        date: _startDate,
        format: 'd-MM-yyyy',
      );
      _endDateController.text = formatDate(date: _endDate, format: 'd-MM-yyyy');

      // Initial leave days calculation
      _getLeaveDays(_startDate, _endDate);
    });
  }

  void _getLeaveType() async {
    showLoaderDialog(context);
    try {
      final response = await CustomFunctions().getLeaveTypeList();
      setState(() {
        leaveTypes = response;
      });
    } catch (e) {
      showBottomMessage(context, "$e", true);
    } finally {
      hideLoaderDialog(context);
    }
  }

  void _getLeaveDays(DateTime startDate, DateTime endDate) {
    try {
      int days = getDays(startDate, endDate);
      leaveDays = days;
    } catch (e) {
      showBottomMessage(context, "$e", true);
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: "Add Leave Request", routeName: "back"),
      ),
      body: BackgroundWrapper(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CardContainer(
                child: FieldSet(
                  title: "Leave Request Info",
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // From Date
                        DatePickerField(
                          label: "From Date",
                          controller: _startDateController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Select Start Date First";
                            }
                            return null;
                          },
                          onDateSelected: (date) {
                            setState(() {
                              _startDate = date;
                              _startDateController.text = formatDate(
                                date: date,
                                format: 'dd-MM-yyy',
                              );
                              _getLeaveDays(_startDate, _endDate);
                            });
                          },
                        ),
                        SizedBox(height: 20),

                        // To Date
                        DatePickerField(
                          label: "To Date",
                          controller: _endDateController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Select To Date First";
                            }
                            return null;
                          },
                          onDateSelected: (date) {
                            setState(() {
                              _endDate = date;
                              _endDateController.text = formatDate(
                                date: date,
                                format: 'dd-MM-yyy',
                              );
                              _getLeaveDays(_startDate, _endDate);
                            });
                          },
                        ),
                        SizedBox(height: 20),

                        /// Card For The LeaveDays
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Number of Leave Days : ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  "${leaveDays}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        // Leave Type Dropdown
                        CustomDropdown(
                          label: "Leave Type",
                          items: leaveTypes.map((e) {
                            return {"value": e.id, "key": e.leaveType};
                          }).toList(),
                          displayKey: "key",
                          valueKey: "value",
                          validator: (value) {
                            if (value == null) {
                              return "Please Select Leave Type";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            leavtype = value;
                            setState(() {});
                          },
                          hint: "Select A Option",
                        ),
                        SizedBox(height: 20),

                        // Reason Input
                        CustomTextField(
                          label: "Reason",
                          hintText: "Enter Your Reason",
                          controller: _reasonController,
                          maxline: 4,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Leave Reason";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        // File Picker
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

                        SizedBox(height: 20),
                        Center(
                          child: Card(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked =
                                          value ?? false; // update state
                                    });
                                  },
                                ),
                                Text(
                                  "I agree To Submit Leave Request ? ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
      bottomNavigationBar: CommonBottomSheetForUploads(
        onFilter: () {
          try {
            context.pop();
          } catch (e) {
            print("${e}");
            showBottomMessage(context, "${e}", true);
          }
        },
        onAdd: () async {
          try {
            if (_formKey.currentState!.validate()) {
              if (isChecked == false) {
                showBottomMessage(
                  context,
                  "Please Select Condition If You Are Agree",
                  true,
                );
                return;
              } else {
                showLoaderDialog(context);
                final formdata = {
                  "leave_type_id": leavtype,
                  "leave_reasons": _reasonController.text,
                  "start_date": _startDateController.text,
                  "end_date": _endDateController.text,
                  "total_leave": leaveDays,
                  "iagree": isChecked,
                };

                final response = await StaffLeaveRecordHelper()
                    .storeStaffLeaveRequest(formdata, selectedFiles);

                if (response['result'] == 1) {
                  hideLoaderDialog(context);
                  context.pop(); // remove Add Leave
                  context.pop();
                  context.pushNamed("staff-applied-leave");
                  showBottomMessage(context, "${response['message']}", false);
                } else {
                  hideLoaderDialog(context);
                  showBottomMessage(context, "${response['message']}", true);
                }
              }
            }
          } catch (e) {
            print("${e}");
            showBottomMessage(context, "${e}", true);
          }
        },
        filterText: "Cancel",
        addText: "Add Complaint",
      ),
    );
  }
}
