import 'package:digivity_admin_app/AdminPanel/Models/LeaveRecord/StudentLeaveModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentsManagement/StudentLeave/StudentLeaveCard.dart';
import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CustomSliderButton.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Helpers/FilterRecord.dart';
import 'package:digivity_admin_app/Helpers/LeaveRecordHelper/StudentLeaveRecordHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentLeaveRecordScreen extends StatefulWidget {
  final Map<String, dynamic>? formData;
  const StudentLeaveRecordScreen({super.key, this.formData});

  @override
  State<StatefulWidget> createState() {
    return _StudentLeaveRecordScreen();
  }
}

class _StudentLeaveRecordScreen extends State<StudentLeaveRecordScreen> {
  List<StudentLeaveModel> _originalList = [];
  List<StudentLeaveModel> _filteredList = [];
  String? selectedButton = "All";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLeaveRecord(widget.formData!);
    });
  }

  Future<void> getLeaveRecord(Map<String, dynamic>? formdata) async {
    showLoaderDialog(context);
    try {
      final response = await StudentLeaveRecordHelper().getStudentLeaveRecord(
        formdata,
      );
      _originalList = response;
      _filteredList = response;
      setState(() {});
    } catch (e) {
      showBottomMessage(context, "$e", true);
    } finally {
      hideLoaderDialog(context);
    }
  }

  void _filterStaffList(String? fillter) {
    final query = fillter!.toLowerCase() ?? "all";
    showLoaderDialog(context);
    try {
      if (query == "all") {
        _filteredList = _originalList;
      } else {
        _filteredList = FilterRecord<StudentLeaveModel>(
          data: _originalList,
          query: query,
          modelFields: [(StudentLeaveModel s) => s.lvStatus!],
          mapFields: null,
        );
      }
      setState(() {});
    } catch (e) {
      showBottomMessage(context, "${e}", true);
    } finally {
      hideLoaderDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: 'Student Leave Record',
          routeName: "back",
        ),
      ),
      body: BackgroundWrapper(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              /// Top bar slider section for the buttons
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomSliderButton(
                            label: "All",
                            isSelected: selectedButton == "All",
                            onPressed: () {
                              _filterStaffList("All");
                              setState(() {
                                selectedButton = "All";
                              });
                            },
                          ),
                          SizedBox(width: 25),
                          CustomSliderButton(
                            label: "Pending",
                            isSelected: selectedButton == "Pending",
                            onPressed: () {
                              _filterStaffList("Pending");
                              setState(() {
                                selectedButton = "Pending";
                              });
                            },
                          ),
                          SizedBox(width: 25),
                          CustomSliderButton(
                            label: "Approve",
                            isSelected: selectedButton == "Approve",
                            onPressed: () {
                              _filterStaffList("Approve");
                              setState(() {
                                selectedButton = "Approve";
                              });
                            },
                          ),
                          SizedBox(width: 25),
                          CustomSliderButton(
                            label: "Reject",
                            isSelected: selectedButton == "Reject",
                            onPressed: () {
                              _filterStaffList("Reject");
                              setState(() {
                                selectedButton = "Reject";
                              });
                            },
                          ),
                          SizedBox(width: 25),
                          CustomSliderButton(
                            label: "Cancel",
                            isSelected: selectedButton == "Cancel",
                            onPressed: () {
                              _filterStaffList("Cancel");
                              setState(() {
                                selectedButton = "Cancel";
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              _filteredList == null || _filteredList!.isEmpty
                  ? Expanded(
                      child: Center(child: Text("No Leave Record Found")),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _filteredList!.length,
                        itemBuilder: (context, index) {
                          final leaveRequest = _filteredList![index];
                          return StudentLeaveCard(
                            leaveRequest: leaveRequest,
                            onreferesh: () {
                              getLeaveRecord(widget.formData!);
                              setState(() {

                              });
                            },
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
