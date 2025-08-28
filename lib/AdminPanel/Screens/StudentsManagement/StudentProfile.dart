import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentProfileModel.dart';
import 'package:digivity_admin_app/ApisController/StudentApis.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/helpers/CommonFunctions.dart';
import 'package:flutter/material.dart';

class StudentProfile extends StatefulWidget {
  final String? studentId;
  const StudentProfile({Key? key, required this.studentId}) : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfile();
}

class _StudentProfile extends State<StudentProfile> {
  final double avatarRadius = 40;
  Studentprofilemodel? student;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _studentData();
  }

  Future<void> _studentData() async {
    if (widget.studentId != null) {
      setState(() => _isLoading = true);
      try {
        student = await StudentApis().studentProfile(widget.studentId!);
      } catch (e) {
        print("Error fetching student data: $e");
        student = null;
      }
      setState(() => _isLoading = false);
    } else {
      print("Student ID is null");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (student == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Student Profile")),
        body: const Center(
          child: Text("No student data found."),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(titleText: "Student Profile", routeName: 'back'),
      ),
      body: BackgroundWrapper(
        child: Column(
          children: [
            // Profile Header
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
                          backgroundImage: (student?.profile != null &&
                              student!.profile!.isNotEmpty)
                              ? NetworkImage(student!.profile!)
                              : null,
                          child: (student?.profile == null ||
                              student!.profile!.isEmpty)
                              ? const Icon(Icons.person, size: 40)
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          student?.fullName ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          student?.course ?? 'N/A',
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
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildInfoBox("Academic Session", student?.academicSession ?? 'N/A'),
                    _buildInfoBox("Admission Number", student?.admissionNo ?? 'N/A'),
                    _buildInfoBox("Date of Admission", student?.admissionDate ?? 'N/A'),
                    _buildInfoBox("Date of Birth", student?.dob ?? 'N/A'),
                    _buildInfoBox("Category", student?.category ?? 'N/A'),
                    _buildInfoBox("Caste", student?.caste ?? 'N/A'),
                    _buildInfoBox("Blood Group", student?.bloodGroup ?? 'N/A'),
                    _buildInfoBox("Religion", student?.religion ?? 'N/A'),
                    _buildInfoBox("Gender", student?.gender ?? 'N/A'),
                    _buildInfoBox("Nationality", student?.nationality ?? 'Indian'),
                    _buildInfoBox("SMS Contact No", student?.contactNo ?? 'N/A'),
                    _buildInfoBox("Email", student?.email ?? 'N/A'),
                    _buildInfoBox("Father's Name", student?.fatherName ?? 'N/A'),
                    _buildInfoBox("Father's Contact No", student?.fatherMobileNo ?? 'N/A'),
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
      width: 170,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 5),
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
