import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/user_module/registration/model/register_model.dart';


Future<UserRegisterModel>userRegistrationService({
  required String name,
  required String email,
  required String password,
  required String phone,
  
 
}) async {
  try {
    Map<String, dynamic> param = {
      "name": name,
      "email": email,
      "password": password,
      "phone":phone,
      
    };

    final response = await http.post(
      Uri.parse(UserUrl.user_register),
      body: jsonEncode(param),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
  final dynamic decoded = jsonDecode(response.body);
    if (response.statusCode == 201) {
    
      final response = UserRegisterModel.fromJson(decoded);

      return response;
    } else {
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      throw Exception(
        'Failed to register: ${errorResponse['message'] ?? 'Unknown error'}',
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
