import 'package:flutter/material.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:intl/intl.dart';

class IsSubmission extends StatefulWidget {
  final TextEditingController submissionDateController;
  final TextEditingController submissionTimeController;

  const IsSubmission({
    super.key,
    required this.submissionDateController,
    required this.submissionTimeController,
  });

  @override
  State<IsSubmission> createState() => _IsSubmissionState();
}

class _IsSubmissionState extends State<IsSubmission> {
  bool isSubmissionEnabled = false;
  @override
  void initState() {
    super.initState();
    widget.submissionTimeController.text = DateFormat.jm().format(DateTime.now());
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: const Text("Submission"),
          value: isSubmissionEnabled,
          onChanged: (value) {
            setState(() {
              isSubmissionEnabled = value!;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        if (isSubmissionEnabled) ...[
          const SizedBox(height: 10),
          DatePickerField(
            label: "Submission Date",
            controller: widget.submissionDateController,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                widget.submissionTimeController.text = picked.format(context);
              }
            },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: widget.submissionTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Submission Time',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
        ]
      ],
    );
  }
}
