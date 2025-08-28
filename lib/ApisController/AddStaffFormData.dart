import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/AddStudentModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/AddStaffModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class Addstaffformdata{

  Future<AddStaffModel> getStaffFormData() async{
    final userId = await SharedPrefHelper.getPreferenceValue('user_id');
    final token = await SharedPrefHelper.getPreferenceValue('access_token');
    final url = "api/MobileApp/master-admin/$userId/addstaff";
    final response = await getApiService.getRequestData(url, token);

    if (response != null &&
        response['success'] != null &&
        response['success'][0] != null &&
        response['success'][0].isNotEmpty) {
      final data = response['success'][0];
      return AddStaffModel.fromJson(data);

    }
    return AddStaffModel(
      professiontype: [],
      title: [],
      stafftype: [],
      department: [],
      designation: [],
      maritalstatus: [],
      authorizeby:[],
    );
  }

}
