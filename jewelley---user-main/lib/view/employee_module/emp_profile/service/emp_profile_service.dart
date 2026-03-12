import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/employee_module/emp_profile/model/emp_profile_model.dart';
import 'package:jewellery_app/view/utils/prefence_value.dart';

Future<EmpProfileModel> empProfileService() async {
  try {
    //final user_id =int.parse("2");
   String employeeId = await PreferenceValues.getEmployeeId();

    Map<String, dynamic> params = {
      //'id': userId.toString(),
      'id' : employeeId,
    };

    final resp = await http.get(
      Uri.parse(UserUrl.emp_profile_view).replace(queryParameters: params),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
  
    if (resp.statusCode == 200) {
      final dynamic decoded = jsonDecode(resp.body);
      final response = EmpProfileModel.fromJson(decoded);
      return response;
    } else {
      throw Exception('Failed to load response');
    }
  } on SocketException {
    throw Exception('Server error');
  } on HttpException {
    throw Exception('Something went wrong');
  } on FormatException {
    throw Exception('Bad request');
  } catch (e) {
    throw Exception(e.toString());
  }
}
