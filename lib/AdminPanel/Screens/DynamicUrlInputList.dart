import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DynamicUrlInputList extends StatefulWidget {
  const DynamicUrlInputList({super.key});

  @override
  State<DynamicUrlInputList> createState() => DynamicUrlInputListState();
}
class DynamicUrlInputListState extends State<DynamicUrlInputList> {
  final List<TextEditingController> _controllers = [];

  void _addUrlField() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _removeUrlField(int index) {
    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
    });
  }

  String getUrlLinks() {
    return _controllers
        .where((controller) =>
    controller.text
        .trim()
        .isNotEmpty)
        .map((controller) => controller.text.trim())
        .join("~");
  }

  @override
  void resetUrls() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
    _addUrlField(); // Optional: to add back an empty field
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final uiTheme = Provider.of<UiThemeProvider>(context);
    return Column(
      children: [
        // Dynamic TextFields
        ..._controllers
            .asMap()
            .entries
            .map((entry) {
          final index = entry.key;
          final controller = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Material(

              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFDBF3E2), // 👈 Background color
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),

                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Enter URL',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                          const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: uiTheme.bottomSheetBgColor ??
                            Color(0xFF514197).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeUrlField(index),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),

        const SizedBox(height: 12),

        // Add URL Button
        Center(
          child: ElevatedButton.icon(
            onPressed: _addUrlField,
            icon: const Icon(Icons.add),
            label: const Text("Add URL Link"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              foregroundColor: Colors.black,
              elevation: 4,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }


}
