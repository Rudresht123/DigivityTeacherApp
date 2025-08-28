import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/StaffModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/StaffManagement/StaffListBottomSheet.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Providers/StaffDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StaffListScreen extends StatefulWidget {

  const StaffListScreen({Key? key}) : super(key: key);

  @override
  State<StaffListScreen> createState() => _StaffListScreen();
}

class _StaffListScreen extends State<StaffListScreen> {
  final TextEditingController _staffSearchController = TextEditingController();

  List<Map<String, dynamic>> _originalList = [];
  List<Map<String, dynamic>> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _staffSearchController.addListener(_filterStaffList);

    WidgetsBinding.instance.addPostFrameCallback((_) async{
      final staffs =  Provider.of<StaffDataProvider>(context, listen: false).staffs;
      _updateStaffList(staffs);
    });
  }

  void _updateStaffList(List<StaffModel> staffs) {
    final mappedList = _mapStaffList(staffs);
    setState(() {
      _originalList = mappedList;
      _filteredList = mappedList;
    });
  }

  List<Map<String, dynamic>> _mapStaffList(List<StaffModel> staffs) {
    return staffs.map((staff) {
      return {
        'profile_img': staff.profileImg ?? '',
        'profession': staff.profession ?? '',
        'staff_type': staff.staffType ?? '',
        'department': staff.department ?? '',
        'designation': staff.designation ?? '',
        'contact_no': staff.contactNo ?? '',
        'full_name': staff.fullName ?? '',
        'father_name': staff.fatherName ?? '',
        'address': staff.address ?? '',
        'staff_no': staff.staffNo ?? '',
        'status':staff.status,
        'staff_id':staff.dbId
      };
    }).toList();
  }

  void _filterStaffList() {
    final query = _staffSearchController.text.toLowerCase();
    setState(() {
      _filteredList = _originalList.where((staff) {
        return (staff['full_name']?.toLowerCase().contains(query) ?? false) ||
            (staff['staff_no']?.toLowerCase().contains(query) ?? false) ||
            (staff['contact_no']?.toLowerCase().contains(query) ?? false) ||
            (staff['address']?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  @override
  void dispose() {
    _staffSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // DO NOT call _updateStaffList here
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: "Search Staff List",
          routeName: 'back',
        ),
      ),
      body: BackgroundWrapper(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextField(
                  label: 'Search Staff',
                  hintText: 'Search Staff Here',
                  controller: _staffSearchController,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Consumer<StaffDataProvider>(
                    builder: (context, staffProvider, _) {
                      final updatedList = _mapStaffList(staffProvider.staffs);

                      final filtered = _staffSearchController.text.isEmpty
                          ? updatedList
                          : updatedList.where((staff) {
                        final query = _staffSearchController.text.toLowerCase();
                        return (staff['full_name']?.toLowerCase().contains(query) ?? false) ||
                            (staff['staff_no']?.toLowerCase().contains(query) ?? false) ||
                            (staff['contact_no']?.toLowerCase().contains(query) ?? false) ||
                            (staff['address']?.toLowerCase().contains(query) ?? false);
                      }).toList();

                      return filtered.isNotEmpty
                          ? ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final staff = filtered[index];
                          final bgColor = index % 2 == 0
                              ? const Color(0xFFDBF3E2)
                              : const Color(0xFFE0E7FF);

                          return Card(
                            color: bgColor,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              onTap: () {
                                showStaffListBottomSheet(
                                  context,
                                  staff['staff_id'],
                                  staff['full_name'] ?? 'Unknown',
                                  staff['staff_no'].toString(),
                                  staff['contact_no'].toString(),
                                  staff['status'],
                                  (updatedList) => _updateStaffList(updatedList),
                                );
                              },
                              leading: PopupNetworkImage(imageUrl: staff['profile_img'],
                              radius: 30,),
                              title: Text(
                                staff['full_name'] ?? '',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Staff Id: ${staff['staff_id']}"),
                                  Text("Profession: ${staff['profession']}"),
                                  Text("Designation: ${staff['designation']}"),
                                  Text("Department: ${staff['department']}"),
                                  Text("Mobile: ${staff['contact_no']}"),
                                  Text("Father: ${staff['father_name']}"),
                                  Text("Address: ${staff['address']}"),
                                  Text("Status: ${staff['status']}")
                                ],
                              ),
                            ),
                          );
                        },
                      )
                          : const Center(child: Text("No staff found"));
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}

