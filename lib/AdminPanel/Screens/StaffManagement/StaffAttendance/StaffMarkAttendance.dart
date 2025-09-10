import 'dart:io';

import 'package:digivity_admin_app/AdminPanel/Components/AttendanceConfirmationDialog.dart';
import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffAttendanceModel/StaffScheduleTimeList.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StaffManagement/StaffAttendance/SubmissionButton.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Helpers/FilePickerHelper.dart';
import 'package:digivity_admin_app/Helpers/StaffAttendanceHelper/GetLocationAndTime.dart';
import 'package:digivity_admin_app/Helpers/StaffAttendanceHelper/StaffAttendanceHelper.dart';
import 'package:digivity_admin_app/Helpers/formatDate.dart';
import 'package:digivity_admin_app/Helpers/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class StaffMarkAttendance extends StatefulWidget {
  StaffMarkAttendance();

  @override
  State<StatefulWidget> createState() {
    return _StaffMarkAttendance();
  }
}

class _StaffMarkAttendance extends State<StaffMarkAttendance> {
  final List<StaffScheduleTimeList> attendanceConfiguration = [];
  File? checkedImage;
  bool isLogin = false;
  bool isInDesiredPlace = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getAttendanceConfiguration();
    });
  }

  Future<void> _getAttendanceConfiguration() async {
    showLoaderDialog(context);
    try {
      final response = await StaffAttendanceHelper()
          .getStaffArrivalAndDepartureTime();
      setState(() {
        attendanceConfiguration.clear();
        attendanceConfiguration.addAll(response);
        isLogin = true;
      });
      getLocationDetails();
    } catch (e) {
      print("Error fetching attendance: $e");
    } finally {
      hideLoaderDialog(context);
    }
  }

  double safeParse(String? value) {
    if (value == null || value.isEmpty) return 0.0;
    return double.tryParse(value) ?? 0.0;
  }

  Future<void> getLocationDetails() async {
    final double apilatitude = safeParse(attendanceConfiguration[0].latitude);
    final double apilongitude = safeParse(attendanceConfiguration[0].longitude);
    final double apiraduis = safeParse(attendanceConfiguration[0].radius);
    final premission =
        await PermissionService.requestDeviceLocationPermission();
    if (premission) {
      final response = await getLocationAndTime(
        apiraduis,
        apilatitude,
        apilongitude,
      );
      print(response);
      if (response['isInside']) {
        setState(() {
          isInDesiredPlace = true;
        });
      } else {
        isInDesiredPlace = false;
      }
    } else {
      openAppSettings();
    }
  }

  Future<void> submitAttendance(String attType) async {
    showLoaderDialog(context);
    try {
      int StaffId = await SharedPrefHelper.getPreferenceValue('staff_id');
      int UserId = await SharedPrefHelper.getPreferenceValue('user_id');

      int lateMinutes = minutesdifferent(
        attendanceConfiguration[0]!.arrivalTime,
      );

      final data = {
        'staff_id': StaffId,
        'attendance_date': formatDate(),
        'attendance': lateMinutes >= 1 ? "lt" : "P",
        'punch_in': currentTime(),
        'punch_out': currentTime(),
        'user_id': UserId.toString(),
        'punch_in_img': checkedImage != null ? encodeFile(checkedImage) : "",
        'punch_out_img': checkedImage != null ? encodeFile(checkedImage) : "",
        'late_in': lateMinutes.toString(),
        'attendance_type': attType,
        'extension': '.jpeg',
      };

      final response = await StaffAttendanceHelper().storeStaffAttendance(data);
      print(response['result']);
      hideLoaderDialog(context);
      if (response['result'] == 1) {
        setState(() {
          checkedImage = null;
        });
        showBottomMessage(context, response['message'], false);
      } else if (response['result'] == 2) {
        setState(() {
          checkedImage = null;
        });
        showBottomMessage(context, response['message'], false);
      } else {
        showBottomMessage(context, response['message'], true);
      }
    } catch (e) {
      print("Error Occurred In Submitting The Attendance: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiTheme = Provider.of<UiThemeProvider>(context);
    List<File> clickedImage = [];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: 'Mark Self Attendance',
          routeName: 'back',
        ),
      ),
      body: BackgroundWrapper(
        child: isLogin == false
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  CardContainer(
                    child: Column(
                      children: [
                        // Full-width centered header
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12.0),
                          color: uiTheme.appBarColor ?? Colors.blueAccent,
                          alignment: Alignment.center,
                          child: Text(
                            'Scheduled Arrival / Departure Time',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        // Actual Table
                        Table(
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          columnWidths: {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(3),
                          },
                          children: [
                            // Column Headers
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade100,
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'Scheduled Arrival',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    'Scheduled Departure',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Data Row 1
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    attendanceConfiguration[0].arrivalTime ??
                                        '09:00 AM',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    attendanceConfiguration[0].departureTime ??
                                        '05:00 PM',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  CardContainer(
                    child: Column(
                      children: [
                        // Header: Selfie & Punch In Info
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: uiTheme.appBarColor ?? Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Take Selfie & Mark Attendance',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Punch In Option will Disable after ${attendanceConfiguration.isNotEmpty ? attendanceConfiguration[0].punchinDisable : 1} min. from Arrival Time',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10),

                        // Staff Image Container (responsive)
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  uiTheme.appBarColor ?? Colors.green.shade600,
                              width: 2,
                            ),
                            image: DecorationImage(
                              image: checkedImage != null
                                  ? FileImage(checkedImage!) // Use picked file
                                  : AssetImage('assets/images/staff_image.jpeg')
                                        as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        checkedImage == null
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: isInDesiredPlace
                                    ? CustomBlueButton(
                                        text: "Take Photo",
                                        icon: Icons.camera,
                                        onPressed: () async {
                                          final clickedFile =
                                              FilePickerHelper.pickFromCamera(
                                                (file) => {
                                                  setState(() {
                                                    checkedImage = file;
                                                  }),
                                                },
                                              );
                                        },
                                      )
                                    : Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent.withOpacity(
                                            0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: Colors.redAccent,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.location_off,
                                              color: Colors.redAccent,
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              "Not at School Range",
                                              style: TextStyle(
                                                color: Colors.redAccent,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SubmissionButton(
                                      bgColour: Colors.green,
                                      text: "Punch In",
                                      icon: Icons.check,
                                      onPressed: () {
                                        int lateMinutes = minutesdifferent(
                                          attendanceConfiguration[0]!
                                              .arrivalTime,
                                        );
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (_) =>
                                              AttendanceConfirmationDialog(
                                                lateMinutes: lateMinutes,
                                                attendanceType: "punchin",
                                                onConfirm: () async {
                                                  Navigator.pop(context);
                                                  await submitAttendance(
                                                    'punchin',
                                                  );
                                                },
                                                onCancel: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                        );
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    SubmissionButton(
                                      bgColour: Colors.blueAccent,
                                      text: "Punch Out",
                                      icon: Icons.save,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (_) =>
                                              AttendanceConfirmationDialog(
                                                lateMinutes: 0,
                                                attendanceType: "punchout",
                                                onConfirm: () async {
                                                  Navigator.pop(context);
                                                  await submitAttendance(
                                                    'punchout',
                                                  );
                                                },
                                                onCancel: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
