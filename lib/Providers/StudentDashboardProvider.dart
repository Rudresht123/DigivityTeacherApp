import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:flutter/cupertino.dart';

class StudentDashboardProvider with ChangeNotifier{

  Future<void> getDataForStudentDashboard(BuildContext context) async{

    final userid =  SharedPrefHelper.getPreferenceValue('user_id');
    final token =  SharedPrefHelper.getPreferenceValue('access_token');

  }

}