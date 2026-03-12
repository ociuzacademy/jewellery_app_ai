import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/user_module/single_product_payment/model/gpay_model.dart';

Future<GpaySingleModel> gpayService({
  required String upi_id,
  required String booking_id,
}) async {
  try {
    //String userId = await PreferenceValues.getUserId();
    Map<String, dynamic> param = {
      "upi_id": upi_id,
      "booking_id": booking_id,
    };

    final resp = await http.post(
      Uri.parse(UserUrl.single_gpay),
      body: jsonEncode(param),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (resp.statusCode == 201) {
      final dynamic decoded = jsonDecode(resp.body);
      final response = GpaySingleModel.fromJson(decoded);

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
