import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/user_module/cart_checkout/model/cart_checkout_model.dart';
import 'package:jewellery_app/view/utils/prefence_value.dart';


Future<CartCheckoutModel> cartCheckoutScreen(
  
) async {
  try {
     String userId = await PreferenceValues.getUserId();
     Map<String, dynamic> params = {
      'user_id': userId,
     };

    final resp = await http.get(
      Uri.parse(UserUrl.cart_checkout).replace(queryParameters: params),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    if (resp.statusCode == 200) {

      final dynamic decoded = jsonDecode(resp.body);
      final response = CartCheckoutModel.fromJson(decoded);
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