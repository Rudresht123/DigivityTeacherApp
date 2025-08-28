import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/AdmTypeModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/CasteModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/CategoryModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/HouseModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/StudentTypeModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/TransportModel.dart';

class StudentDataModel {
  final String admissionNo;
  final List<CasteModel> caste;
  final List<TransportModel> transport;
  final List<StudentTypeModel> studenttype;
  final List<CategoryModel> category;
  final List<AdmTypeModel> admType;
  final List<HouseModel> house;

  StudentDataModel({
    required this.admissionNo,
    required this.caste,
    required this.transport,
    required this.studenttype,
    required this.category,
    required this.admType,
    required this.house,
  });

  factory StudentDataModel.fromJson(Map<String, dynamic> json) {
      return StudentDataModel(
        admissionNo: json['admission_no'] ?? '',
        caste: (json['caste'] as List)
            .map((e) => CasteModel.fromJson(e))
            .toList(),
        transport: (json['transport'] as List)
            .map((e) => TransportModel.fromJson(e))
            .toList(),
        studenttype: (json['studenttype'] as List)
            .map((e) => StudentTypeModel.fromJson(e))
            .toList(),
        category: (json['category'] as List)
            .map((e) => CategoryModel.fromJson(e))
            .toList(),
        admType: (json['admType'] as List)
            .map((e) => AdmTypeModel.jsonFrom(e))
            .toList(),
        house: (json['house'] as List)
            .map((e) => HouseModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }

  }

