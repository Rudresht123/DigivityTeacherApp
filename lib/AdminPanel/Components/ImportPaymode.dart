import 'package:flutter/material.dart';
import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/PayModeModel.dart';
import 'package:digivity_admin_app/helpers/FinanceHelperFunction.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';

class ImportPaymode extends StatefulWidget {
  final Function(String?)? onChanged;

  const ImportPaymode({Key? key, this.onChanged}) : super(key: key);

  @override
  State<ImportPaymode> createState() => _ImportPaymodeState();
}

class _ImportPaymodeState extends State<ImportPaymode> {
  List<PaymodeModel> rawList = [];
  String? selectedPaymode; // can be null initially

  @override
  void initState() {
    super.initState();
    loadPaymodes();
  }

  Future<void> loadPaymodes() async {
    try {
      final fetchedPaymodes = await FinanceHelperFunction().getPaymodes();
      setState(() {
        rawList = fetchedPaymodes;

        // Optional: Reset selected if previous value doesn't exist anymore
        bool isStillValid = rawList.any((e) => e.id.toString() == selectedPaymode);
        if (!isStillValid) selectedPaymode = null;
      });
    } catch (e) {
      print('Error fetching paymodes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> payModeList = [
      {'id': null, 'value': 'Please Paymode Select'},
      ...rawList.map((e) {
        return {
          'id': e.id.toString(),
          'value': e.paymode,
        };
      }),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdown(
          items: payModeList,
          displayKey: 'value',
          valueKey: 'id',
          hint: "Choose a paymode",
          selectedValue: selectedPaymode, // this must match exactly
          onChanged: (value) {
            setState(() {
              selectedPaymode = value; // `value` must match one of the 'id's
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value); // this supports null
            }
          },
        ),
      ],
    );
  }
}
