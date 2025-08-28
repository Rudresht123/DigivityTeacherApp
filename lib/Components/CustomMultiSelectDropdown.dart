import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CustomMultiSelectDropdown extends StatefulWidget {
  final List<dynamic> items;
  final String displayKey;
  final String valueKey;
  final String hint;
  final List<dynamic> selectedValues;
  final Function(List<dynamic>) onChanged;
  final Map<String, dynamic> Function(dynamic)? itemMapper;

  const CustomMultiSelectDropdown({
    Key? key,
    required this.items,
    required this.displayKey,
    required this.valueKey,
    required this.hint,
    required this.selectedValues,
    required this.onChanged,
    this.itemMapper,
  }) : super(key: key);

  @override
  State<CustomMultiSelectDropdown> createState() =>
      _CustomMultiSelectDropdownState();
}

class _CustomMultiSelectDropdownState extends State<CustomMultiSelectDropdown> {
  List<Map<String, dynamic>> get mappedItems {
    return widget.items.map<Map<String, dynamic>>((item) {
      if (item is Map<String, dynamic>) return item;
      if (widget.itemMapper != null) return widget.itemMapper!(item);
      throw Exception("Provide itemMapper for non-Map types");
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final multiItems = mappedItems.map((item) {
      return MultiSelectItem(
        item[widget.valueKey],
        item[widget.displayKey] ?? '',
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.hint,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            final selected = await showModalBottomSheet<List<dynamic>>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.85,
                    padding: const EdgeInsets.all(16),
                    child: MultiSelectBottomSheet(
                      items: multiItems,
                      initialValue: widget.selectedValues,
                      searchable: true,
                      listType: MultiSelectListType.LIST,
                      title: Text(widget.hint),
                      onConfirm: (values) {
                        Navigator.pop(context, values);
                      },
                      cancelText: const Text("CANCEL"),
                      confirmText: const Text("OK"),
                    ),
                  ),
                );
              },
            );

            if (selected != null) {
              widget.onChanged(selected);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.selectedValues.isEmpty
                        ? "Choose"
                        : widget.selectedValues.map((val) {
                      final item = mappedItems.firstWhere(
                            (item) => item[widget.valueKey] == val,
                        orElse: () => {},
                      );
                      return item[widget.displayKey] ?? '';
                    }).join(', '),
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: -8,
          children: widget.selectedValues.map((value) {
            final displayItem = mappedItems.firstWhere(
                  (item) => item[widget.valueKey] == value,
              orElse: () => {},
            );
            return Chip(
              backgroundColor: Colors.blue.shade900,
              label: Text(
                displayItem[widget.displayKey] ?? '',
                style: const TextStyle(color: Colors.white),
              ),
              onDeleted: () {
                final newList = List.from(widget.selectedValues)..remove(value);
                widget.onChanged(newList);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
