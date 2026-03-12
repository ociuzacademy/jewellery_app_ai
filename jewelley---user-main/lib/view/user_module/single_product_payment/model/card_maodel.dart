// To parse this JSON data, do
//
//     final cardSingleModel = cardSingleModelFromJson(jsonString);

import 'dart:convert';

CardSingleModel cardSingleModelFromJson(String str) => CardSingleModel.fromJson(json.decode(str));

String cardSingleModelToJson(CardSingleModel data) => json.encode(data.toJson());

class CardSingleModel {
    String? message;
    Data? data;

    CardSingleModel({
        this.message,
        this.data,
    });

    factory CardSingleModel.fromJson(Map<String, dynamic> json) => CardSingleModel(
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
    int? booking;

    Data({
        this.id,
        this.status,
        this.cardHolderName,
        this.cardNumber,
        this.expiryDate,
        this.cvv,
        this.booking,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        status: json["status"],
        cardHolderName: json["card_holder_name"],
        cardNumber: json["card_number"],
        expiryDate: json["expiry_date"],
        cvv: json["cvv"],
        booking: json["booking"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "card_holder_name": cardHolderName,
        "card_number": cardNumber,
        "expiry_date": expiryDate,
        "cvv": cvv,
        "booking": booking,
    };
}
