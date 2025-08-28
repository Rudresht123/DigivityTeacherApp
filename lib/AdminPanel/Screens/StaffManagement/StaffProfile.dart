import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/StaffProfileModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentProfileModel.dart';
import 'package:digivity_admin_app/ApisController/StaffApis.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/CommonFunctions.dart';
import 'package:flutter/material.dart';

class Staffprofile extends StatefulWidget {
  final String? staffId;
  const Staffprofile({Key? key, required this.staffId}) : super(key: key);

  @override
  State<Staffprofile> createState() => _Staffprofile();
}

class _Staffprofile extends State<Staffprofile> {
  final double avatarRadius = 40;
  StaffProfileModel? staff;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _studentData();
  }

  Future<void> _studentData() async {
    if (widget.staffId != null) {
      setState(() => _isLoading = true);
      staff = await StaffApis().staffProfile(widget.staffId);
      setState(() => _isLoading = false);
    } else {
      print("Staff ID is null");
    }
  }
  @override
  Widget build(BuildContext context) {
    if (_isLoading || staff == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: "Staff Profile", routeName: 'back'),
      ),
      body: BackgroundWrapper(
        child: Column(
          children: [
            // Profile header
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 130,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: (staff?.profile != null &&
                              staff!.profile!.isNotEmpty)
                              ? NetworkImage(staff!.profile!)
                              : null,
                          child: (staff?.profile == null ||
                              staff!.profile!.isEmpty)
                              ? const Icon(Icons.person, size: 40)
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          staff!.firstName ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          staff!.contactNo ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: // Inside child: Wrap(...)
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildInfoBox("Staff No", staff!.staffNo ?? 'N/A'),
                    _buildInfoBox("Joining Date", staff!.joiningDate ?? 'N/A'),
                    _buildInfoBox("Profession Type", staff!.professionType ?? 'N/A'),
                    _buildInfoBox("Staff Type", staff!.staffType ?? 'N/A'),
                    _buildInfoBox("Department", staff!.department ?? 'N/A'),
                    _buildInfoBox("Designation", staff!.designation ?? 'N/A'),
                    _buildInfoBox("Title", staff!.title ?? 'N/A'),
                    _buildInfoBox("Full Name", "${staff!.firstName ?? ''} ${staff!.middleName ?? ''} ${staff!.lastName ?? ''}"),
                    _buildInfoBox("Gender", staff!.gender ?? 'N/A'),
                    _buildInfoBox("Blood Group", staff!.bloodGroup ?? 'N/A'),
                    _buildInfoBox("Date of Birth", staff!.dob ?? 'N/A'),
                    _buildInfoBox("Nationality", staff!.nationality ?? 'N/A'),
                    _buildInfoBox("Religion", staff!.religion ?? 'N/A'),
                    _buildInfoBox("Category", staff!.category ?? 'N/A'),
                    _buildInfoBox("Aadhaar No", staff!.aadhaarNo ?? 'N/A'),
                    _buildInfoBox("PAN No", staff!.panNo ?? 'N/A'),
                    _buildInfoBox("License No", staff!.licenseNo ?? 'N/A'),
                    _buildInfoBox("Passport No", staff!.passportNo ?? 'N/A'),
                    _buildInfoBox("Contact No", staff!.contactNo ?? 'N/A'),
                    _buildInfoBox("Alternate Mobile", staff!.altMobileNo ?? 'N/A'),
                    _buildInfoBox("Email", staff!.email ?? 'N/A'),
                    _buildInfoBox("Father's Name", staff!.fatherName ?? 'N/A'),
                    _buildInfoBox("Mother's Name", staff!.motherName ?? 'N/A'),
                    _buildInfoBox("Spouse Name", staff!.spouseName ?? 'N/A'),
                    _buildInfoBox("Residence Address", staff!.residenceAddress ?? 'N/A'),
                    _buildInfoBox("Permanent Address", staff!.permanentAddress ?? 'N/A'),
                    _buildInfoBox("Account Number", staff!.accountNumber ?? 'N/A'),
                    _buildInfoBox("IFSC Code", staff!.ifscCode ?? 'N/A'),
                    _buildInfoBox("Bank Name", staff!.bankName ?? 'N/A'),
                    _buildInfoBox("Bank Location", staff!.bankLocation ?? 'N/A'),
                    _buildInfoBox("Nominee Name", staff!.nomineeName ?? 'N/A'),
                    _buildInfoBox("Nominee Relation", staff!.nomineeRelation ?? 'N/A'),
                  ],
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Container(
      width: 165,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),

      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.lock, size: 14, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}
