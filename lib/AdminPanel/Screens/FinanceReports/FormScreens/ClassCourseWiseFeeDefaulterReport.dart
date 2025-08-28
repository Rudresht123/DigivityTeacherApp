
import 'package:digivity_admin_app/AdminPanel/Components/ImportFeeHeads.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FinanceReports/FinanceReportScreen/FeereportHtmlshowScreen.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/FinanceHelperFunction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassCourseWiseFeeDefaulterReport extends StatefulWidget{

  @override
  State<ClassCourseWiseFeeDefaulterReport> createState() {
    return _ClassCourseWiseFeeDefaulterReport();
  }
}

class _ClassCourseWiseFeeDefaulterReport extends State<ClassCourseWiseFeeDefaulterReport>{

  final items =[
    {'id':'','value':'Please Select Option'},
    {'id':'yes','value':'Yes'},
    {'id':'no','value':'No'},
    ];

  final showresults =[
    {'id':'','value':'Please Select Option'},
    {'id':'greater_than','value':'Greater Than'},
    {'id':'less_than','value':'Less Than'},
  ];

  TextEditingController _fromdate = TextEditingController();
  TextEditingController _resultController = TextEditingController();
  TextEditingController _studentname = TextEditingController();
  TextEditingController _acladger = TextEditingController();
  String? course_id;
  String? feehead;
  String? selectedBalanceOption;
  String? selectedResult;



  void submitForm() async {
    showLoaderDialog(context);

    final formdata = {
      'fee_head': feehead ?? '',
      'fee_month': _fromdate.text.trim(),
      'course_id': course_id ?? '',
      'balance_yes_no': selectedBalanceOption ?? '',
      'result': selectedResult ?? '',
      'result_value': _resultController.text.trim(),
      'student_name': _studentname.text.trim(),
      'account_ledger_no': _acladger.text.trim(),
    };

    try {
      String? htmlData = await FinanceHelperFunction().apifeecollectionreport(
          'class-course-section-wise-fee-defaulter-report', formdata);
      hideLoaderDialog(context);

      if (htmlData != null && htmlData.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeereportHtmlshowScreen(
              HtmlViewData: htmlData,
              appbartext: "Class/Course Wise Fee Defaulter Report",
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No report data found.")),
        );
      }
    } catch (e) {
      print("SubmitForm Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong.")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: SimpleAppBar(titleText: 'Class/Course Wise Fee Defaulter Report', routeName: 'back')),
      body: BackgroundWrapper(child:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CardContainer(
            child: Column(
              children: [
                DatePickerField(
                  label: 'Fee Month',
                  controller: _fromdate,
                ),
                SizedBox(height: 20,),
              CustomDropdown(items: items, displayKey: 'value', valueKey: 'id', onChanged: (value){
                selectedBalanceOption=value;
                setState(() {

                });
              }, hint: 'Zero Bal. Show In List'),
                SizedBox(height: 20,),
                CourseComponent(
                  onChanged: (value){
                    course_id=value;
                    setState(() {

                    });
                  },
                ),
                SizedBox(height: 20,),
                CustomDropdown(items: showresults, displayKey: 'value', valueKey: 'id', onChanged: (value){
                  selectedResult=value;
                  setState(() {

                  });
                }, hint: 'Result'),
                SizedBox(height: 20,),
                CustomTextField(label: 'Result Value', hintText: '0', controller: _resultController),
                SizedBox(height: 20,),
                ImportFeeHeads(
                    onChanged: (value){
                    feehead=value;
                    setState(() {
                    });
                },
                ),
                SizedBox(height: 20,),
                CustomTextField(label: 'Student Name', hintText: 'Enter Student Name', controller: _studentname),
                SizedBox(height: 20,),
                CustomTextField(label: 'A/C Ledger No.', hintText: 'Enter Student Name', controller: _acladger),
                SizedBox(height: 20,),
                CustomBlueButton(
                    width: double.infinity,
                    text: 'Get Result', icon: Icons.arrow_forward, onPressed: () async{
                  submitForm();
                })

              ],
            ),
          )
        ],)
      ),
    );
  }
}

