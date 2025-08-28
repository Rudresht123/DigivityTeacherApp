// lib/providers/ui_theme_provider.dart

import 'package:digivity_admin_app/Helpers/getApiService.dart';
import 'package:flutter/material.dart';
import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/mobile_ui_settings_model.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';

class UiThemeProvider with ChangeNotifier {
  late MobileUiSettings _settings;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  void setThemeSettings(MobileUiSettings data) {
    _settings = data;
    _isLoaded = true;
    notifyListeners();
  }

  MobileUiSettings get settings {
    if (!_isLoaded) {
      throw Exception("UiTheme settings not loaded yet.");
    }
    return _settings;
  }

  // ======= Safe Getters =======
  List<Color>? get graphColors  => _isLoaded ? _settings.graphColors : [Colors.blue, Colors.green];

  Color? get appBarColor => _isLoaded ? _settings.appBarColor : Colors.blue;
  Color? get iconColor => _isLoaded ? _settings.iconColor : Colors.black;
  Color? get iconBgColor => _isLoaded ? _settings.iconBgColor : Colors.transparent;
  Color? get bottomSheetBgColor => _isLoaded ? _settings.bottomSheetBgColor : Colors.white;
  Color? get appbarIconColor => _isLoaded ? _settings.appbarIconColor : Colors.white;
  Color? get bottombarIconColor => _isLoaded ? _settings.bottombarIconColor : Colors.grey;
  Color? get buttonColor => _isLoaded ? _settings.buttonColor : Colors.indigo;
  Color? get inputBorderColor => _isLoaded ? _settings.inputBorderColor : Colors.grey.shade300;
  Color? get screenBackgroundColor => _isLoaded ? _settings.screenBackgroundColor : Colors.grey.shade300;
  String? get screenBackgroundImage => _isLoaded ? _settings.screenBackgroundImage : null;

  // ======= API Fetch Method =======
  Future<void> loadThemeSettingsFromApi(BuildContext context) async {
    try {
      final userId = await SharedPrefHelper.getPreferenceValue('user_id');
      final token = await SharedPrefHelper.getPreferenceValue('access_token');

      final url = "api/MobileApp/master-admin/$userId/MobileUISettingsApi";
      final response = await getApiService.getRequestData(url, token);
      final data = MobileUiSettings.fromJson(response['success']);

      setThemeSettings(data);

    } catch (e, st) {
      debugPrint("Failed to reload UI theme: $e\n$st");
    }
  }
}
