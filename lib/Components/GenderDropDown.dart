import 'package:flutter/material.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';

const List<Map<String, String>> genderOptions = [
  {'id': ' ', 'value': 'Please Select Gender'},
  {'id': 'male', 'value': 'Male'},
  {'id': 'female', 'value': 'Female'},
  {'id': 'transgender', 'value': 'Transgender'},
];


class Genderdropdown extends StatefulWidget {
  final Function(String?)? onChanged;
  final String? value;
  final String? Function(dynamic)? validator;

  const Genderdropdown({
    super.key,
    this.onChanged,
    this.value,
    this.validator,
  });

  @override
  State<Genderdropdown> createState() => _GenderdropdownState();
}

class _GenderdropdownState extends State<Genderdropdown> {
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    selectedGender = widget.value;
  }

  @override
  void didUpdateWidget(covariant Genderdropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() {
        selectedGender = widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      items: genderOptions,
      displayKey: 'value',
      valueKey: 'id',
      value: selectedGender,
      hint: 'Select Gender',
      validator: widget.validator,
      onChanged: (val) {
        setState(() {
          selectedGender = val;
        });
        widget.onChanged?.call(val);
      },
    );
  }
}

