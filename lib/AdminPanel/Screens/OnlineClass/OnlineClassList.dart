import 'package:digivity_admin_app/AdminPanel/Components/CommonBottomSheetForUploads.dart';
import 'package:digivity_admin_app/AdminPanel/Models/OnlineClassModel/OnlineClasses.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/OnlineClass/OnlineClassCard.dart';
import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Helpers/OnlineClassHelpers/OnlineClassHelper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnlineClassList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OnlineClassList();
  }
}

class _OnlineClassList extends State<OnlineClassList> {
  String? courseId;
  List<OnlineClasses>? onlineClasses;
  @override
  void initState() {
    super.initState();
  }

  Future<void> getCreatedClasses(String? courseId) async {
    showLoaderDialog(context);
    try {
      final formdata = {"course_section_id": courseId};
      final response = await OnlineClassHelper().getUserOnlineClasses(formdata);
      onlineClasses = response;
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
        child: SimpleAppBar(titleText: "Online Class", routeName: "back"),
      ),
      body: BackgroundWrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CardContainer(
              child: Column(
                children: [
                  CourseComponent(
                  initialValue:"",
                    onChanged: (value) {
                      courseId = value;
                      getCreatedClasses(courseId!);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: onlineClasses == null
                  ? Center(child: Text("Select a course to see classes"))
                  : onlineClasses!.isEmpty
                  ? Center(child: Text("No classes found"))
                  : ListView(
                      children: onlineClasses!
                          .expand(
                            (onlineClassItem) =>
                                onlineClassItem.onlineClassDetails!.map(
                                  (detail) => OnlineClassCard(
                                    onlineClass: detail,
                                    onDelete: () async {
                                      final helper = OnlineClassHelper();
                                      final response = await helper
                                          .deleteCreateClass(detail.id);
                                      if (response['result'] == 1) {
                                        await getCreatedClasses(courseId);
                                      }
                                      return response;
                                    },
                                  ),
                                ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomSheetForUploads(
        onFilter: () {},
        onAdd: () {
          context.pushNamed("add-online-classes");
        },
        addText: "Add online Class",
      ),
    );
  }
}
