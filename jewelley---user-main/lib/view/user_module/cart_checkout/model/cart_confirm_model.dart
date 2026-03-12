// To parse this JSON data, do
//
//     final cartCheckoutConfirmModel = cartCheckoutConfirmModelFromJson(jsonString);

import 'dart:convert';

CartCheckoutConfirmModel cartCheckoutConfirmModelFromJson(String str) => CartCheckoutConfirmModel.fromJson(json.decode(str));

String cartCheckoutConfirmModelToJson(CartCheckoutConfirmModel data) => json.encode(data.toJson());

class CartCheckoutConfirmModel {
    String? status;
    String? message;
    String? totalAdvanceFee;
    DateTime? visitDate;
    String? visitTime;
    List<Payment>? payments;

    CartCheckoutConfirmModel({
        this.status,
        this.message,
        this.totalAdvanceFee,
        this.visitDate,
        this.visitTime,
        this.payments,
    });

    factory CartCheckoutConfirmModel.fromJson(Map<String, dynamic> json) => CartCheckoutConfirmModel(
        status: json["status"],
        message: json["message"],
        totalAdvanceFee: json["total_advance_fee"],
        visitDate: json["visit_date"] == null ? null : DateTime.parse(json["visit_date"]),
        visitTime: json["visit_time"],
        payments: json["payments"] == null ? [] : List<Payment>.from(json["payments"]!.map((x) => Payment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "total_advance_fee": totalAdvanceFee,
        "visit_date": "${visitDate!.year.toString().padLeft(4, '0')}-${visitDate!.month.toString().padLeft(2, '0')}-${visitDate!.day.toString().padLeft(2, '0')}",
        "visit_time": visitTime,
        "payments": payments == null ? [] : List<dynamic>.from(payments!.map((x) => x.toJson())),
    };
}

class Payment {
    int? id;
    int? user;
    DateTime? visitDate;
    String? visitTime;
    DateTime? createdAt;

    Payment({
        this.id,
        this.user,
        this.visitDate,
        this.visitTime,
        this.createdAt,
    });

    factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        user: json["user"],
        visitDate: json["visit_date"] == null ? null : DateTime.parse(json["visit_date"]),
        visitTime: json["visit_time"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "visit_date": "${visitDate!.year.toString().padLeft(4, '0')}-${visitDate!.month.toString().padLeft(2, '0')}-${visitDate!.day.toString().padLeft(2, '0')}",
        "visit_time": visitTime,
        "created_at": createdAt?.toIso8601String(),
    };
}
