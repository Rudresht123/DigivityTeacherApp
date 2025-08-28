import 'dart:convert';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/CommonFunctions.dart';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class CourseWiseStudentAttendanceReportScreen extends StatefulWidget {
  final String? reportdate;


  const CourseWiseStudentAttendanceReportScreen({
    Key? key,
    required this.reportdate,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CourseWiseStudentAttendanceReportScreen();
  }
}

class _CourseWiseStudentAttendanceReportScreen extends State<CourseWiseStudentAttendanceReportScreen> {
  bool isLoading = true;
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _fetchStudentAttendance();
  }

  void _fetchStudentAttendance() async {
    final response = await CustomFunctions().fetchCourseAttendanceHtml(
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
          titleText: "CourseWise Student Attendance Report",
          routeName: "back",
        ),
      ),
      body: isLoading || _webViewController == null
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _webViewController!),
    );
  }
}
