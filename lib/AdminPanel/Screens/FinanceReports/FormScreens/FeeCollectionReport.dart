import 'package:digivity_admin_app/AdminPanel/Components/ImportEntryMode.dart';
import 'package:digivity_admin_app/AdminPanel/Components/ImportPaymode.dart';
import 'package:digivity_admin_app/AdminPanel/Components/ImportReceiptStatus.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FinanceReports/FinanceReportScreen/FeereportHtmlshowScreen.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/FinanceHelperFunction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeeCollectionReport extends StatefulWidget{

  @override
  State<FeeCollectionReport> createState() {
    return _FeeCollectionReport();
  }
}

class _FeeCollectionReport extends State<FeeCollectionReport>{
TextEditingController _instrumentController = TextEditingController();
TextEditingController _fromdate = TextEditingController();
TextEditingController _todate = TextEditingController();
String? paymode;
String? course_id;
String? entryMode;
String? receiptStatus;

void submitForm() async {
  showLoaderDialog(context);
  final formdata = {
    'from_date': _fromdate.text.trim(),
    'to_date': _todate.text.trim(),
    'course_id': course_id ?? '',
    'paymode_id': paymode ?? '',
    'instrument_no': _instrumentController.text.trim(),
    'entry_mode': entryMode ?? '',
    'receipt_status': receiptStatus ?? '',
    'student_name': 'Rudresh',
    'report_name': 'DailyFeeCollectionReport',
  };

  try {
    String? htmlData = await FinanceHelperFunction().apifeecollectionreport('apifeecollectionreport',formdata);
hideLoaderDialog(context);
    if (htmlData != null && htmlData.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeereportHtmlshowScreen(
            HtmlViewData: htmlData,
            appbartext: "Fee Collection Report",
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
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: SimpleAppBar(titleText: 'Fee Collection Report', routeName: 'back')),
      body: BackgroundWrapper(child: 
     Column(
       mainAxisAlignment: MainAxisAlignment.start,
       children: [
         CardContainer(
           child: Column(
             children: [
               DatePickerField(
                 label: 'From Date',
                 controller: _fromdate,
               ),
               SizedBox(height: 20,),
               DatePickerField(
                 label: 'To Date',
                 controller: _todate,
               ),
               SizedBox(height: 20,),
               CourseComponent(
                 onChanged: (value) {
                   course_id = value;
                   setState(() {});
                 },
               ),
               SizedBox(height: 20,),
               ImportPaymode(
                 onChanged: (value){
                   paymode = value;
                   setState(() {

                   });
                 },
               ),
               SizedBox(height: 20,),
               CustomTextField(label: 'Instrument No.', hintText: 'Enter Instrument No.', controller: _instrumentController),
               SizedBox(height: 20,),
               ImportEntryMode(
                 lable: 'Entry Mode',
                 onChanged: (value){
                   entryMode=value;
                   setState(() {
                   });
                 },
               ),
               SizedBox(height: 20,),
               ImportReceiptStatus(
                 lable: 'Receipt Status',
                 onChanged: (value){
                   receiptStatus=value;
                   setState(() {

                   });
                 },
               ),
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

