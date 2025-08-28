import 'dart:convert';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/CommonFunctions.dart';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class DayWiseStudentAttendanceReportScreen extends StatefulWidget {
  final String? reportdate;
  final String? courseId;

  const DayWiseStudentAttendanceReportScreen({
    Key? key,
    required this.reportdate,
    required this.courseId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DayWiseStudentAttendanceReportScreen();
  }
}

class _DayWiseStudentAttendanceReportScreen extends State<DayWiseStudentAttendanceReportScreen> {
  bool isLoading = true;
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _fetchStudentAttendance();
  }

  void _fetchStudentAttendance() async {
    final response = await CustomFunctions().fetchDayWiseAttendanceHtml(
      widget.courseId!,
      widget.reportdate!,
    );

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    final uri = Uri.dataFromString(
      response ?? "<h3>No data available</h3>",
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    );

    await controller.loadRequest(uri);

    setState(() {
      _webViewController = controller;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: "Daywise Student Attendance Report",
          routeName: "back",
        ),
      ),
      body: isLoading || _webViewController == null
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _webViewController!),
    );
  }
}
