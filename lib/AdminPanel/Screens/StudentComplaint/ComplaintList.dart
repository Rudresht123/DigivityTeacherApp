import 'package:digivity_admin_app/AdminPanel/Components/CommonBottomSheetForUploads.dart';
import 'package:digivity_admin_app/AdminPanel/Models/ComplaintModel/ComplaintModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StudentComplaint/ComplaintCard.dart';
import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Helpers/ComplaintHelper/StudentComplaintHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ComplaintList extends StatefulWidget {
  final Map<String, dynamic> formdata;
  const ComplaintList({Key? key, required this.formdata}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ComplaintList();
  }
}

class _ComplaintList extends State<ComplaintList> {
  List<ComplaintModel>? complainttype = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getComplaintType();
    });
  }

  Future<void> _getComplaintType() async {
    showLoaderDialog(context);
    try {
      final response = await StudentComplaintHelper().getStudentComplaints(
        widget.formdata,
      );
      complainttype = response;
      isLoading = false; // 👈 loader stop

      setState(() {});
    } catch (e) {
      print("${e}");
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
          titleText: "Student Raised Complaint",
          routeName: "back",
        ),
      ),
      body: BackgroundWrapper(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : complainttype!.isEmpty
            ? Center(child: Text("No Record Found"))
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: complainttype!.length,
                itemBuilder: (context, index) {
                  final complaint = complainttype![index];
                  return ComplaintCard(complaint: complaint);
                },
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
        onAdd: () {
          try {
            context.pushNamed("add-student-complaint");
          } catch (e) {
            print("${e}");
            showBottomMessage(context, "${e}", true);
          }
        },
        addText: "Add Complaint",
      ),
    );
  }
}
