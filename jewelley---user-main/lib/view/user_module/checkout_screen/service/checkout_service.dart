import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/user_module/checkout_screen/model/checkout_model.dart';

Future<CheckOutUserDetailsModel> checkoutService(
  {
    required String booking_id,
  }
  
) async {
  try {
     Map<String, dynamic> params = {
      'id': booking_id,
     };

    final resp = await http.get(
      Uri.parse(UserUrl.user_checkout).replace(queryParameters: params),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    if (resp.statusCode == 200) {

      final dynamic decoded = jsonDecode(resp.body);
      final response = CheckOutUserDetailsModel.fromJson(decoded);
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