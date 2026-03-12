import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/user_module/user_profile/model/user_profile_model.dart';
import 'package:jewellery_app/view/utils/prefence_value.dart';

Future<UserProfileModel> userProfileService() async {
  try {
    //final user_id =int.parse("2");
   String userId = await PreferenceValues.getUserId();

    Map<String, dynamic> params = {
      //'id': userId.toString(),
      'id' : userId,
    };

    final resp = await http.get(
      Uri.parse(UserUrl.user_profile).replace(queryParameters: params),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    //final List<dynamic> decoded = jsonDecode(resp.body);
    if (resp.statusCode == 200) {
      final dynamic decoded = jsonDecode(resp.body);
      final response = UserProfileModel.fromJson(decoded);
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
