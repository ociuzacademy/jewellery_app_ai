// To parse this JSON data, do
//
//     final carCardtPayment = carCardtPaymentFromJson(jsonString);

import 'dart:convert';

CarCardtPayment carCardtPaymentFromJson(String str) => CarCardtPayment.fromJson(json.decode(str));

String carCardtPaymentToJson(CarCardtPayment data) => json.encode(data.toJson());

class CarCardtPayment {
    String? message;
    Data? data;

    CarCardtPayment({
        this.message,
        this.data,
    });

    factory CarCardtPayment.fromJson(Map<String, dynamic> json) => CarCardtPayment(
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
    String? cardHolderName;
    String? cardNumber;
    String? expiryDate;
    String? cvv;
    int? user;

    Data({
        this.id,
        this.status,
        this.cardHolderName,
        this.cardNumber,
        this.expiryDate,
        this.cvv,
        this.user,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        status: json["status"],
        cardHolderName: json["card_holder_name"],
        cardNumber: json["card_number"],
        expiryDate: json["expiry_date"],
        cvv: json["cvv"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "card_holder_name": cardHolderName,
        "card_number": cardNumber,
        "expiry_date": expiryDate,
        "cvv": cvv,
        "user": user,
    };
}
