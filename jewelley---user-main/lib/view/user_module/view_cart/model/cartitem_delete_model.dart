// To parse this JSON data, do
//
//     final cartDeleteModel = cartDeleteModelFromJson(jsonString);

import 'dart:convert';

CartDeleteModel cartDeleteModelFromJson(String str) => CartDeleteModel.fromJson(json.decode(str));

String cartDeleteModelToJson(CartDeleteModel data) => json.encode(data.toJson());

class CartDeleteModel {
    String? status;
    String? message;

    CartDeleteModel({
        this.status,
        this.message,
    });

    factory CartDeleteModel.fromJson(Map<String, dynamic> json) => CartDeleteModel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
