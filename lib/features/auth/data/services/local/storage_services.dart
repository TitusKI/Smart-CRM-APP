import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_crm_app/core/constants/constant.dart';

class StorageServices {
  late final SharedPreferences _prefs;
  Future<StorageServices> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> storeToken({
    String? token,
    String? resetToken,
  }) async {
    if (token != null) {
      await _prefs.setString('token', token);
    }
  }

  Future<void> storeEmail({
    String? email,
  }) async {
    if (email != null) {
      await _prefs.setString('email', email);
    }
  }

  Future<void> clearTokens() async {
    await _prefs.remove('token');
    await _prefs.remove('email');
  }

  String? getToken() {
    return _prefs.getString('token');
  }

  String? getEmail() {
    return _prefs.getString('email');
  }

  bool getDeviceFirstOpen() {
    return _prefs.getBool(AppConstant.STORAGE_DEVICE_OPEN_FIRST_TIME) ?? false;
  }

  bool getIsLoggedIn() {
    return _prefs.getBool(AppConstant.USER_TOKEN) ?? false;
  }
}
