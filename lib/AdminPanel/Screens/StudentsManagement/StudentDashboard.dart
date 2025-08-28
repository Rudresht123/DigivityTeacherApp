import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/AddStudentModel.dart';
import 'package:digivity_admin_app/ApisController/AddStudentFormData.dart';
import 'package:digivity_admin_app/ApisController/StudentApis.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/FieldSet.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:flutter/material.dart';

class StudentDashboard extends StatefulWidget {
  @override
  State<StudentDashboard> createState() => _StudentDashboard();
}

class _StudentDashboard extends State<StudentDashboard> {
  final _formkey= GlobalKey<FormState>();

  StudentDataModel? studentformdata;
  int? admissionType;
  int? categoryType;
  String? studentgender;
  int? studentcategory;
  int? studenthouse;
  String? studentbloodgroup;
  String? studentCourse;
  int? selectedTransportId;

  final TextEditingController _AdmissionController = TextEditingController();
  final TextEditingController _FormSRNo = TextEditingController();
  final TextEditingController _studentName = TextEditingController();
  final TextEditingController _smscontact = TextEditingController();
  final TextEditingController _aadhaar = TextEditingController();
  final TextEditingController _studentfather = TextEditingController();
  final TextEditingController _fathercontact = TextEditingController();
  final TextEditingController _studentmother = TextEditingController();
  final TextEditingController _mothercontact = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _admissionDateController=TextEditingController();
  final TextEditingController _studentDob=TextEditingController();

  final List<Map<String, String>> genderOptions = [
    {'id': 'male', 'gender': 'Male'},
    {'id': 'female', 'gender': 'Female'},
    {'id': 'transgender', 'gender': 'Transgender'},
  ];

