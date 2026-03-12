// To parse this JSON data, do
//
//     final cartCheckoutModel = cartCheckoutModelFromJson(jsonString);

import 'dart:convert';

CartCheckoutModel cartCheckoutModelFromJson(String str) => CartCheckoutModel.fromJson(json.decode(str));

String cartCheckoutModelToJson(CartCheckoutModel data) => json.encode(data.toJson());

class CartCheckoutModel {
    String? status;
    int? id;
    int? user;
    String? userName;
    String? userEmail;
    String? userPhoneNumber;
    String? totalPrice;
    String? advanceFee;

    CartCheckoutModel({
        this.status,
        this.id,
        this.user,
        this.userName,
        this.userEmail,
        this.userPhoneNumber,
        this.totalPrice,
        this.advanceFee,
    });

    factory CartCheckoutModel.fromJson(Map<String, dynamic> json) => CartCheckoutModel(
        status: json["status"],
        id: json["id"],
        user: json["user"],
        userName: json["user_name"],
        userEmail: json["user_email"],
        userPhoneNumber: json["user_phone_number"],
        totalPrice: json["total_price"],
        advanceFee: json["advance_fee"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "id": id,
        "user": user,
        "user_name": userName,
        "user_email": userEmail,
        "user_phone_number": userPhoneNumber,
        "total_price": totalPrice,
        "advance_fee": advanceFee,
    };
}
