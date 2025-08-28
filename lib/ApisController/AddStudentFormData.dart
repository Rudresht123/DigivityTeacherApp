import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/AddStudentModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class AddStudentFormData{

  Future<StudentDataModel> getStudentFormData() async{
    final userId = await SharedPrefHelper.getPreferenceValue('user_id');
    final token = await SharedPrefHelper.getPreferenceValue('access_token');
    final url = "api/MobileApp/master-admin/$userId/addstudent";
    final response = await getApiService.getRequestData(url, token);

    if (response != null &&
        response['success'] != null &&
        response['success'][0] != null &&
        response['success'][0].isNotEmpty) {
      final data = response['success'][0];
      return StudentDataModel.fromJson(data);

    }
    return StudentDataModel(
      admissionNo: '',
      caste: [],
      transport: [],
      studenttype: [],
      category: [],
      admType: [],
      house:[],
    );


}

}
