import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/AddStaffModel.dart';
import 'package:digivity_admin_app/ApisController/AddStaffFormData.dart';
import 'package:digivity_admin_app/ApisController/StaffApis.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:digivity_admin_app/Components/FieldSet.dart';
import 'package:digivity_admin_app/Components/GenderDropDown.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:flutter/material.dart';


class AddStaffForm extends StatefulWidget {
  @override
  State<AddStaffForm> createState() => _AddStaffForm();
}

class _AddStaffForm extends State<AddStaffForm> {
  AddStaffModel? staffformdata;

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _employeeno = TextEditingController();
  final _joiningdate = TextEditingController();
  final _retiredate = TextEditingController();
  final _staffname = TextEditingController();
  final _dob = TextEditingController();
  final _fathername = TextEditingController();
  final _spousename = TextEditingController();
  final _contactno = TextEditingController();
  final _aadhaarno = TextEditingController();
  final _panno = TextEditingController();
  final _address = TextEditingController();
  final _accountno = TextEditingController();
  final _ifsccode = TextEditingController();
  final _bankname = TextEditingController();
  int? selectedProfessionTypeId;
  int? selectedStaffTypeId;
  int? selectedDepartmentId;
  int? selectedDesignationId;
  String? selectedTitleId;
  String? selectedMaritalStatusId;
  String? selectedGender;

  final List<Map<String, String>> genderOptions = [
    {'id': 'male', 'gender': 'Male'},
    {'id': 'female', 'gender': 'Female'},
    {'id': 'transgender', 'gender': 'Transgender'},
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
    final staffdata = await Addstaffformdata().getStaffFormData();
    setState(() {
      staffformdata = staffdata;
    });
    hideLoaderDialog(context);
  }

