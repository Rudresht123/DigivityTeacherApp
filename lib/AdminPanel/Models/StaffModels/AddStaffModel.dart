
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/AuthorizebyModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/DepartmentModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/DesignationModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/MaritalStatusModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/ProfessionTypeModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/StaffTypeModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/TitleModel.dart';
class AddStaffModel {
  final List<Professiontypemodel> professiontype;
  final List<StaffTypeModel> stafftype;
  final List<DepartmentModel> department;
  final List<Designationmodel> designation;
  final List<MaritalStatus> maritalstatus;
  final List<TitleModel> title;
  final List<AuthorizebyModel> authorizeby;
  AddStaffModel({
    required this.professiontype,
    required this.stafftype,
    required this.department,
    required this.designation,
    required this.maritalstatus,
    required this.title,
    required this.authorizeby,
  });

  factory AddStaffModel.fromJson(Map<String, dynamic> json) {
    return AddStaffModel(
      professiontype: (json['professiontype'] as List)
          .map((e) => Professiontypemodel.fromJson(e))
          .toList(),
      stafftype: (json['stafftype'] as List)
          .map((e) => StaffTypeModel.fromJson(e))
          .toList(),
      department: (json['department'] as List)
          .map((e) => DepartmentModel.fromJson(e))
          .toList(),
      designation: (json['designation'] as List)
          .map((e) => Designationmodel.fromJson(e))
          .toList(),
      maritalstatus: (json['maritalstatus'] as List)
          .map((e) => MaritalStatus.fromJson(e))
          .toList(),
      title: (json['title'] as List)
          .map((e) => TitleModel.fromJson(e))
          .toList(),
      authorizeby: (json['authorizeby'] as List)
          .map((e) => AuthorizebyModel.fromJson(e))
          .toList(),
    );
  }
}
