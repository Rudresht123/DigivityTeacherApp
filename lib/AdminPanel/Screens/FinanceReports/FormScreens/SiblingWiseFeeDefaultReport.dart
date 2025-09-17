import 'package:digivity_admin_app/AdminPanel/Components/ImportFeeHeads.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/FinanceReports/FinanceReportScreen/FeereportHtmlshowScreen.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
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

class SiblingWiseFeeDefaultReport extends StatefulWidget {
  @override
  State<SiblingWiseFeeDefaultReport> createState() {
    return _SiblingWiseFeeDefaultReport();
  }
}

class _SiblingWiseFeeDefaultReport extends State<SiblingWiseFeeDefaultReport> {
  final items = [
    {'id': '', 'value': 'Please Select Option'},
    {'id': 'yes', 'value': 'Yes'},
    {'id': 'no', 'value': 'No'},
  ];

  final showresults = [
    {'id': '', 'value': 'Please Select Option'},
    {'id': 'greater_than', 'value': 'Greater Than'},
    {'id': 'less_than', 'value': 'Less Than'},
  ];

  TextEditingController _acladger = TextEditingController();
  String? course_id;

  void submitForm() async {
    showLoaderDialog(context);

    try {
      final formData = {'course_id': course_id ?? '',
      "ac_ledger_no":_acladger.text ?? ''
      };

      String? htmlData = await FinanceHelperFunction().apifeecollectionreport(
        'ledger-class-course-section-wise-fee-defaulter-report',
        formData,
      );

      if (htmlData != null && htmlData.isNotEmpty) {
        // Hide loader before navigation
        hideLoaderDialog(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeereportHtmlshowScreen(
              HtmlViewData: htmlData,
              appbartext: "Ledger Wise Fee Default Report",
            ),
          ),
        );
      } else {
        hideLoaderDialog(context);
        showBottomMessage(context, "No report data found.", true);
      }
    } catch (e) {
      hideLoaderDialog(context);
      showBottomMessage(context, e.toString(), true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: 'Sibling-wise Fee Defaulter Report',
          routeName: 'back',
        ),
      ),
      body: BackgroundWrapper(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CardContainer(
                child: Column(
                  children: [
                    CourseComponent(
                      onChanged: (value) {
                        course_id = value;
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      label: 'A/C Ledger No.',
                      hintText: 'Enter Account Ledger No.',
                      controller: _acladger,
                    ),
                    SizedBox(height: 20),
                    CustomBlueButton(
                      width: double.infinity,
                      text: 'Get Result',
                      icon: Icons.arrow_forward,
                      onPressed: () async {
                        if(course_id == null){
                          showBottomMessage(context, "Please Select Course First", true);
                        }else {
                          submitForm();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
