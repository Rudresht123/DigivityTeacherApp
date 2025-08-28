import 'package:digivity_admin_app/AdminPanel/Models/SmsManagementModels/CourseList.dart';
import 'package:digivity_admin_app/AdminPanel/Models/SmsManagementModels/DesignationList.dart';
import 'package:digivity_admin_app/AdminPanel/Models/SmsManagementModels/UsercopyModel.dart';

class CmposeCommunicationReponce{
  final List<CourseList> courseList;
  final List<DesignationList> designationList;
  final List<UsercopyModel> userCopy;

  CmposeCommunicationReponce({required this.courseList,required this.designationList,required this.userCopy});

  factory CmposeCommunicationReponce.jsonFrom(Map<String,dynamic> json){
    return CmposeCommunicationReponce(
        courseList: (json['course'] as List).map((e) => CourseList.fromJson(e)).toList(),
        designationList: (json['designation'] as List).map((e)=>DesignationList.fromJson(e)).toList(),
        userCopy: (json['usercopy'] as List).map((e)=>UsercopyModel.fromJson(e)).toList(),);
  }

}
