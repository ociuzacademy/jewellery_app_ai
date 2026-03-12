import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/user_module/single_product/model/cart_model.dart';
import 'package:jewellery_app/view/utils/prefence_value.dart';

Future<CartItemModel> toCartService({
  required String product_id,
  
}) async {
  try {
    String userId = await PreferenceValues.getUserId();
    Map<String, dynamic> param = {
      "user_id": userId,
      "product_id": product_id,
      
     
    };

    final resp = await http.post(
      Uri.parse(UserUrl.wishlist_to_cart),
      body: jsonEncode(param),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (resp.statusCode == 201) {
      final dynamic decoded = jsonDecode(resp.body);
      final response = CartItemModel.fromJson(decoded);

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
