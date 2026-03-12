import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/employee_module/requset_page/model/request_model.dart';
import 'package:jewellery_app/view/utils/prefence_value.dart';

Future<List<RequestViewModel>> requestViewService() async {
  try {
     String employeeId = await PreferenceValues.getEmployeeId();
    Map<String, dynamic> params = {
      'employee_id':employeeId,
    };
    final resp = await http.get(
      Uri.parse(UserUrl.request_view).replace(queryParameters: params),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    final List<dynamic> decoded = jsonDecode(resp.body);
    if (resp.statusCode == 200) {
      final response =
          decoded.map((item) => RequestViewModel.fromJson(item)).toList();
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
