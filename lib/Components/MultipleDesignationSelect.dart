import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/DesignationModel.dart';
import 'package:digivity_admin_app/ApisController/AddStaffFormData.dart';
import 'package:digivity_admin_app/Components/Loader.dart';

class Multipledesignationselect extends StatefulWidget {
  final List<String>? initialValues; // list of selected IDs (as strings)
  final Function(List<String>)? onChanged;
  final String? Function(List<String>?)? validator;
  final String? label;

  const Multipledesignationselect({
    Key? key,
    this.label,
    this.initialValues,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  State<Multipledesignationselect> createState() => _MultipledesignationselectState();
}

class _MultipledesignationselectState extends State<Multipledesignationselect> {
  List<Designationmodel> allDesignations = [];
  List<Designationmodel> selectedDesignations = [];
  List<MultiSelectItem<Designationmodel>> items = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoaderDialog(context);
      getData();
    });
  }

  Future<void> getData() async {
    final staffdata = await Addstaffformdata().getStaffFormData();
    final designations = staffdata?.designation ?? [];

    Navigator.of(context).pop(); // hide loader

    setState(() {
      allDesignations = designations;

      // Create list of MultiSelectItems for the dropdown
      items = designations
          .map((e) => MultiSelectItem<Designationmodel>(e, "${e.value} "))
          .toList();

      // Pre-select based on incoming list of string IDs
      if (widget.initialValues != null) {
        selectedDesignations = designations.where((d) {
          return widget.initialValues!.contains(d.id.toString());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MultiSelectDialogField<Designationmodel>(
          items: items,
          title: Text(widget.label ?? "Select Designation"),
          selectedColor: Colors.blue,
          buttonText: Text(widget.label ?? "Select Designation"),
          searchable: true,
          listType: MultiSelectListType.LIST,
          initialValue: selectedDesignations,
          onConfirm: (values) {
            setState(() {
              selectedDesignations = values;
            });

            final selectedIds = values.map((e) => e.id.toString()).toList();
            widget.onChanged?.call(selectedIds);
          },
          validator: (_) => widget.validator?.call(
              selectedDesignations.map((e) => e.id.toString()).toList()),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade500,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          buttonIcon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
          chipDisplay: MultiSelectChipDisplay(
            items: selectedDesignations
                .map((e) => MultiSelectItem<Designationmodel>(e, e.value))
                .toList(),
            chipColor: Colors.blue.shade100,
            textStyle: const TextStyle(color: Colors.black),
            onTap: (value) {
              setState(() {
                selectedDesignations.remove(value);
              });
              widget.onChanged?.call(
                  selectedDesignations.map((e) => e.id.toString()).toList());
            },
          ),
        ),
      ],
    );
  }
}
