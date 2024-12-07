import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_crm_app/core/constants/constant.dart';

class StorageServices {
  late final SharedPreferences _prefs;
  Future<StorageServices> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> storeToken({
    required String token,
    String? email,
    required String userId,
  }) async {
    if (token.isNotEmpty) {
      await _prefs.setString('token', token);
    }
    if (userId.isNotEmpty) {
      await _prefs.setString(AppConstant.USER_ID_KEY, userId);
    }

    if (email != null) {
      await _prefs.setString('email', email);
    }
  }

  Future<void> clearTokens() async {
    await _prefs.remove('token');
    await _prefs.remove('email');
    await _prefs.remove(AppConstant.USER_ID_KEY);
  }

  String? getToken() {
    return _prefs.getString('token');
  }

  String? getEmail() {
    return _prefs.getString('email');
  }

  Future<String?> getUserId() async {
    return _prefs.getString(AppConstant.USER_ID_KEY);
  }

  bool getDeviceFirstOpen() {
    return _prefs.getBool(AppConstant.STORAGE_DEVICE_OPEN_FIRST_TIME) ?? false;
  }

  bool getIsLoggedIn() {
    return _prefs.getBool(AppConstant.USER_TOKEN) ?? false;
  }
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }
}
