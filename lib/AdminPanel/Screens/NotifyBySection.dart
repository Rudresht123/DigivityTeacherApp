import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:digivity_admin_app/Components/FieldSet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class NotifyBySection extends StatefulWidget {
  const NotifyBySection({super.key});

  @override
  State<NotifyBySection> createState() => NotifyBySectionState();
}

class NotifyBySectionState extends State<NotifyBySection> {
  final List<String> options = ["Text", "App", "Whatsapp", "Email", "Website"];
  final Map<String, bool> selectedOptions = {};

  @override
  void initState() {
    super.initState();
    for (var option in options) {
      selectedOptions[option] = false;
    }
  }

  void resetNotifySelection() {
    setState(() {
      for (var option in options) {
        selectedOptions[option] = false;
      }
    });
  }

  // 👇 Method to get the selected options in API format
  Map<String, dynamic> getSelectedNotifyValues() {
    return {
      'with_text_sms': selectedOptions['Text'] == true ? 'yes' : 'no',
      'with_app': selectedOptions['App'] == true ? 'yes' : 'no',
      'with_whatsapp': selectedOptions['Whatsapp'] == true ? 'yes' : 'no',
      'with_email': selectedOptions['Email'] == true ? 'yes' : 'no',
      'with_website': selectedOptions['Website'] == true ? 'yes' : 'no',
    };
  }

  @override
  Widget build(BuildContext context) {
    final uiTheme = Provider.of<UiThemeProvider>(context);
    return FieldSet(
      title: 'Notify By',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Wrap(
          spacing: 5,
          runSpacing: 8,
          children: options.map((label) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: selectedOptions[label] ?? false,
                    onChanged: (value) {
                      setState(() {
                        selectedOptions[label] = value!;
                      });
                    },
                    fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return uiTheme.buttonColor ?? Colors.blue;
                      }
                      return Colors.white;
                    }),
                  ),
                  Text(label),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
