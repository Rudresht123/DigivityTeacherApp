import 'package:digivity_admin_app/AdminPanel/Models/StudentDocUploadsModels/CourseDocStatus.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/UploadsDocumentsHelpers/StudentDocumentsUploadHelpers.dart';
import 'package:flutter/material.dart';

class ClassWiseStudentDocumentsReports extends StatefulWidget {
  @override
  _ClassWiseStudentDocumentsReportsState createState() =>
      _ClassWiseStudentDocumentsReportsState();
}

class _ClassWiseStudentDocumentsReportsState
    extends State<ClassWiseStudentDocumentsReports> {
  List<CourseDocStatus> classList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      showLoaderDialog(context);
      await loadClassWiseDocData();
      hideLoaderDialog(context);
    });
  }

  Future<void> loadClassWiseDocData() async {
    try {

      final data = await Studentdocumentsuploadhelpers()
          .getClassWiseUplodedDocumentsDetails();
      if (data != null) {
        setState(() {
          classList = data;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: SimpleAppBar(titleText: 'Classwise Student Document Report', routeName: 'back')),
      backgroundColor: Colors.grey[100],
      body: BackgroundWrapper(
        child:ListView.separated(
          padding: EdgeInsets.all(6),
          itemCount: classList.length,
          separatorBuilder: (_, __) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            final data = classList[index];

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    color: Colors.black12,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(
                      Icons.article_outlined,
                      color: Colors.blue,
                      size: 12,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.course,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              "Doc. Upload (${data.totalUploadedDoument})",
                              style: TextStyle(
                                  color: Colors.teal, fontSize: 9),
                            ),
                            Container(
                              height: 10,
                              child: VerticalDivider(
                                width: 10,
                                color: Colors.grey,
                                thickness: 1,
                              ),
                            ),
                            Text(
                              "Doc. Not Upload (${data.totalStudentDocNotUploaded})",
                              style: TextStyle(
                                  color: Colors.red, fontSize: 9),
                            ),
                            Container(
                              height: 10,
                              child: VerticalDivider(
                                width: 10,
                                color: Colors.grey,
                                thickness: 1,
                              ),
                            ),
                            Text(
                              "Std Total Doc. (${data.totalDoument})",
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 9),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "${data.totalStudent}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                        fontSize: 10,
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
