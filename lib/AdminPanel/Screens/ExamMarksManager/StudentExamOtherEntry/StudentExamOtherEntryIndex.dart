import 'package:digivity_admin_app/AdminPanel/Components/ReportCardBox.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/OtherEntrytypeList.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/MarksManagerHelpers/StudentExamOtherEntryHelper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentExamOtherEntryIndex extends StatefulWidget{

  @override
  State<StudentExamOtherEntryIndex> createState() {
    return _StudentExamOtherEntryIndex();
  }
}


class _StudentExamOtherEntryIndex extends State<StudentExamOtherEntryIndex> {
  List<OtherEntrytypeList> typeslist = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showLoaderDialog(context);
      await getTypeList();
    });
    super.initState();
  }

  Future<void> getTypeList() async {
    final response = await StudentExamOtherEntryHelper().getExamOtherEntryTypes();
    print(response);
    if (response.isNotEmpty) {
      typeslist = response;
      setState(() {});
    }
    hideLoaderDialog(context);
  }

  IconData getIconsData(String key) {
    if(key=='attendance'){
      return Icons.qr_code;
    }
    else if(key=='ptm'){
      return Icons.person;
    }
    else if(key=='height-weight'){
      return Icons.height;
    }
    else {
      return Icons.book;
    }
  }

  void screenSwitch(String typekey){
    if(typekey=='attendance'){
      context.pushNamed('exam-total-attendance-entry');
    }
    else if(typekey=='height-weight'){
      context.pushNamed('student-height-weight-list-search');
    }
    else if(typekey=='ptm'){
      context.pushNamed('student-ptm-list-search');
    }

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: 'Exam Other Entry', routeName: 'back'),
      ),
      body: BackgroundWrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
               SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      itemCount: typeslist.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data = typeslist[index];
                        return ReportCardBox(
                          icon: getIconsData(data.Otherentrykeys),
                          title: data.Otherentry,
                          onTap: () async{
                            screenSwitch(data.Otherentrykeys);
                          },
                        );
                      },
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
