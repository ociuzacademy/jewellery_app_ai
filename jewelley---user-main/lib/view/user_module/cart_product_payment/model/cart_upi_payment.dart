// To parse this JSON data, do
//
//     final cartUpiPayment = cartUpiPaymentFromJson(jsonString);

import 'dart:convert';

CartUpiPayment cartUpiPaymentFromJson(String str) => CartUpiPayment.fromJson(json.decode(str));

String cartUpiPaymentToJson(CartUpiPayment data) => json.encode(data.toJson());

class CartUpiPayment {
    String? message;
    Data? data;

    CartUpiPayment({
        this.message,
        this.data,
    });

    factory CartUpiPayment.fromJson(Map<String, dynamic> json) => CartUpiPayment(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    int? id;
    String? status;
    String? upiId;
    int? user;

    Data({
        this.id,
        this.status,
        this.upiId,
        this.user,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        status: json["status"],
        upiId: json["upi_id"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "upi_id": upiId,
        "user": user,
    };
}
