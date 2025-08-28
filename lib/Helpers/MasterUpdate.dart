
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class Masterupdate {
  int? userId;
  String? token;
  dynamic response;

  Masterupdate();

  /// Proper async initializer
  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }


  /// Roll Number Update
  Future<bool> updateStudentRollNo(Map<String,dynamic> formdata) async{
    if(userId ==null && token == null){
      await init();
    }
    try {
      final url = 'api/MobileApp/teacher/$userId/UpdateStudentRollNo';
      final response = await getApiService.postRequestData(url, token!, formdata);
      if (response !=null){
        return true ;
      }else
      {
        return false;
      }
    }catch(e){
      throw Exception(e);
    }
  }


  Future<bool> updateStudentFieldData(String? Field,Map<String,dynamic> formdata) async{
    if(userId ==null && token == null){
      await init();
    }
    try {
      final url = 'api/MobileApp/teacher/$userId/$Field/UpdateStudentRecord';

      final response = await getApiService.postRequestData(url, token!, formdata);
      if (response != null){
        return true ;
      }else
      {
        return false;
      }
    }catch(e){
      throw Exception(e);
    }
  }
}
