import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/user_module/cart_product_payment/model/cart_card_model.dart';
import 'package:jewellery_app/view/utils/prefence_value.dart';


Future<CarCardtPayment> cartCardPayService({
  required String name,
  required String card_number,
  required String expiry_date,
  required String cvv,
}) async {
  try {
    String userId = await PreferenceValues.getUserId();
    Map<String, dynamic> param = {
      "user_id": userId,
      "card_holder_name": name,
      "card_number": card_number,
      "expiry_date": expiry_date,
      "cvv": cvv,
    };

    final resp = await http.post(
      Uri.parse(UserUrl.cart_card_payment),
      body: jsonEncode(param),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (resp.statusCode == 201) {
      final dynamic decoded = jsonDecode(resp.body);
      final response = CarCardtPayment.fromJson(decoded);

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
