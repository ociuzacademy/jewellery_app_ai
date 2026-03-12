
import 'package:jewellery_app/view/utils/prefence_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceValues {


  static Future<void> disableUserIntroScreen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(PreferenceKeys.isUserFirstLaunch, false);
  }

  static Future<bool> getUserIntroScreenStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? isFirstLaunch = preferences.getBool(PreferenceKeys.isUserFirstLaunch);
    return isFirstLaunch ?? true;
  }

  
  static Future<void> disableEmployeeIntroScreen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(PreferenceKeys.isEmployeeFirstLaunch, false);
  }

  static Future<bool> getEmployeeIntroScreenStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? isFirstLaunch = preferences.getBool(PreferenceKeys.isEmployeeFirstLaunch);
    return isFirstLaunch ?? true;
  }

  

  static Future<void> userLogin({
    required String userId,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(PreferenceKeys.isUserLoggedIn, true);
    await preferences.setString(PreferenceKeys.userId, userId);
  }

  static Future<void> userLogout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(PreferenceKeys.isUserLoggedIn, false);
    await preferences.remove(PreferenceKeys.userId);
  }

  static Future<void> employeeLogin({
    required String employeeId,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(PreferenceKeys.isEmployeeLoggedIn, true);
    await preferences.setString(PreferenceKeys.employeeId, employeeId);
  }

   static Future<void> employeeLogout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(PreferenceKeys.isEmployeeLoggedIn, false);
    await preferences.remove(PreferenceKeys.employeeId);
  }

  static Future<bool> getUserLoginStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? isLoggedIn = preferences.getBool(PreferenceKeys.isUserLoggedIn);
    return isLoggedIn ?? false;
  }

  static Future<bool> getEmployeeLoginStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? isLoggedIn = preferences.getBool(PreferenceKeys.isEmployeeLoggedIn);
    return isLoggedIn ?? false;
  }


  static Future<String> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString(PreferenceKeys.userId);
    return userId ?? "0";
  }

  static Future<String> getEmployeeId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? empId = preferences.getString(PreferenceKeys.employeeId);
    return empId ?? "0";
  }

  static Future<void> setServerUrl(String url) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(PreferenceKeys.serverUrl, url);
  }

  static Future<String> getServerUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? url = preferences.getString(PreferenceKeys.serverUrl);
    return url ?? "https://mlrc33df-8000.inc1.devtunnels.ms/";
  }
}
