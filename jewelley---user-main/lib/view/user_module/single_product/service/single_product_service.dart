import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/user_module/single_product/model/single_product_model.dart';

Future<SingleProductModel> singleProductService(
  {
    required String product_id,
  }
  
) async {
  try {
     Map<String, dynamic> params = {
      'product_id': product_id,
     };
    final resp = await http.get(
      Uri.parse(UserUrl.single_category).replace(queryParameters: params),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    //final dynamic decoded = jsonDecode(resp.body);
    if (resp.statusCode == 200) {

      final dynamic decoded = jsonDecode(resp.body);
      final response = SingleProductModel.fromJson(decoded);
          
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