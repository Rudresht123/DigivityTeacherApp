import 'package:digivity_admin_app/AdminPanel/Models/Studdent/UpdateFieldList.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/ShortByDropdown.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Components/StatusDropDown.dart';
import 'package:digivity_admin_app/Components/StudentSortBy.dart';
import 'package:digivity_admin_app/helpers/StudentsData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FieldUpdateStudentListSearch extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _FieldUpdateStudentListSearch();
  }
}
class _FieldUpdateStudentListSearch extends State<FieldUpdateStudentListSearch>{
  List<UpdateFieldList>? fieldListdata = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedCourseId;
  String? shortByMethod;
  String? orderByMethod;
  String? selectedStatus;
  String? selectedField;

  @override
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fetchfieldlist();
    });
  }

  void _fetchfieldlist() async{
    showLoaderDialog(context);
    final response =await StudentsData().getFieldsForUpdate();
    setState(() {
      fieldListdata = response;
     });
    hideLoaderDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: SimpleAppBar(titleText: 'Student Field Updation', routeName: 'back')),
      body: BackgroundWrapper(child: SingleChildScrollView(child: Column(
        children: [
          CardContainer(child: Form(
              key: _formKey,
              child: Column(
            children: [
              CourseComponent(
                onChanged: (value){
                  selectedCourseId=value;
                  setState(() {

                  });
                },
                validator: (selectedCourseId) {
                  if (selectedCourseId == null || selectedCourseId.isEmpty) {
                    return "Please select a course";
                  }
                  return null;
                },

              ),

              SizedBox(height: 20,),
              ShortByDropdown(
                label : 'Sort By',
                onChanged: (value){
                  shortByMethod=value;
                  setState(() {

                  });
                },
              ),
              SizedBox(height: 20,),
              Studentsortby(
                lable: 'Sort By Type',
                onChanged: (value){
                  orderByMethod=value;
                  setState(() {

                  });
                },
              ),
              SizedBox(height: 20,),
              Statusdropdown(
                label : 'Status',
                onChange: (value){
                  selectedStatus=value;
                  setState(() {

                  });
                },
              ),
              SizedBox(height: 20,),
              CustomDropdown(
                items: fieldListdata!.map((item) {
                  return {
                    'id': item.fieldId,
                    'fieldName': item.fieldName,
                  };
                }).toList(),
                displayKey: 'fieldName',
                valueKey: 'id',
                onChanged: (value) {
                  selectedField=value;
                  setState(() {

                  });
                },
                validator: (selectField){
                  if(selectField==null){
                    return "Please Select First Field";
                  }
                },
                hint: 'Select Field Name',
              )
            ],
          )))
        ],
      ),)),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
        child: CustomBlueButton(text: 'Update Date', icon: Icons.save, onPressed: (){
          if(_formKey.currentState!.validate()){
            context.pushNamed(
                'student-field-update-list',
                extra: {
                  'selectedCourseId': selectedCourseId,
                  'shortByMethod': shortByMethod,
                  'orderByMethod': orderByMethod,
                  'selectedStatus': selectedStatus,
                  'selectedField': selectedField
                }
            );
            }
        }),
      ),
    );
  }
}