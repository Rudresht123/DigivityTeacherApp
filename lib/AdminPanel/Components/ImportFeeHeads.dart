import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/FeeHeadModel.dart';
import 'package:flutter/material.dart';
import 'package:digivity_admin_app/helpers/FinanceHelperFunction.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';

class ImportFeeHeads extends StatefulWidget {
  final Function(String?)? onChanged; // 🔧 changed from String? to int?

  const ImportFeeHeads({Key? key, this.onChanged}) : super(key: key);

  @override
  State<ImportFeeHeads> createState() => _ImportFeeHeads();
}

class _ImportFeeHeads extends State<ImportFeeHeads> {
  List<Feeheadmodel> rawList = [];
  String? selectedFeeHead;


  @override
  void initState() {
    super.initState();
    loadFeeheads();
  }

  Future<void> loadFeeheads() async {
    try {
      final fetchedFeeHeads = await FinanceHelperFunction().getFeeheads();
      setState(() {
        rawList = fetchedFeeHeads;
      });
    } catch (e) {
      print('Error fetching feeheads: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> feeHeadList = [
      {'id': null, 'value': 'Select Fee Head'}, // use null, not ''
      ...rawList.map((e) => {
        'id': e.id.toString(), // this is int
        'value': e.fee_head,
      }),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdown(
          items: feeHeadList,
          displayKey: 'value',
          valueKey: 'id',
          hint: "Choose a Fee Head",
          selectedValue: selectedFeeHead, // int?
          onChanged: (value) {
            setState(() {
              selectedFeeHead = value; // cast to int?
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
