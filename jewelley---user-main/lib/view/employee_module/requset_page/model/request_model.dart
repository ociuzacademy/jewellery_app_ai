// To parse this JSON data, do
//
//     final requestViewModel = requestViewModelFromJson(jsonString);

import 'dart:convert';

List<RequestViewModel> requestViewModelFromJson(String str) => List<RequestViewModel>.from(json.decode(str).map((x) => RequestViewModel.fromJson(x)));

String requestViewModelToJson(List<RequestViewModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequestViewModel {
    UserDetails? userDetails;
    List<AssignedBooking>? assignedBookings;

    RequestViewModel({
        this.userDetails,
        this.assignedBookings,
    });

    factory RequestViewModel.fromJson(Map<String, dynamic> json) => RequestViewModel(
        userDetails: json["user_details"] == null ? null : UserDetails.fromJson(json["user_details"]),
        assignedBookings: json["assigned_bookings"] == null ? [] : List<AssignedBooking>.from(json["assigned_bookings"]!.map((x) => AssignedBooking.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "user_details": userDetails?.toJson(),
        "assigned_bookings": assignedBookings == null ? [] : List<dynamic>.from(assignedBookings!.map((x) => x.toJson())),
    };
}

class AssignedBooking {
    int? id;
    String? productName;
    String? productImage;
    String? size;
    String? weight;
    int? quantity;
    double? totalPrice;
    double? advanceFee;
    String? status;
    DateTime? bookingDate;
    DateTime? visitDate;
    String? source;

    AssignedBooking({
        this.id,
        this.productName,
        this.productImage,
        this.size,
        this.weight,
        this.quantity,
        this.totalPrice,
        this.advanceFee,
        this.status,
        this.bookingDate,
        this.visitDate,
        this.source,
    });

    factory AssignedBooking.fromJson(Map<String, dynamic> json) => AssignedBooking(
        id: json["id"],
        productName: json["product_name"],
        productImage: json["product_image"],
        size: json["size"],
        weight: json["weight"],
        quantity: json["quantity"],
        totalPrice: json["total_price"]?.toDouble(),
        advanceFee: json["advance_fee"]?.toDouble(),
        status: json["status"],
        bookingDate: json["booking_date"] == null ? null : DateTime.parse(json["booking_date"]),
        visitDate: json["visit_date"] == null ? null : DateTime.parse(json["visit_date"]),
        source: json["source"],
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
        "booking_date": bookingDate?.toIso8601String(),
        "visit_date": "${visitDate!.year.toString().padLeft(4, '0')}-${visitDate!.month.toString().padLeft(2, '0')}-${visitDate!.day.toString().padLeft(2, '0')}",
        "source": source,
    };
}

class UserDetails {
    int? userId;
    String? name;
    String? phoneNumber;
    String? email;
    dynamic address;

    UserDetails({
        this.userId,
        this.name,
        this.phoneNumber,
        this.email,
        this.address,
    });

    factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        userId: json["user_id"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "phone_number": phoneNumber,
        "email": email,
        "address": address,
    };
}
