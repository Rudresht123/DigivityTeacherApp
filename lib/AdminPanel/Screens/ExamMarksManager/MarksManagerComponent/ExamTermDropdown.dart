import 'package:flutter/material.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/ExamTermModel.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/helpers/MarksManagerHelpers/StudentMarksManagerCommonHelper.dart';

class ExamTermDropdown extends StatefulWidget {
  final Function(String examTermId, String examTermName)? onExamTermSelected;

  const ExamTermDropdown({Key? key, this.onExamTermSelected}) : super(key: key);

  @override
  State<ExamTermDropdown> createState() => _ExamTermDropdownState();
}

class _ExamTermDropdownState extends State<ExamTermDropdown> {
  List<Examtermmodel> examTermList = [];
  String? selectedExamTermId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchInitialData());
  }

  Future<void> fetchInitialData() async {
    try {
      final data = await StudentMarksManagerCommonHelper().getMarksmanagerData();
      if (data.isNotEmpty && data['examTermList'] != null) {
        setState(() {
          examTermList = List<Examtermmodel>.from(data['examTermList']);
        });
      }
    } catch (e) {
      print('Error fetching exam terms: $e');
    } finally {

    }
  }
  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      label: 'Exam Term',
      selectedValue: selectedExamTermId,
      items: examTermList
          .map((e) => {
        'id': e.examtermId.toString(),
        'value': e.examTerm ?? '',
      })
          .toList(),
      displayKey: 'value',
      valueKey: 'id',
      hint: 'Select Exam Term',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select an exam term';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          selectedExamTermId = value;
        });
        final selected = examTermList.firstWhere(
              (e) => e.examtermId.toString() == value,
          orElse: () => Examtermmodel(examtermId: 0, examTerm: ''),
        );
        widget.onExamTermSelected?.call(value, selected.examTerm ?? '');
      },
    );
  }
}
