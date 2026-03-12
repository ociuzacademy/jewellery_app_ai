import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/employee_module/requset_page/model/user_meet_model.dart';
import 'package:jewellery_app/view/utils/prefence_value.dart';

Future<ChangeStatusModel> changeStatusService({
  required String user_id,
}) async {
  try {

     String employeeId = await PreferenceValues.getEmployeeId();
    Map<String, dynamic> param = {
      "employee_id": employeeId,
      "user_id": user_id,
    };

    final resp = await http.patch(
      Uri.parse(UserUrl.userMeet),
      body: jsonEncode(param),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (resp.statusCode == 200) {
      final dynamic decoded = jsonDecode(resp.body);
      final response = ChangeStatusModel.fromJson(decoded);

      return response;
    } else {
      final Map<String, dynamic> errorResponse = jsonDecode(resp.body);
      throw Exception(
        '${errorResponse['message'] ?? 'Unknown error'}',
      );
    }
  } on SocketException {
    throw Exception('No Internet connection');
  } on HttpException {
    throw Exception('Server error');
  } on FormatException {
    throw Exception('Bad response format');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
}
