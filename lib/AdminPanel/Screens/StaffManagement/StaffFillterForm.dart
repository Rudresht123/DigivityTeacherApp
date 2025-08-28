import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/AddStaffModel.dart';
import 'package:digivity_admin_app/ApisController/AddStaffFormData.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Components/StaffSearchBy.dart';
import 'package:digivity_admin_app/Components/StaffShortBy.dart';
import 'package:digivity_admin_app/Components/StatusDropDown.dart';
import 'package:digivity_admin_app/Components/StudentSortBy.dart';
import 'package:digivity_admin_app/Providers/StaffDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class StaffFilterForm extends StatefulWidget{

  @override
  State<StaffFilterForm> createState() {
    return _StaffFilterForm();
  }
}

class _StaffFilterForm extends State<StaffFilterForm> {
  AddStaffModel? staffformdata;
  int? selectedProfessionTypeId;
  int? selectedStaffTypeId;
  int? selectedDepartmentId;
  int? selectedDesignationId;
  String? shortBy;
  String? shortByType;
  String? status;
  String? searchBy;

  final _formKey = GlobalKey<FormState>();


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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight),
          child: SimpleAppBar(titleText: 'Staff List', routeName: 'back')),
      body: BackgroundWrapper(child: CardContainer(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildDropdown(
                  items: staffformdata?.professiontype,
                  displayKey: 'value',
                  valueKey: 'id',
                  hint: 'Profession Type',
                  error: 'Please select the Profession Type',
                  onChange: (value) {
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
                  onChange: (value) {
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
                    onChange: (value) {
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
                  onChange: (value) {
                    selectedDesignationId = value;
                    setState(() {

                    });
                  },
                ),
                const SizedBox(height: 20),
                StaffSearchBy(
                  lable: 'Staff Search By',
                  onChanged: (value) {
                    searchBy = value;
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),
                Staffshortby(
                  lable: 'Search By',
                  onChanged: (value) {
                    shortBy = value;
                    setState(() {

                    });
                  },
                ),
                const SizedBox(height: 20),
                Studentsortby(
                  lable: "Sort By Type",
                  onChanged: (value) {
                    shortByType = value;
                    setState(() {

                    });
                  },
                ),
                const SizedBox(height: 20),
                Statusdropdown(
                  onChange: (value) {
                    status = value;
                    setState(() {

                    });
                  },
                )
              ],
            ),
          )))),
      bottomNavigationBar: Padding(padding: EdgeInsets.all(25),
        child: CustomBlueButton(
            text: 'Search', icon: Icons.search, onPressed: () async{
          showLoaderDialog(context);
          if (_formKey.currentState?.validate() ?? false) {
            final formData = {
              'profession_type_id': selectedProfessionTypeId ?? '',
              'department_id': selectedDepartmentId ?? '',
              'designation_id': selectedDesignationId ?? '',
              'SearchBy': searchBy ?? '',
              'order_by': shortBy ?? '',
              'sort_by_method': 'sortBy',
              'status': status ?? '',
            };
            await Provider.of<StaffDataProvider>(context, listen: false).fetchStaffs(
                bodyData: formData);
            context.pushNamed('staff-search-list');
          }
          hideLoaderDialog(context);
        }),),
    );
  }

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
    onChanged: onChange,
  );
}