  @override
  void dispose() {
    _employeeno.dispose();
    _joiningdate.dispose();
    _retiredate.dispose();
    _staffname.dispose();
    _dob.dispose();
    _fathername.dispose();
    _spousename.dispose();
    _contactno.dispose();
    _aadhaarno.dispose();
    _panno.dispose();
    _address.dispose();
    _accountno.dispose();
    _ifsccode.dispose();
    _bankname.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: "Add New Student", routeName: 'back'),
      ),
      body: BackgroundWrapper(
        child: CardContainer(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  FieldSet(
                    title: 'Profession Information',
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'Employee No',
                          hintText: 'Enter Employee No..',
                          controller: _employeeno,
                          validator: (value) => value == null || value.isEmpty ? "Please enter the Emp No" : null,
                        ),
                        const SizedBox(height: 20),
                        DatePickerField(controller: _joiningdate, label: 'Joining Date'),
                        const SizedBox(height: 20),
                        DatePickerField(controller: _retiredate, label: 'Retire Date'),
                        const SizedBox(height: 20),
                        buildDropdown(
                          items: staffformdata?.professiontype,
                          displayKey: 'value',
                          valueKey: 'id',
                          hint: 'Profession Type',
                          error: 'Please select the Profession Type',
                          onChange: (value){
                            selectedProfessionTypeId = value;
                            setState(() {

                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        buildDropdown(
                          items: staffformdata?.stafftype,
                          displayKey: 'value',
                          valueKey: 'id',
                          hint: 'Staff Type',
                          error: 'Please select Staff Type',
                          onChange: (value){
                            selectedStaffTypeId = value;
                            setState(() {

                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        buildDropdown(
                          items: staffformdata?.department,
                          displayKey: 'value',
                          valueKey: 'id',
                          hint: 'Department Type',
                          error: 'Please select Department Type',
                          onChange: (value){
                            selectedDepartmentId = value;
                            setState(() {

                            });
                          }
                        ),
                        const SizedBox(height: 20),
                        buildDropdown(
                          items: staffformdata?.designation,
                          displayKey: 'value',
                          valueKey: 'id',
                          hint: 'Designation Type',
                          error: 'Please select Designation Type',
                          onChange: (value){
                            selectedDesignationId = value;
                            setState(() {

                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FieldSet(
                    title: 'Personal Information',
                    child: Column(
                      children: [
                        buildDropdown(
                          items: staffformdata?.title,
                          displayKey: 'value',
                          valueKey: 'id',
                          hint: 'Title',
                          error: 'Please select Title',
                          onChange: (value) {
                            selectedTitleId = value;
                            setState(() {

                            });
                          }
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Staff Name',
                          hintText: 'Enter Staff Name',
                          controller: _staffname,
                          validator: (value) => value == null || value.isEmpty ? "Please enter Staff Name" : null,
                        ),
                        const SizedBox(height: 20),
                        Genderdropdown(
                          value: selectedGender,
                          onChanged: (value) {
                            selectedGender = value;
setState(() {

});
                          },
                          validator: (value) {
                            final val = value as String?;
                            return val == null ? 'Please select gender' : null;
                          },
                        ),

                        const SizedBox(height: 20),
                        DatePickerField(controller: _dob, label: 'Date Of Birth'),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Father Name',
                          hintText: 'Enter Staff Father Name',
                          controller: _fathername,
                          validator: (value) => value == null || value.isEmpty ? "Please enter Father Name" : null,
                        ),
                        const SizedBox(height: 20),
                        buildDropdown(
                          items: staffformdata?.maritalstatus,
                          displayKey: 'value',
                          valueKey: 'id',
                          hint: 'Marital Status',
                          error: 'Please select Marital Status',
                          onChange: (value) {
                            selectedMaritalStatusId = value;
                          setState(() {

                          });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FieldSet(
                    title: 'Contact Information',
                    child: Column(
                      children: [
                        CustomTextField(label: 'Spouse Name', hintText: 'Enter Spouse Name', controller: _spousename),
                        const SizedBox(height: 20),
                        CustomTextField(
                            validator: (value) => value == null || value.isEmpty ? "Please enter the Contact No" : null,
                            label: 'Contact No', hintText: 'Enter Contact No', controller: _contactno),
                        const SizedBox(height: 20),
                        CustomTextField(
                            validator: (value) => value == null || value.isEmpty ? "Please enter the Aadhaar No" : null,
                            label: 'Aadhaar No', hintText: 'Enter Aadhaar No', controller: _aadhaarno),
                        const SizedBox(height: 20),
                        CustomTextField(label: 'Pan No', hintText: 'Enter Pan No', controller: _panno),
                        const SizedBox(height: 20),
                        CustomTextField(
                            validator: (value) => value == null || value.isEmpty ? "Please enter the Address " : null,
                            label: 'Address', hintText: 'Enter Address', controller: _address),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FieldSet(
                    title: 'Account Information',
                    child: Column(
                      children: [
                        CustomTextField(label: 'Account No', hintText: 'Enter Account No', controller: _accountno),
                        const SizedBox(height: 20),
                        CustomTextField(label: 'IFSC Code', hintText: 'Enter IFSC Code', controller: _ifsccode),
                        const SizedBox(height: 20),
                        CustomTextField(label: 'Bank Name', hintText: 'Enter Bank Name', controller: _bankname),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomBlueButton(
          text: 'Save',
          icon: Icons.save,
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              submitForm();// Submit form logic
            }
          },
        ),
      ),
    );
  }

  Widget buildDropdown({
    required List<dynamic>? items,
    required String displayKey,
    required String valueKey,
    required String hint,
    required String error,
    required Function(dynamic) onChange,
  }) {
    return CustomDropdown(
      items: items?.map((e) => {valueKey: e.id, displayKey: e.value}).toList() ?? [],
      displayKey: displayKey,
      valueKey: valueKey,
      hint: hint,
      validator: (value) => value == null ? error : null,
      onChanged: onChange,
    );
  }
  void resetForm() {
    // Clear all text controllers
    _employeeno.clear();
    _joiningdate.clear();
    _retiredate.clear();
    _staffname.clear();
    _dob.clear();
    _contactno.clear();
    _aadhaarno.clear();
    _panno.clear();
    _fathername.clear();
    _spousename.clear();
    _address.clear();
    _accountno.clear();
    _ifsccode.clear();
    _bankname.clear();

    // Reset dropdown or selected values
    selectedProfessionTypeId = null;
    selectedStaffTypeId = null;
    selectedDepartmentId = null;
    selectedDesignationId = null;
    selectedTitleId = null;
    selectedGender = null;
    selectedMaritalStatusId = null;

    // If you're using setState (in a StatefulWidget), call it to update the UI
    setState(() {});
  }


  void submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Safely split staff name

      final formData = {
        "emp_no":_employeeno.text.toString() ?? '',
        'joining_date': _joiningdate.text.toString() ?? '',
        'date_of_retire': _retiredate.text.toString() ?? '',
        'staff_no': _employeeno.text.toString() ?? '',
        'profession_type_id': selectedProfessionTypeId ?? '',
        'staff_type_id': selectedStaffTypeId ?? '',
        'department_id': selectedDepartmentId ?? '',
        'designation_id': selectedDesignationId ?? '',
        'title': selectedTitleId ?? '',
        'first_name': _staffname.text.toString() ?? '',
        'gender': selectedGender?.toLowerCase() ?? '',
        'dob': _dob.text.toString() ?? '',
        'contact_no': _contactno.text.toString() ?? '',
        'aadhaar_no': _aadhaarno.text.toString() ?? '',
        'pan_no': _panno.text.toString() ?? '',
        'father_name': _fathername.text.toString() ?? '',
        'marital_status': selectedMaritalStatusId.toString() ?? '',
        'spouse_name': _spousename.text ?? '',
        'residence_address': _address.text.toString() ?? '',
        'account_number': _accountno.text.toString() ?? '',
        'ifsc_code': _ifsccode.text.toString() ?? '',
        'bank_name': _bankname.text.toString() ?? '',
      };

      showLoaderDialog(context);

      try {
        final response = await StaffApis().submitStaffData(formData);
        resetForm();
        hideLoaderDialog(context);
        if (response['result'] == 1) {
          showBottomMessage(context, response['message'], false);
        } else {
          showBottomMessage(context, response['message'], true);
        }
      } catch (e) {
        hideLoaderDialog(context);
        showBottomMessage(context, "Something went wrong: $e", true);
      }
    } else {
      showBottomMessage(context, 'Please fill all required fields', true);
    }
  }


}



