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


class UpdateStaffProfile extends StatefulWidget {

  final String? staffId;
  UpdateStaffProfile({ required this.staffId});

  @override
  State<UpdateStaffProfile> createState() => _UpdateStaffProfile();
}

class _UpdateStaffProfile extends State<UpdateStaffProfile> {
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


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showLoaderDialog(context, message: "Fetching data...");
      await getData();          // Load dropdowns
      await getStudentData();
    });
  }


  Future<void> getData() async {
    final staffdata = await Addstaffformdata().getStaffFormData();
    setState(() {
      staffformdata = staffdata;
    });
    hideLoaderDialog(context);
  }


  Future<void> getStudentData() async {
    try {
      final staff = await StaffApis().getStaffUpdateData(widget.staffId);

      if (staff != null) {
        setState(() {
          _employeeno.text = staff.staffNo ?? '';
          _joiningdate.text = staff.joiningDate;
          _retiredate.text = staff.dateOfRetire ?? '';
          _staffname.text = staff.firstName;
          _dob.text = staff.dob;
          _fathername.text = staff.fatherName;
          _spousename.text = staff.spouseName ?? '';
          _contactno.text = staff.contactNo;
          _aadhaarno.text = staff.aadhaarNo ?? '';
          _panno.text = staff.panNo ?? '';
          _address.text = staff.residenceAddress ?? '';
          _accountno.text = staff.accountNumber ?? '';
          _ifsccode.text = staff.ifscCode ?? '';
          _bankname.text = staff.bankName ?? '';

          // Dropdown values
          selectedProfessionTypeId = staff.professionTypeId;
          selectedStaffTypeId = staff.staffTypeId;
          selectedDepartmentId = staff.departmentId;
          selectedDesignationId = staff.designationId;
          selectedTitleId = staff.title;
          selectedGender = staff.gender?.toLowerCase();
          selectedMaritalStatusId = staff.maritalStatus;
        });
      }
    } catch (e) {
      hideLoaderDialog(context);
      print("Error fetching student data: $e");
      showBottomMessage(context, "Failed to load student data.", true);
    }
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: "Update Staff Profile", routeName: 'back'),
      ),
      body: BackgroundWrapper(
        child: CardContainer(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
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
                          selectedValue:selectedProfessionTypeId,
                          hint: 'Profession Type',
                          error: 'Please select the Profession Type',
                          onChange: (value) {
                            selectedProfessionTypeId = value;
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 20),
                        buildDropdown(
                          items: staffformdata?.stafftype,
                          displayKey: 'value',
                          valueKey: 'id',
                          hint: 'Staff Type',
                          selectedValue:selectedStaffTypeId,
                          error: 'Please select Staff Type',
                          onChange: (value) {
                            selectedStaffTypeId = value;
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 20),
                        buildDropdown(
                          items: staffformdata?.department,
                          displayKey: 'value',
                          valueKey: 'id',
                          hint: 'Department Type',
                          selectedValue:selectedDepartmentId,
                          error: 'Please select Department Type',
                          onChange: (value) {
                            selectedDepartmentId = value;
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 20),
                        buildDropdown(
                          items: staffformdata?.designation,
                          displayKey: 'value',
                          valueKey: 'id',
                          selectedValue:selectedDesignationId,
                          hint: 'Designation Type',
                          error: 'Please select Designation Type',
                          onChange: (value) {
                            selectedDesignationId = value;
                            setState(() {});
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
                          selectedValue:selectedTitleId,
                          error: 'Please select Title',
                          onChange: (value) {
                            selectedTitleId = value;
                            setState(() {});
                          },
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
                            setState(() {});
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
                          selectedValue:selectedMaritalStatusId,
                          error: 'Please select Marital Status',
                          onChange: (value) {
                            selectedMaritalStatusId = value;
                            setState(() {});
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
                          label: 'Contact No',
                          hintText: 'Enter Contact No',
                          controller: _contactno,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Aadhaar No',
                          hintText: 'Enter Aadhaar No',
                          controller: _aadhaarno,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(label: 'Pan No', hintText: 'Enter Pan No', controller: _panno),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Address',
                          hintText: 'Enter Address',
                          controller: _address,
                        ),
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
        padding: const EdgeInsets.all(15),
        child: CustomBlueButton(
          text: 'Save',
          icon: Icons.save,
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              submitForm(); // Submit form logic
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
    dynamic selectedValue, // Add this
  }) {
    return CustomDropdown(
      items: items?.map((e) => {valueKey: e.id, displayKey: e.value}).toList() ?? [],
      displayKey: displayKey,
      valueKey: valueKey,
      hint: hint,
      value: selectedValue, // Set selected value here
      validator: (value) => value == null ? error : null,
      onChanged: onChange,
    );
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
        final response = await StaffApis().updateStaffRecord(widget.staffId,formData);
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



