// To parse this JSON data, do
//
//     final bookingHistoryMoldel = bookingHistoryMoldelFromJson(jsonString);

import 'dart:convert';

BookingHistoryMoldel bookingHistoryMoldelFromJson(String str) => BookingHistoryMoldel.fromJson(json.decode(str));

String bookingHistoryMoldelToJson(BookingHistoryMoldel data) => json.encode(data.toJson());

class BookingHistoryMoldel {
    String? status;
    List<TBooking>? productBookings;
    List<TBooking>? cartBookings;

    BookingHistoryMoldel({
        this.status,
        this.productBookings,
        this.cartBookings,
    });

    factory BookingHistoryMoldel.fromJson(Map<String, dynamic> json) => BookingHistoryMoldel(
        status: json["status"],
        productBookings: json["product_bookings"] == null ? [] : List<TBooking>.from(json["product_bookings"]!.map((x) => TBooking.fromJson(x))),
        cartBookings: json["cart_bookings"] == null ? [] : List<TBooking>.from(json["cart_bookings"]!.map((x) => TBooking.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "product_bookings": productBookings == null ? [] : List<dynamic>.from(productBookings!.map((x) => x.toJson())),
        "cart_bookings": cartBookings == null ? [] : List<dynamic>.from(cartBookings!.map((x) => x.toJson())),
    };
}

class TBooking {
    int? id;
    String? productName;
    String? productImage;
    String? size;
    String? weight;
    int? quantity;
    String? totalPrice;
    String? advanceFee;
    String? status;
    DateTime? createdAt;
    String? assignedEmployeeName;
    DateTime? bookingDate;

    TBooking({
        this.id,
        this.productName,
        this.productImage,
        this.size,
        this.weight,
        this.quantity,
        this.totalPrice,
        this.advanceFee,
        this.status,
        this.createdAt,
        this.assignedEmployeeName,
        this.bookingDate,
    });

    factory TBooking.fromJson(Map<String, dynamic> json) => TBooking(
        id: json["id"],
        productName: json["product_name"],
        productImage: json["product_image"],
        size: json["size"],
        weight: json["weight"],
        quantity: json["quantity"],
        totalPrice: json["total_price"],
        advanceFee: json["advance_fee"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        assignedEmployeeName: json["assigned_employee_name"],
        bookingDate: json["booking_date"] == null ? null : DateTime.parse(json["booking_date"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "product_image": productImage,
        "size": size,
        "weight": weight,
        "quantity": quantity,
        "total_price": totalPrice,
        "advance_fee": advanceFee,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "assigned_employee_name": assignedEmployeeName,
        "booking_date": bookingDate?.toIso8601String(),
    };
}
