import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/user_module/wishlist/model/wishlist_model.dart';
import 'package:jewellery_app/view/utils/prefence_value.dart';

Future<List<ViewWishlistModel>> wishlistViewService() async {
  try {

    String userId = await PreferenceValues.getUserId();
    Map<String, dynamic> params = {
      'user':userId,
    };
    final resp = await http.get(
      Uri.parse(UserUrl.view_wishlist).replace(queryParameters: params),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    print('Status Code: ${resp.statusCode}');
    print('Response Body: ${resp.body}');

    if (resp.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(resp.body);
      final response = decoded.map((item) => ViewWishlistModel.fromJson(item)).toList();
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