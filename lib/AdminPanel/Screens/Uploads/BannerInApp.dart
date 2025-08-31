import 'package:flutter/material.dart';

enum BannerInAppType { yes, no }

class BannerInApp extends StatelessWidget {
  final BannerInAppType selectedType;
  final String? label;
  final void Function(BannerInAppType?)? onChanged;

  const BannerInApp({
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
            label ?? 'Banner In App',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: BannerInAppType.values.map((type) {
              final typeLabel = _getLabel(type);
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (onChanged != null) {
                      onChanged!(type);
                    }
                  },
                  child: Row(
                    children: [
                      Radio<BannerInAppType>(
                        value: type,
                        groupValue: selectedType,
                        onChanged: onChanged,
                      ),
                      Text(typeLabel),
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

  String _getLabel(BannerInAppType type) {
    switch (type) {
      case BannerInAppType.yes:
        return 'Yes';
      case BannerInAppType.no:
        return 'No';
    }
  }
}
