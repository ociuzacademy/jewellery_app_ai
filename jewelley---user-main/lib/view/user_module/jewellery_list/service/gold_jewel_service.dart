import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/user_module/jewellery_list/model/gold_jewel_model.dart';

Future<List<ProductListModel>> productList({
  required String category_id,
}) async {
  try {
    Map<String, dynamic> params = {
      'category': category_id,
    };
    final resp = await http.get(
      Uri.parse(UserUrl.single_category)
          .replace(queryParameters: params),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    final List<dynamic> decoded = jsonDecode(resp.body);
    if (resp.statusCode == 200) {
      final response =
          decoded.map((item) => ProductListModel.fromJson(item)).toList();
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
