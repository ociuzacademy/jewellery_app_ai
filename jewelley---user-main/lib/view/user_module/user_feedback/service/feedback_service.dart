import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/user_module/user_feedback/model/feedback_model.dart';
import 'package:jewellery_app/view/utils/prefence_value.dart';

Future<UserFeedbackModel> userFeedbackService({
  required String rating,
  required String feedback,
}) async {
  try {
     String userId = await PreferenceValues.getUserId();
    Map<String, dynamic> param = {
      "user": userId,
      "rating": rating,
      "feedback_text" :feedback,
    };

    final resp = await http.post(
      Uri.parse(UserUrl.user_feedback), 
      body: jsonEncode(param),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (resp.statusCode == 201) {
      /**
       *  final List<dynamic> decoded = jsonDecode(resp.body);
      final response =
          decoded.map((item) => ProductModel.fromJson(item)).toList();
      return response;
       */

      final dynamic decoded = jsonDecode(resp.body);
      final response = UserFeedbackModel.fromJson(decoded);
          
      return response;
    } else {
      final Map<String, dynamic> errorResponse = jsonDecode(resp.body);
      throw Exception(
        'Failed to login: ${errorResponse['message'] ?? 'Unknown error'}',
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