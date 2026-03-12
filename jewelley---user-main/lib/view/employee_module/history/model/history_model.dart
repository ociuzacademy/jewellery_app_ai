// To parse this JSON data, do
//
//     final historyModel = historyModelFromJson(jsonString);

import 'dart:convert';

List<HistoryModel> historyModelFromJson(String str) => List<HistoryModel>.from(json.decode(str).map((x) => HistoryModel.fromJson(x)));

String historyModelToJson(List<HistoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HistoryModel {
    int? id;
    String? productName;
    String? productMainImage;
    String? size;
    String? weight;
    int? quantity;
    String? totalPrice;
    String? advanceFee;
    String? status;
    DateTime? createdAt;
    String? employeeName;
    String? bookingType;
    String? username;
    String? phoneNumber;
    String? email;
    dynamic address;
    DateTime? bookingDate;

    HistoryModel({
        this.id,
        this.productName,
        this.productMainImage,
        this.size,
        this.weight,
        this.quantity,
        this.totalPrice,
        this.advanceFee,
        this.status,
        this.createdAt,
        this.employeeName,
        this.bookingType,
        this.username,
        this.phoneNumber,
        this.email,
        this.address,
        this.bookingDate,
    });

    factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
        id: json["id"],
        productName: json["product_name"],
        productMainImage: json["product_main_image"],
        size: json["size"],
        weight: json["weight"],
        quantity: json["quantity"],
        totalPrice: json["total_price"],
        advanceFee: json["advance_fee"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        employeeName: json["employee_name"],
        bookingType: json["booking_type"],
        username: json["username"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        address: json["address"],
        bookingDate: json["booking_date"] == null ? null : DateTime.parse(json["booking_date"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "product_main_image": productMainImage,
        "size": size,
        "weight": weight,
        "quantity": quantity,
        "total_price": totalPrice,
        "advance_fee": advanceFee,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "employee_name": employeeName,
        "booking_type": bookingType,
        "username": username,
        "phone_number": phoneNumber,
        "email": email,
        "address": address,
        "booking_date": bookingDate?.toIso8601String(),
    };
}
