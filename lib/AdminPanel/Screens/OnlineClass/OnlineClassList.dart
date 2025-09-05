import 'package:digivity_admin_app/AdminPanel/Components/CommonBottomSheetForUploads.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnlineClassList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OnlineClassList();
  }
}

class _OnlineClassList extends State<OnlineClassList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: "Student Online Class",
          routeName: "back",
        ),
      ),
      body: BackgroundWrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CardContainer(child: Column(children: [CourseComponent()])),
            SingleChildScrollView(child: Column(children: [])),
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
