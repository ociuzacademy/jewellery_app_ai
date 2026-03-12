import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/user_module/booking_history/model/history_model.dart';
import 'package:jewellery_app/view/utils/prefence_value.dart';


Future<BookingHistoryMoldel>viewBookingsService(
 
) async {
  try {
    String userId = await PreferenceValues.getUserId();
     Map<String, dynamic> params = {
      'user_id': userId,
     };
    final resp = await http.get(
      Uri.parse(UserUrl.history).replace(queryParameters: params),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    //final dynamic decoded = jsonDecode(resp.body);
    if (resp.statusCode == 200) {

      final dynamic decoded = jsonDecode(resp.body);
      final response = BookingHistoryMoldel.fromJson(decoded);
          
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