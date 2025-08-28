
import 'package:digivity_admin_app/AdminPanel/Models/SmsManagementModels/CmposeCommunicationReponce.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/FieldSet.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Helpers/CommunicationManagement/CommunicationManagementHelper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SendSmsTousers extends StatefulWidget{
  @override
  State<SendSmsTousers> createState() {
    return _SendSmsTousers();
  }
}

class _SendSmsTousers extends State<SendSmsTousers>{
  CmposeCommunicationReponce? cmposeSMSConfiguration;
  List<String> selectedCourseIds = [];
  List<String> selectedDesignationIds = [];
  List<String> selectedAdminstration = [];
  bool isChecked = false;
  bool courseChecked =false;
  bool administrationChecked=false;
  bool designationChecked =false;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getComposeSMSData();
    });
    super.initState();
  }

  Future<void> getComposeSMSData() async{
    showLoaderDialog(context);
    final response = await CommunicationManagementHelper().getCommunicationContacts();
    if (response != null) {
      cmposeSMSConfiguration = response;
    }
    setState(() {

    });
    hideLoaderDialog(context);
  }

  Future<void> sendToPreviewPage() async{

    if(selectedCourseIds.isNotEmpty || selectedDesignationIds.isNotEmpty || selectedAdminstration.isNotEmpty) {
      context.pushNamed(
        'compose-sms',
        extra: {
          'selectedCourseIds': selectedCourseIds,
          'selectedDesignationIds': selectedDesignationIds,
          'selectedAdminstration': selectedAdminstration,
        },
      );
    }
    else{
      showBottomMessage(context, 'At least one of the lists should be required?', true);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: SimpleAppBar(titleText: 'Send SMS To Users', routeName: 'back')),
      body: BackgroundWrapper(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child:SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child:FieldSet(title: "Courses", child: Column(
                children: [
                  buildCheckboxTileMain(
                    context: context,
                    mainHeading: "Class/Course",
                    subHeading: "Send Sms to Student",
                    item: "Select All",
                    isChecked: courseChecked,
                    onChanged: (value) {
                      setState(() {
                        if(value==true){
                          (cmposeSMSConfiguration?.courseList ?? []).forEach((item) {
                            selectedCourseIds.add(item.Id.toString());
                          });
                          courseChecked=true;
                        }else{
                          courseChecked=false;
                          selectedCourseIds=[];
                        }
                      });
                    },
                  ),
                  const Divider(),

                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: (cmposeSMSConfiguration?.courseList ?? []).map((item) {
                        return buildCheckboxTile(
                          context: context,
                          item: item.value,
                          isChecked: courseChecked || selectedCourseIds.contains(item.Id.toString()),
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                selectedCourseIds.add(item.Id.toString());
                              } else {
                                selectedCourseIds.remove(item.Id.toString());
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                ],
              )),
            ),

              // Designation Section Start Here
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child:FieldSet(title: "Designation", child: Column(
                  children: [
                    buildCheckboxTileMain(
                      context: context,
                      mainHeading: "Designation",
                      subHeading: "Send Sms to Staff/Employee",
                      item: "Select All",
                      isChecked: designationChecked,
                      onChanged: (value) {
                        setState(() {
                          if(value==true){
                            (cmposeSMSConfiguration?.designationList ?? []).forEach((item) {
                              selectedDesignationIds.add(item.Id.toString());
                            });
                            designationChecked=true;
                          }else{
                            selectedDesignationIds=[];
                            designationChecked=false;
                          }
                        });
                      },
                    ),
                    const Divider(),

                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: (cmposeSMSConfiguration?.designationList ?? []).map((item) {
                          return buildCheckboxTile(
                            context: context,
                            item: item.value,
                            isChecked: designationChecked || selectedDesignationIds.contains(item.Id.toString()),
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {

                                  selectedDesignationIds.add(item.Id.toString());
                                } else {
                                  selectedDesignationIds.remove(item.Id.toString());
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),

                  ],
                )),
              ),



              // User Copy Section Start Here
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child:FieldSet(title: "Administration", child: Column(
                  children: [
                    buildCheckboxTileMain(
                      context: context,
                      mainHeading: "Administration",
                      subHeading: "Send Sms copy to Administration",
                      item: "Select All",
                      isChecked: administrationChecked,
                      onChanged: (value) {
                        setState(() {
                          if(value==true){
                            (cmposeSMSConfiguration?.userCopy ?? []).forEach((item) {
                              selectedAdminstration.add(item.id.toString());
                            });
                            administrationChecked=true;
                          }else{
                            selectedAdminstration=[];
                            administrationChecked=false;
                          }
                        });
                      },
                    ),
                    const Divider(),

                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: (cmposeSMSConfiguration?.userCopy ?? []).map((item) {
                          return buildCheckboxTile(
                            context: context,
                            item: '${item.name} ${item.contactNo}',
                            isChecked: administrationChecked || selectedAdminstration.contains(item.id.toString()),
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  selectedAdminstration.add(item.id.toString());
                                } else {
                                  selectedAdminstration.remove(item.id.toString());
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),

                  ],
                )),
              )
              ],
          ),
        ),


      ),
      ),
      bottomNavigationBar: Padding(padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
      child: CustomBlueButton(text: 'Continue', icon: Icons.arrow_forward, onPressed: () async{
        await sendToPreviewPage();
      }),),
    );
  }
}



Widget buildCheckboxTile({
  required BuildContext context,
  required String item,
  required bool isChecked,
  required Function(bool?) onChanged,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  double tileWidth;

  if (screenWidth > 800) {
    tileWidth = (screenWidth / 4) - 20;
  } else if (screenWidth > 600) {
    tileWidth = (screenWidth / 3) - 20;
  } else {
    tileWidth = (screenWidth / 2) - 30;
  }

  return Container(
    width: tileWidth,
    height: 40,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(width: 1, color: Colors.grey),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: onChanged,
        ),
        Flexible(child: Text(item, overflow: TextOverflow.ellipsis)),
      ],
    ),
  );
}


Widget buildCheckboxTileMain({
  required BuildContext context,
  required String mainHeading,
  required String subHeading,
  required String item,
  required bool isChecked,
  required Function(bool?) onChanged,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  double tileWidth;

  if (screenWidth > 800) {
    tileWidth = (screenWidth / 4) - 20;
  } else if (screenWidth > 600) {
    tileWidth = (screenWidth / 3) - 20;
  } else {
    tileWidth = (screenWidth / 2) - 10;
  }
  return
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: Colors.grey),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: onChanged,
              ),
              Expanded(child: Text(item, overflow: TextOverflow.ellipsis)),

            ],
          )
        );
}

