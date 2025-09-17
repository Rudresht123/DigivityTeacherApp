import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Models/TransportAttendanceModels/StudentTransportAttendanceModel.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Helpers/StaffAttendanceHelper/GetLocationAndTime.dart';
import 'package:digivity_admin_app/Helpers/TransportAttendanceHelper/TransportAttendanceHelper.dart';
import 'package:digivity_admin_app/Helpers/formatDate.dart';
import 'package:flutter/material.dart';

/// 🔥 Status Constants (backend ke hisaab se)
const String STATUS_PICKED_UP = "p";
const String STATUS_ABSENT = "ab";
const String STATUS_DROPPED_OUT = "lv";

class StudentTransdportAttendance extends StatefulWidget {
  final int routeId;
  final int stopId;
  final String attendanceDate;
  final String routename;
  final String routeStopName;

  const StudentTransdportAttendance({
    required this.routeId,
    required this.stopId,
    required this.attendanceDate,
    required this.routename,
    required this.routeStopName,
    super.key,
  });

  @override
  State<StudentTransdportAttendance> createState() =>
      _StudentTransportAttendanceScreenState();
}

class _StudentTransportAttendanceScreenState
    extends State<StudentTransdportAttendance> {
  List<StudentTransportAttendanceModel> _students = [];
  Map<int, String> _attendanceMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  /// 🔹 Fetch students list
  Future<void> _fetchData() async {
    if (!mounted) return;
    showLoaderDialog(context);

    try {
      final formdata = {
        "stopId": widget.stopId,
        "attendance_date": widget.attendanceDate,
      };

      final response = await TransportAttendanceHelper()
          .getStudentForTransportAttendance(formdata);

      if (mounted) {
        setState(() {
          _students = response;
          for (var student in _students) {
            _attendanceMap[student.studentId] = student.attendance;
          }
        });
      }
    } catch (e, stack) {
      debugPrint("Error fetching students: $e");
      debugPrintStack(stackTrace: stack);
      if (mounted) {
        showBottomMessage(context, "Failed to load students: $e", true);
      }
    } finally {
      if (mounted) hideLoaderDialog(context);
    }
  }

  /// 🔹 Submit attendance of single student
  Future<void> _submitSingleStudentAttendance(
    int studentId,
    String status,
    String currentTime,
  ) async {
    if (!mounted) return;
    showLoaderDialog(context);
    try {
      final position = await getCurrentPositionWithPlace();
      final formdata = {
        "attendancesubmitted_transport": "1",
        "data": [
          {
            "student_id": studentId.toString(),
            "att_date": widget.attendanceDate,
            "latitude": position?['latitude'].toString(),
            "longitude": position?['longitude'].toString(),
            "current_status": status,
            "current_time": currentTime,
          },
        ],
        "stop_id": widget.stopId.toString(),
      };
      final response = await TransportAttendanceHelper()
          .submitStudentTransportAttendance(formdata);
      if (mounted) {
        showBottomMessage(
          context,
          response['message'],
          response['result'] == 1 ? false : true,
        );
        await _fetchData();
      }
    } catch (e, stack) {
      debugPrint("Error submitting attendance: $e");
      debugPrintStack(stackTrace: stack);
      if (mounted) {
        showBottomMessage(context, "Failed to submit attendance: $e", true);
      }
    } finally {
      if (mounted) hideLoaderDialog(context);
    }
  }

  /// 🔹 Reusable Attendance Button
  Widget buildAttendanceButton({
    required String label,
    required IconData icon,
    required Color bgColor,
    required Color fgColor,
    required String status,
    required int studentId,
    required bool enabled,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      icon: Icon(icon, size: 14),
      label: Text(label, style: const TextStyle(fontSize: 11)),
      onPressed: enabled
          ? () {
              setState(() {
                _attendanceMap[studentId] = status;
              });
              final String current_time = currentTime();
              _submitSingleStudentAttendance(studentId, status, current_time);
            }
          : null,
    );
  }

  /// 🔹 Get colors and icons based on status
  (Color, Color, IconData) _getStyle(String status, String checkStatus) {
    if (status == checkStatus) {
      switch (checkStatus) {
        case STATUS_PICKED_UP:
          return (Colors.green.shade100, Colors.green.shade800, Icons.check);
        case STATUS_DROPPED_OUT:
          return (Colors.orange.shade100, Colors.orange.shade800, Icons.check);
        case STATUS_ABSENT:
          return (Colors.red.shade100, Colors.red.shade800, Icons.check);
      }
    }
    // Default styles when not active
    switch (checkStatus) {
      case STATUS_PICKED_UP:
        return (
          Colors.grey.shade200,
          Colors.green.shade800,
          Icons.arrow_upward,
        );
      case STATUS_DROPPED_OUT:
        return (
          Colors.grey.shade200,
          Colors.orange.shade800,
          Icons.arrow_downward,
        );
      case STATUS_ABSENT:
        return (
          Colors.grey.shade200,
          Colors.red.shade800,
          Icons.circle_outlined,
        );
      default:
        return (Colors.grey.shade200, Colors.black, Icons.help);
    }
  }

  Color getCardBg(String status) {
    switch (status) {
      case STATUS_PICKED_UP:
        return const Color(0xFFDBF3E2); // light green
      case STATUS_DROPPED_OUT:
        return Colors.orange.shade50;
      case STATUS_ABSENT:
        return Colors.red.shade50;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText:
              "Attendance : [ ${widget.routename} - ${widget.routeStopName} ]",
          routeName: 'back',
        ),
      ),
      body: BackgroundWrapper(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
            child: Column(
              children: [
                const SizedBox(height: 5),
                Expanded(
                  child: _students.isNotEmpty
                      ? ListView.separated(
                          itemCount: _students.length,
                          separatorBuilder: (context, index) =>
                              Divider(color: Colors.grey.shade300, height: 1),
                          itemBuilder: (context, index) {
                            final student = _students[index];
                            final status =
                                _attendanceMap[student.studentId] ??
                                student.attendance ??
                                "";

                            bool enablePickedUp = false;
                            bool enableDroppedOut = false;
                            bool enableAbsent = false;
                            if (status.isEmpty) {
                              enablePickedUp = true;
                              enableDroppedOut = false;
                              enableAbsent = true;
                            } else if (status == STATUS_PICKED_UP) {
                              enablePickedUp = false;
                              enableDroppedOut = true;
                              enableAbsent = false;
                            } else if (status == STATUS_DROPPED_OUT) {
                              enablePickedUp = false;
                              enableDroppedOut = false;
                              enableAbsent = false;
                            } else if (status == STATUS_ABSENT) {
                              enablePickedUp = false;
                              enableDroppedOut = false;
                              enableAbsent = true;
                            }

                            // Background color for card
                            Color cardBg = Colors.white;
                            if (status == STATUS_PICKED_UP) {
                              cardBg = const Color(0xFFDBF3E2);
                            } else if (status == STATUS_DROPPED_OUT) {
                              cardBg = Colors.orange.shade50;
                            } else if (status == STATUS_ABSENT) {
                              cardBg = Colors.red.shade50;
                            }

                            // Picked up styles
                            final (pickBg, pickFg, pickIcon) = _getStyle(
                              status,
                              STATUS_PICKED_UP,
                            );
                            final (dropBg, dropFg, dropIcon) = _getStyle(
                              status,
                              STATUS_DROPPED_OUT,
                            );
                            final (absBg, absFg, absIcon) = _getStyle(
                              status,
                              STATUS_ABSENT,
                            );

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /// Profile Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: PopupNetworkImage(
                                      imageUrl: student.profileImg,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  /// Student Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${student.studentName} (${student.course})",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Adm: ${student.admissionNo} | Roll: ${student.rollNo ?? 'N/A'}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "D/O: ${student.fatherName}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// Action Buttons
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: [
                                      buildAttendanceButton(
                                        label:
                                            student.pcikedUp != null &&
                                                student.pcikedUp!.isNotEmpty
                                            ? "${student.pcikedUp}"
                                            : "Picked Up",
                                        icon: pickIcon,
                                        bgColor: pickBg,
                                        fgColor: pickFg,
                                        status: STATUS_PICKED_UP,
                                        studentId: student.studentId,
                                        enabled: enablePickedUp,
                                      ),
                                      buildAttendanceButton(
                                        label:
                                            student.dropepdOut != null &&
                                                student.dropepdOut!.isNotEmpty
                                            ? "${student.dropepdOut}"
                                            : "Drop Out",
                                        icon: dropIcon,
                                        bgColor: dropBg,
                                        fgColor: dropFg,
                                        status: STATUS_DROPPED_OUT,
                                        studentId: student.studentId,
                                        enabled: enableDroppedOut,
                                      ),
                                      buildAttendanceButton(
                                        label: "Absent",
                                        icon: absIcon,
                                        bgColor: absBg,
                                        fgColor: absFg,
                                        status: STATUS_ABSENT,
                                        studentId: student.studentId,
                                        enabled: enableAbsent,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : const Center(child: Text("No students found")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
