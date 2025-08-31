import 'package:digivity_admin_app/AdminPanel/Components/SearchBox.dart';
import 'package:digivity_admin_app/AdminPanel/Models/LeaveRecord/StudentLeaveModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentLeave/StudentLeaveCard.dart';
import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
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
  List<StudentLeaveModel>? _originalList = [];
  List<StudentLeaveModel>? _filteredList = [];
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLeaveRecord(widget.formData!);
    });

    _searchController.addListener(() {
      _filterStudentLeaveRecordList();
    });
  }

  Future<void> getLeaveRecord(Map<String,dynamic>? formdata) async {
    showLoaderDialog(context);
    try {
      final response = await StudentLeaveRecordHelper().getStudentLeaveRecord(formdata);
      _originalList = response;
      _filteredList = response;
      setState(() {});
    } catch (e) {
      print(e);
      showBottomMessage(context, "$e", true);
    } finally {
      hideLoaderDialog(context);
    }
  }
  void _filterStudentLeaveRecordList() {
    final query = _searchController.text;

    if (_originalList == null) return;

    setState(() {
      _filteredList = FilterRecord<StudentLeaveModel>(
        data: _originalList!,
        query: query,
        modelFields: [
          (StudentLeaveModel s) => s.leaveApplyBy,
          (StudentLeaveModel s) => s.courseSection,
          (StudentLeaveModel s) => s.admissionNo!,
          (StudentLeaveModel s) => s.fatherName!,
        ],
        mapFields: null,
      );
    });
  }

  @override
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
              SearchBox(controller: _searchController),
              SizedBox(height: 10),
              _filteredList == null || _filteredList!.isEmpty
                  ? Expanded(
                child: Center(child: Text("No Leave Record Found")),
              )
                  : Expanded(
                child: ListView.builder(
                  itemCount: _filteredList!.length,
                  itemBuilder: (context, index) {
                    final leaveRequest = _filteredList![index];
                    return StudentLeaveCard(leaveRequest: leaveRequest);
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
