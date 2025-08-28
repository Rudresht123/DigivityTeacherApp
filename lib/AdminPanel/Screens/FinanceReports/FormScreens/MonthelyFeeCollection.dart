
import 'package:digivity_admin_app/AdminPanel/Screens/FinanceReports/FinanceReportScreen/FeereportHtmlshowScreen.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/FinanceHelperFunction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MonthelyFeeCollection extends StatefulWidget{

  @override
  State<MonthelyFeeCollection> createState() {
    return _MonthelyFeeCollection();
  }
}

class _MonthelyFeeCollection extends State<MonthelyFeeCollection>{

  TextEditingController _fromdate = TextEditingController();
  TextEditingController _todate = TextEditingController();


  void submitForm() async {
    showLoaderDialog(context);
    final formdata = {
      'from_date': _fromdate.text.trim(),
      'to_date': _todate.text.trim(),
    };

    try {
      String? htmlData = await FinanceHelperFunction().apifeecollectionreport('monthly-fee-collection-report',formdata);
      hideLoaderDialog(context);
      if (htmlData != null && htmlData.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeereportHtmlshowScreen(
              HtmlViewData: htmlData,
              appbartext: "Monthly Fee Collection Report",
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
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: SimpleAppBar(titleText: 'Monthly Fee Collection Report', routeName: 'back')),
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

