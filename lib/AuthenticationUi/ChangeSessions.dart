import 'package:digivity_admin_app/Components/AppBarComponent.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/BottomNavigation.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/SideBar.dart';
import 'package:digivity_admin_app/helpers/CommonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/Loader.dart';

class ChangeSessions extends StatefulWidget{
  const ChangeSessions({super.key});

  @override
  State<ChangeSessions> createState() {
    return _ChangeSessions();
  }
}



class _ChangeSessions extends State<ChangeSessions>{
  dynamic selectedAcademicSession;
  dynamic selectedFinancialSession;

  dynamic activeAcademicSession;
  dynamic activeFinancialSession;


  List<Map<String,dynamic>> academicSessions = [];
  List<Map<String,dynamic>> financialSessions = [];

  List<Map<String, dynamic>> sessionsList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSessions();
    });

  }

  Future<void> _loadSessions() async {
    if (!mounted) return;
    showLoaderDialog(context);

    sessionsList = await CustomFunctions().getSessionsList();

    if (!mounted) return;
    hideLoaderDialog(context);

    final academicData = sessionsList.firstWhere(
          (element) => element['key'] == 'academic_sessions',
      orElse: () => {'value': []},
    );
    final academicSessionsData = List<Map<String, dynamic>>.from(academicData['value']);

    final financialData = sessionsList.firstWhere(
          (element) => element['key'] == 'financial_sessions',
      orElse: () => {'value': []},
    );
    final financialSessionsData = List<Map<String, dynamic>>.from(financialData['value']);

    final activeAcademic = sessionsList.firstWhere(
          (element) => element['key'] == 'active_academic',
      orElse: () => {'value': null},
    );

    final activeFinancial = sessionsList.firstWhere(
          (element) => element['key'] == 'active_financial',
      orElse: () => {'value': null},
    );

    if (!mounted) return;
    setState(() {
      academicSessions = academicSessionsData;
      financialSessions = financialSessionsData;
      activeAcademicSession = activeAcademic['value'];
      activeFinancialSession = activeFinancial['value'];
      selectedAcademicSession = activeAcademicSession;
      selectedFinancialSession = activeFinancialSession;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: const Sidebar(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarComponent(appbartitle: "User Profile"),
      ),
      body: BackgroundWrapper(
        child: CardContainer(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logos/academic_session.avif',
                width: 300,
              ),
              SizedBox(height:60),
              CustomDropdown(
                items: academicSessions,
                displayKey: 'academic_session', // from API structure
                valueKey: 'id', // assuming you want to use id as value
                hint: "Choose Academic Session",
                selectedValue: activeAcademicSession ?? selectedAcademicSession,
                onChanged: (value) {
                  setState(() {
                    selectedAcademicSession = value;
                  });
                },
              ),
              SizedBox(height:25),
              CustomDropdown(
                items: financialSessions,
                displayKey: 'financial_session',
                valueKey: 'id',
                hint: "Choose Financial Session",
                selectedValue: activeFinancialSession ?? selectedFinancialSession,
                onChanged: (value) {
                  setState(() {
                    selectedFinancialSession = value;
                  });
                },
              ),
              SizedBox(height: 20,),
              CustomBlueButton(
                text: "Submit",
                icon: Icons.arrow_right_alt_sharp,
                width: 400,
                onPressed: () async {
                  if (selectedAcademicSession == null || selectedFinancialSession == null) {
                    showBottomMessage(context, 'Please Select Both', false);
                    return;
                  }
                  showLoaderDialog(context);
                  final response = await CustomFunctions().changeSession(
                    academicId: selectedAcademicSession,
                    financialId: selectedFinancialSession,
                  );
                  hideLoaderDialog(context);

                  if (response['result'] == 1) {
                    showBottomMessage(context, 'Session changed successfully.', false);
                  } else if (response['result'] == 0) {
                    // Handle Laravel validation errors
                    final errors = response['errors'] as Map<String, dynamic>;
                    String firstError = 'Something went wrong.';

                    if (errors.isNotEmpty) {
                      // Get the first key's first message
                      final firstKey = errors.keys.first;
                      final errorList = errors[firstKey];
                      if (errorList is List && errorList.isNotEmpty) {
                        firstError = errorList.first;
                      }
                    }

                    showBottomMessage(context, firstError, true);
                  }

                },
              )


            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}