// To parse this JSON data, do
//
//     final changeStatusModel = changeStatusModelFromJson(jsonString);

import 'dart:convert';

ChangeStatusModel changeStatusModelFromJson(String str) => ChangeStatusModel.fromJson(json.decode(str));

String changeStatusModelToJson(ChangeStatusModel data) => json.encode(data.toJson());

class ChangeStatusModel {
    String? status;
    String? message;
    List<TBooking> productBookings;
    List<TBooking> cartBookings;

    ChangeStatusModel({
        this.status,
        this.message,
        List<TBooking>? productBookings,
        List<TBooking>? cartBookings,
    })  : productBookings = productBookings ?? [],
          cartBookings = cartBookings ?? [];

    factory ChangeStatusModel.fromJson(Map<String, dynamic> json) => ChangeStatusModel(
        status: json["status"],
        message: json["message"],
        productBookings: (json["product_bookings"] as List?)?.map((x) => TBooking.fromJson(x)).toList() ?? [],
        cartBookings: (json["cart_bookings"] as List?)?.map((x) => TBooking.fromJson(x)).toList() ?? [],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "product_bookings": productBookings.map((x) => x.toJson()).toList(),
        "cart_bookings": cartBookings.map((x) => x.toJson()).toList(),
    };
}

class TBooking {
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
    String? userName;
    String? employeeName;
    DateTime? bookingDate;

    TBooking({
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
        this.userName,
        this.employeeName,
        this.bookingDate,
    });

    factory TBooking.fromJson(Map<String, dynamic> json) => TBooking(
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
        userName: json["user_name"],
        employeeName: json["employee_name"],
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
        "user_name": userName,
        "employee_name": employeeName,
        "booking_date": bookingDate?.toIso8601String(),
    };
}
