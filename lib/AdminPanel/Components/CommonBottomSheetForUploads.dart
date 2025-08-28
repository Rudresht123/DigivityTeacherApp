import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonBottomSheetForUploads extends StatelessWidget {
  final VoidCallback onFilter;
  final VoidCallback onAdd;
  final String addText;

  const CommonBottomSheetForUploads({
    super.key,
    required this.onFilter,
    required this.onAdd,
    required this.addText,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final uiTheme = Provider.of<UiThemeProvider>(context, listen: false);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Filter Button
            Flexible(
              child: SizedBox(
                width: 300,
                child: ElevatedButton.icon(
                  onPressed: onFilter,
                  icon: const Icon(Icons.search, color: Colors.black87),
                  label: const Text(
                    "Filter",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Add Button
            Flexible(
              child:SizedBox(
                width: 300,
                child:  ElevatedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: Text(
                    addText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: uiTheme.buttonColor ?? const Color(0xFF0A58CA),
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