  final List<Map<String, String>> bloodgroups = [
    {'id': 'A+', 'blood_group': 'A+'},
    {'id': 'A-', 'blood_group': 'A-'},
    {'id': 'B+', 'blood_group': 'B+'},
    {'id': 'B-', 'blood_group': 'B-'},
    {'id': 'O+', 'blood_group': 'O+'},
    {'id': 'O-', 'blood_group': 'O-'},
    {'id': 'AB+', 'blood_group': 'AB+'},
    {'id': 'AB-', 'blood_group': 'AB-'},
    {'id': 'other', 'blood_group': 'Other'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoaderDialog(context, message: "Fetching data...");
      getData();
    });
  }

  Future<void> getData() async {
    final studentadddata = await AddStudentFormData().getStudentFormData();
    if (studentadddata != null) {
      setState(() {
        studentformdata = studentadddata;
        _AdmissionController.text = studentadddata.admissionNo;
      });
      hideLoaderDialog(context);
    }
  }
  void resetStudentForm() {
    _formkey.currentState?.reset();

    // Clear controllers
    _AdmissionController.clear();
    _FormSRNo.clear();
    _studentName.clear();
    _smscontact.clear();
    _aadhaar.clear();
    _studentfather.clear();
    _fathercontact.clear();
    _studentmother.clear();
    _mothercontact.clear();
    _address.clear();
    _admissionDateController.clear();
    _studentDob.clear();

    // Reset state dropdowns & other fields
    setState(() {
      admissionType = null;
      categoryType = null;
      studentgender = null;
      studentcategory = null;
      studenthouse = null;
      studentbloodgroup = null;
      studentCourse = null;
      selectedTransportId = null;
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final double fieldWidth = isSmallScreen ? screenWidth : (screenWidth - 52) / 2;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: "Add New Student", routeName: 'back'),
      ),
      body: SingleChildScrollView(
        child: CardContainer(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formkey,
            child: Column(
            children: [
              SizedBox(height: 20),
              CourseComponent(
                initialValue: '',
                  validator: (value) {
                    if (value == null) {
                      return "Please Select Course";
                    }
                    return null;
                  },
                onChanged: (val) {
                  studentCourse=val;
                  setState(() {

                  });
                },
              ),
              SizedBox(height: 20),
              FieldSet(
                title: "Admission Details",
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Admission No.',
                      hintText: 'Please Enter Admission No.',
                      validator: (value) {
                        if (value == null) {
                          return "Please Enter The Student Admission No";
                        }
                        return null;
                      },
                      controller: _AdmissionController,
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      label: 'Form.SR No.',
                      hintText: 'Please Enter Form/SR No.',
                      controller: _FormSRNo,

                    ),

                    SizedBox(height: 20),
                    CustomDropdown(
                      items: studentformdata?.admType.map((e) => {
                        'id': e.id,
                        'admission_type': e.admission_type,
                      }).toList() ?? [],
                      displayKey: 'admission_type',
                      valueKey: 'id',
                      validator:(value){
                        if (value == null) {
                          return "Please Select Student Admission Type";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          admissionType=val;
                        });

                      },
                      hint: 'Adm. Type',
                    ),
                    SizedBox(height: 20),
                    CustomDropdown(
                      items: studentformdata?.studenttype.map((e) => {
                        'id': e.type_id,
                        'type_name': e.type_name,
                      }).toList() ?? [],
                      displayKey: 'type_name',
                      valueKey: 'id',
                      validator:(value){
                        if (value == null) {
                          return "Please Select Student Student Type";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        categoryType=val;
                        setState(() {

                        });
                      },
                      hint: 'Adm Category',
                    ),
                      ],

                ),
              ),
              SizedBox(height: 20),
              FieldSet(
                title: "Student Information",
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Student Name',
                      hintText: 'Please Enter Student Name..',
                      validator:(value){
                        if (value == null || value.trim().isEmpty) {
                          return "Please Enter Student Name";
                        }
                        return null;
                      },
                      controller: _studentName,
                    ),
                    SizedBox(height: 20),
                    CustomDropdown(
                      items: genderOptions,
                      displayKey: 'gender',
                      valueKey: 'id',
                      validator:(value){
                        if (value == null || value.trim().isEmpty) {
                          return "Please Select Student Gender Type";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        studentgender=val;
                        setState(() {

                        });
                      },
                      hint: 'Select Gender',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              FieldSet(
                title: "Other Details",
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    CustomDropdown(
                      items: studentformdata?.house.map((e) => {
                        'id': e.id,
                        'house': e.house,
                      }).toList() ?? [],
                      displayKey: 'house',
                      valueKey: 'id',
                      onChanged: (val) {
                        studenthouse=val;
                        setState(() {

                        });
                      },
                      hint: 'House',
                    ),
                    CustomDropdown(
                      items: bloodgroups,
                      displayKey: 'blood_group',
                      valueKey: 'id',
                      onChanged: (val) {
                        studentbloodgroup=val;
                        setState(() {

                        });
                      },
                      hint: 'Select Blood Group',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              FieldSet(
                title: "Contact Information",
                child: Column(
                  children: [
                    CustomTextField(label: 'SMS Contact No.', hintText: 'Enter SMS Contact No.', controller: _smscontact,
                      validator:(value){
                        if (value == null || value.trim().isEmpty) {
                          return "Please Enter Student SMS Contact No.";
                        }
                        return null;
                      },),
                    SizedBox(height: 20),
                    CustomTextField(label: 'Student Aadhaar No.', hintText: 'Enter Student Aadhaar No.', controller: _aadhaar),
                    SizedBox(height: 20),
                    CustomTextField(label: 'Father Name', hintText: 'Enter Student Father Name', controller: _studentfather,
                      validator:(value){
                        if (value == null || value.trim().isEmpty) {
                          return "Please Enter Student Father Name";
                        }
                        return null;
                      },),
                    SizedBox(height: 20),
                    CustomTextField(label: 'Father No.', hintText: 'Enter Student Father No.', controller: _fathercontact),
                    SizedBox(height: 20),
                    CustomTextField(label: 'Mother Name.', hintText: 'Enter Student Mother Name.', controller: _studentmother),
                    SizedBox(height: 20),
                    CustomTextField(label: 'Mother No.', hintText: 'Enter Student Mother No.', controller: _mothercontact),
                    SizedBox(height: 20),
                    CustomDropdown(
                      items: studentformdata?.transport.map((e) => {
                        'route_id': e.route_id,
                        'route_name': e.route_name,
                      }).toList() ?? [],
                      displayKey: 'route_name',
                      valueKey: 'route_id',
                      onChanged: (val) {
                        selectedTransportId=val;
                        setState(() {

                        });
                      },
                      hint: 'Transport Route',
                    ),
                  ],
                ),
              ),
            ],
          ),)
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: CustomBlueButton(
          text: "Save",
          icon: Icons.save,
          onPressed: () async{

            showLoaderDialog(context);
            if(_formkey.currentState!.validate()){

              final studentData = {
                'admission_no': _AdmissionController.text.trim(),
                'form_no': _FormSRNo.text.trim(),
                'caste': studentcategory, // caste => category_id
                'course_id': studentCourse,
                'transport_id': selectedTransportId,
                'admission_date': _admissionDateController.text.trim(),
                'first_name': _studentName.text.trim(),
                'gender': studentgender?.toLowerCase(),
                'dob': _studentDob.text.trim(),
                'contact_no': _smscontact.text.trim(),
                'alt_contact_no': _mothercontact.text.trim(),
                'father_name': _studentfather.text.trim(),
                'mother_name': _studentmother.text.trim(),
                'residence_address': _address.text.trim(),

                // ✅ New fields added
                'blood_group': studentbloodgroup,
                'student_house': studenthouse,
                'admission_type': admissionType,
                'student_type': categoryType,
              };
              var response=await StudentApis().submitStudentData(studentData);
              hideLoaderDialog(context);
              if(response['result']==1){
                resetStudentForm();
                showBottomMessage(context, response['message'], false);
              }
              else{
                showBottomMessage(context, response['message'], true);
              }

            }
            else{
              showBottomMessage(context, 'Please Fill All Required Field', true);
            }
          },
        ),
      ),
    );
  }
}
