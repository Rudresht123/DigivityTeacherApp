import 'package:digivity_admin_app/AdminPanel/Components/CommonBottomSheetForUploads.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/StaffLeaveRecordModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StaffManagement/StaffLeaveModule/StaffLeaveRecordCard.dart';
import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CustomSliderButton.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Helpers/FilterRecord.dart';
import 'package:digivity_admin_app/Helpers/StaffAttendanceHelper/StaffLeaveRecordHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StaffAppliedScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StaffAppliedScreen();
  }
}

class _StaffAppliedScreen extends State<StaffAppliedScreen> {
  Color? backgroundColor = Colors.lightBlueAccent;
  String? selectedButton = "All";
  bool isloading = true;
  List<StaffLeaveRecordModel> staffleverecord = [];
  StaffLeaveRecordModel? leaveRequestdatal;
  List<StaffLeaveRecordModel> _filteredList = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getStaffLeaveRecord();
    });
  }

  /// Staff Leave Record get Section
  Future<void> _getStaffLeaveRecord() async {
    showLoaderDialog(context);
    try {
      final response = await StaffLeaveRecordHelper().getStaffLeaveRecord();
      staffleverecord = response;
      _filteredList = response;
      setState(() {});
    } catch (e) {
      print("${e}");
      showBottomMessage(context, "${e}", true);
    } finally {
      isloading = false;
      hideLoaderDialog(context);
    }
  }

  void _filterStaffList(String? fillter) {
    final query = fillter!.toLowerCase() ?? "all";
    showLoaderDialog(context);
    try {
      if (query == "all") {
        _filteredList = staffleverecord;
      } else {
        _filteredList = FilterRecord<StaffLeaveRecordModel>(
          data: staffleverecord,
          query: query,
          modelFields: [(StaffLeaveRecordModel s) => s.lvStatus!],
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
          titleText: "Staff Applied Leave",
          routeName: "back",
        ),
      ),
      body: BackgroundWrapper(
        child: Column(
          children: [
            /// Top bar slider section for the buttons
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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

            SizedBox(height: 20),
            Expanded(
              child: isloading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _filteredList.length,
                      itemBuilder: (context, index) {
                        final leaveRequest = _filteredList[index];
                        return StaffLeaveRecordCard(
                          leaverecord: leaveRequest,
                          onReferesh: () {
                            _getStaffLeaveRecord();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomSheetForUploads(
        onFilter: () async {},
        onAdd: () {
          context.pushNamed('add-staff-leave-record');
        },
        addText: "Apply Leave",
      ),
    );
  }
}
