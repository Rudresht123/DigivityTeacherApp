import 'package:digivity_admin_app/AdminPanel/Components/CustomImagePicker.dart';
import 'package:digivity_admin_app/AdminPanel/Components/PopupNetworkImage.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/StaffModel.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Providers/StaffDataProvider.dart';
import 'package:digivity_admin_app/helpers/ImagePicker.dart';
import 'package:digivity_admin_app/helpers/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class StaffUploadImageList extends StatefulWidget {
  final Map<String, dynamic>? formData;

  const StaffUploadImageList({Key? key,this.formData}) : super(key: key);

  @override
  State<StaffUploadImageList> createState() => _StaffUploadImageList();
}

class _StaffUploadImageList extends State<StaffUploadImageList> {
  final TextEditingController _staffSearchController = TextEditingController();

  List<Map<String, dynamic>> _originalList = [];
  List<Map<String, dynamic>> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _staffSearchController.addListener(_filterStaffList);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final staffs = Provider.of<StaffDataProvider>(context, listen: false).staffs;
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
        'status': staff.status,
        'staff_id': staff.dbId,
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: "Upload Staff Image",
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
                  hintText: 'Search by name, staff no, or contact...',
                  controller: _staffSearchController,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _filteredList.isNotEmpty
                      ? ListView.separated(
                    itemCount: _filteredList.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.grey.shade300, height: 1),
                    itemBuilder: (context, index) {
                      final staff = _filteredList[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? const Color(0xFFDBF3E2)
                              : const Color(0xFFE2E6EF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            PopupNetworkImage(imageUrl: staff['profile_img']
                            ,radius: 30,),

                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Staff No.: ${staff['staff_no'] ?? '-'} | Dept: ${staff['department'] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "${staff['full_name'] ?? ''} (${staff['profession'] ?? ''})",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Father: ${staff['father_name'] ?? ''}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF514197).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  showImagePickerBottomSheet(
                                    context: context,
                                    condidatename:
                                    "${staff['full_name'] ?? ''} (${staff['profession'] ?? ''})",
                                    onCameraTap: () async {
                                      final isGranted =await PermissionService.requestCameraPermission();
                                      if(isGranted) {
                                        final imageHandler = ImageHandler();
                                        await imageHandler.pickAndResizeImage(
                                            source: ImageSource.camera);

                                        if (imageHandler.resizedImageFile !=
                                            null) {
                                          showLoaderDialog(context);

                                          final response = await imageHandler
                                              .uploadResizedImage(
                                              'staff', staff['staff_id']);

                                          if (response['result'] == 1) {
                                            final provider = Provider.of<
                                                StaffDataProvider>(context,
                                                listen: false);
                                            await provider.fetchStaffs(
                                                bodyData: widget.formData ??
                                                    {});
                                            _updateStaffList(provider.staffs);
                                            hideLoaderDialog(context);
                                            showBottomMessage(
                                                context, response['message'],
                                                false);

                                          } else {
                                            hideLoaderDialog(context);
                                            showBottomMessage(
                                                context, response['message'],
                                                true);
                                          }

                                          hideLoaderDialog(context);
                                        } else {
                                          ScaffoldMessenger
                                              .of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "⚠️ No image selected")),
                                          );
                                        }
                                      }
                                    },
                                      onGalleryTap: () async {
                                        final isGranted = await PermissionService.requestGalleryPermission();

                                        if (!isGranted) {
                                          if (!mounted) return; // <- check
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("⚠️ Gallery access denied. Please enable it in settings.")),
                                          );
                                          return;
                                        }

                                        final imageHandler = ImageHandler();
                                        await imageHandler.pickAndResizeImageFromGalery(source: ImageSource.gallery);

                                        if (imageHandler.resizedImageFile != null) {
                                          if (!mounted) return; // <- check
                                          showLoaderDialog(context);

                                          final response = await imageHandler.uploadResizedImage('staff', staff['staff_id']);

                                          if (!mounted) return; // <- check
                                          final provider = Provider.of<StaffDataProvider>(context, listen: false);

                                          if (response['result'] == 1) {
                                            await provider.fetchStaffs(bodyData: widget.formData ?? {});
                                            if (!mounted) return;
                                            _updateStaffList(provider.staffs);
                                            hideLoaderDialog(context);
                                            showBottomMessage(context, response['message'], false);
                                          } else {
                                            if (!mounted) return; // <- check
                                            hideLoaderDialog(context);
                                            showBottomMessage(context, response['message'], true);
                                          }
                                        } else {
                                          if (!mounted) return; // <- check
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("⚠️ No image selected from gallery")),
                                          );
                                        }
                                      }
                                  );
                                },
                                icon: const Icon(Icons.camera_alt_outlined,
                                    color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                      : const Center(child: Text("No staff found")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
