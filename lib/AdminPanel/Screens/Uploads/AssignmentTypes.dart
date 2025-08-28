import 'package:flutter/material.dart';

enum AssignmentType { student, staff, all }

class AssignmentTypeSelector extends StatelessWidget {
  final AssignmentType selectedType;
  final String? label;
  final void Function(AssignmentType?)? onChanged;

  const AssignmentTypeSelector({
    Key? key,
    required this.selectedType,
    this.label,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            label ?? 'Assignment Type',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: AssignmentType.values.map((type) {
              final label = _getLabel(type);
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (onChanged != null) {
                      onChanged!(type);
                    }
                  },
                  child: Row(
                    children: [
                      Radio<AssignmentType>(
                        value: type,
                        groupValue: selectedType,
                        onChanged: onChanged,
                      ),
                      Text(label),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _getLabel(AssignmentType type) {
    switch (type) {
      case AssignmentType.student:
        return 'Student';
      case AssignmentType.staff:
        return 'Staff';
      case AssignmentType.all:
        return 'All';
    }
  }
}
