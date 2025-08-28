import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/AddStudentModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentUpdateDataModel.dart';
import 'package:digivity_admin_app/ApisController/AddStudentFormData.dart';
import 'package:digivity_admin_app/ApisController/StudentApis.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CourseComponent.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:digivity_admin_app/Components/FieldSet.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/CommonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditStudentDetails extends StatefulWidget {

  final String? studentId;
  EditStudentDetails({required this.studentId});

  @override
  State<EditStudentDetails> createState() => _EditStudentDetails();
}

class _EditStudentDetails extends State<EditStudentDetails> {
  final _formkey= GlobalKey<FormState>();

  StudentDataModel? studentformdata;
  StudentUpdateDataModel? existingStudentData;
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
      await getStudentData();
      hideLoaderDialog(context);
    }
  }

  Future<void> getStudentData() async {
    try {
      showLoaderDialog(context);
      final studentdata = await StudentApis().getStudentUpdateData(widget.studentId);
      setState(() {
        existingStudentData = studentdata;

        // 🧠 Now populate the form fields
        _AdmissionController.text = studentdata.admissionNo;
        _FormSRNo.text = studentdata.formNo ?? '';
        studentcategory = studentdata.caste != null ? int.tryParse(studentdata.caste!) : null;
        studentCourse = studentdata.courseId;
        selectedTransportId = studentdata.transportId;
        _admissionDateController.text = studentdata.admissionDate;
        _studentName.text = studentdata.firstName;
        studentgender = studentdata.gender;
        _studentDob.text = studentdata.dob;
        _smscontact.text = studentdata.contactNo;
        _mothercontact.text = studentdata.altContactNo ?? '';
        _studentfather.text = studentdata.fatherName;
        _studentmother.text = studentdata.motherName;
        _address.text = studentdata.residenceAddress;
        studentbloodgroup = studentdata.bloodGroup;
        studenthouse = studentdata.houseId;
        admissionType = studentdata.admissionTypeId;
        categoryType = studentdata.categoryId;
      });

      hideLoaderDialog(context);
    } catch (e) {
      hideLoaderDialog(context);
      print("Error fetching student data: $e");
      showBottomMessage(context, "Failed to load student data.", true);
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
        child: SimpleAppBar(titleText: "Edit Student Details", routeName: 'back'),
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
                    initialValue: studentCourse,
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
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            SizedBox(
                              width: fieldWidth,
                              child: CustomTextField(
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
                            ),
                            SizedBox(
                              width: fieldWidth,
                              child: CustomTextField(
                                label: 'Form.SR No.',
                                hintText: 'Please Enter Form/SR No.',
                                controller: _FormSRNo,

                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            SizedBox(
                              width: fieldWidth,
                              child: CustomDropdown(
                                items: studentformdata?.admType.map((e) => {
                                  'id': e.id,
                                  'admission_type': e.admission_type,
                                }).toList() ?? [],
                                displayKey: 'admission_type',
                                valueKey: 'id',
                                selectedValue: admissionType,
                                validator: (value) {
                                  if (value == null) return "Please Select Student Admission Type";
                                  return null;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    admissionType = val;
                                  });
                                },
                                hint: 'Adm. Type',
                              ),
                            ),
                            SizedBox(
                              width: fieldWidth,
                              child: CustomDropdown(
                                items: studentformdata?.studenttype.map((e) => {
                                  'id': e.type_id,
                                  'type_name': e.type_name,
                                }).toList() ?? [],
                                displayKey: 'type_name',
                                valueKey: 'id',
                                selectedValue: categoryType,
                                validator: (value) {
                                  if (value == null) return "Please Select Student Type";
                                  return null;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    categoryType = val;
                                  });
                                },
                                hint: 'Adm Category',
                              ),
                            ),
                          ],
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
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            SizedBox(
                              width: fieldWidth,
                              child: CustomDropdown(
                                items: genderOptions,
                                displayKey: 'gender',
                                valueKey: 'id',
                                selectedValue: studentgender,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Please Select Student Gender Type";
                                  }
                                  return null;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    studentgender = val;
                                  });
                                },
                                hint: 'Select Gender',
                              ),
                            ),
                            DatePickerField(
                              controller: _admissionDateController,
                              label: 'Admission Date',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Student Admission Date.";
                                }
                                return null;
                              },
                            ),
                            DatePickerField(
                              controller: _studentDob,
                              label: 'Student DOB',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Student Date of Birth.";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              width: fieldWidth,
                              child: CustomDropdown(
                                items: studentformdata?.category.map((e) => {
                                  'id': e.id,
                                  'category': e.category,
                                }).toList() ?? [],
                                displayKey: 'category',
                                valueKey: 'id',
                                selectedValue: studentcategory,
                                validator: (value) {
                                  if (value == null) return "Please Select Student Admission Category";
                                  return null;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    studentcategory = val;
                                  });
                                },
                                hint: 'Category',
                              ),
                            ),
                          ],
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
                        SizedBox(
                          width: fieldWidth,
                          child: CustomDropdown(
                            items: studentformdata?.house.map((e) => {
                              'id': e.id,
                              'house': e.house,
                            }).toList() ?? [],
                            displayKey: 'house',
                            valueKey: 'id',
                            selectedValue: studenthouse,
                            onChanged: (val) {
                              setState(() {
                                studenthouse = val;
                              });
                            },
                            hint: 'House',
                          ),
                        ),
                        SizedBox(
                          width: fieldWidth,
                          child: CustomDropdown(
                            items: bloodgroups,
                            displayKey: 'blood_group',
                            valueKey: 'id',
                            selectedValue: studentbloodgroup,
                            onChanged: (val) {
                              setState(() {
                                studentbloodgroup = val;
                              });
                            },
                            hint: 'Select Blood Group',
                          ),
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
                          selectedValue: selectedTransportId,
                          onChanged: (val) {
                            setState(() {
                              selectedTransportId = val;
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
              var response=await StudentApis().updateStudentRecord(widget.studentId,studentData);
              hideLoaderDialog(context);
              if(response['result']==1){
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
