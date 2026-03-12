// To parse this JSON data, do
//
//     final confirmCheckoutModel = confirmCheckoutModelFromJson(jsonString);

import 'dart:convert';

ConfirmCheckoutModel confirmCheckoutModelFromJson(String str) => ConfirmCheckoutModel.fromJson(json.decode(str));

String confirmCheckoutModelToJson(ConfirmCheckoutModel data) => json.encode(data.toJson());

class ConfirmCheckoutModel {
    String? status;
    String? message;
    Data? data;
    double? advanceFee;
    int? bookingId;

    ConfirmCheckoutModel({
        this.status,
        this.message,
        this.data,
        this.advanceFee,
        this.bookingId,
    });

    factory ConfirmCheckoutModel.fromJson(Map<String, dynamic> json) => ConfirmCheckoutModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        advanceFee: json["advance_fee"]?.toDouble(),
        bookingId: json["booking_id"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
        "advance_fee": advanceFee,
        "booking_id": bookingId,
    };
}

class Data {
    int? id;
    int? user;
    int? booking;
    String? advanceFee;
    DateTime? visitDate;
    String? visitTime;
    DateTime? createdAt;

    Data({
        this.id,
        this.user,
        this.booking,
        this.advanceFee,
        this.visitDate,
        this.visitTime,
        this.createdAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        user: json["user"],
        booking: json["booking"],
        advanceFee: json["advance_fee"],
        visitDate: json["visit_date"] == null ? null : DateTime.parse(json["visit_date"]),
        visitTime: json["visit_time"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "booking": booking,
        "advance_fee": advanceFee,
        "visit_date": "${visitDate!.year.toString().padLeft(4, '0')}-${visitDate!.month.toString().padLeft(2, '0')}-${visitDate!.day.toString().padLeft(2, '0')}",
        "visit_time": visitTime,
        "created_at": createdAt?.toIso8601String(),
    };
}
