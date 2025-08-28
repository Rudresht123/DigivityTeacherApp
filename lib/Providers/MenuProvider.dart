import 'package:flutter/material.dart';
import 'package:digivity_admin_app/ApisController/UserPermissions.dart';

class MenuProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _quickActions = [];
  List<Map<String, dynamic>> _importantLinks = [];
  List<Map<String, dynamic>> _aboutSchool = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get quickActions => _quickActions;
  List<Map<String, dynamic>> get importantLinks => _importantLinks;
  List<Map<String, dynamic>> get aboutSchool => _aboutSchool;
  bool get isLoading => _isLoading;

  /// Fetch menu items from API
  Future<void> fetchMenuItems() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await UserPermissions().getPermissions();
      _quickActions = List<Map<String, dynamic>>.from(data['quickActions'] ?? []);
      _importantLinks = List<Map<String, dynamic>>.from(data['reports'] ?? []);
      _aboutSchool = List<Map<String, dynamic>>.from(data['aboutschools'] ?? []);
    } catch (e) {
      print("Bug On thFetched THe Permissi on Data ${e}");
      _quickActions = [];
      _importantLinks = [];
      _aboutSchool = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
