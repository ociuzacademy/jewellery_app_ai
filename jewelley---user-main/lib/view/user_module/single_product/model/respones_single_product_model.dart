// To parse this JSON data, do
//
//     final singleProductResponesModel = singleProductResponesModelFromJson(jsonString);

import 'dart:convert';

SingleProductResponesModel singleProductResponesModelFromJson(String str) => SingleProductResponesModel.fromJson(json.decode(str));

String singleProductResponesModelToJson(SingleProductResponesModel data) => json.encode(data.toJson());

class SingleProductResponesModel {
    String? status;
    String? message;
    int? bookingId;

    SingleProductResponesModel({
        this.status,
        this.message,
        this.bookingId,
    });

    factory SingleProductResponesModel.fromJson(Map<String, dynamic> json) => SingleProductResponesModel(
        status: json["status"],
        message: json["message"],
        bookingId: json["booking_id"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "booking_id": bookingId,
    };
}
