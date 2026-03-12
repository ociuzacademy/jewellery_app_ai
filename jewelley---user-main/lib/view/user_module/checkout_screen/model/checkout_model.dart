import 'dart:convert';

CheckOutUserDetailsModel checkOutUserDetailsModelFromJson(String str) => 
    CheckOutUserDetailsModel.fromJson(json.decode(str));

String checkOutUserDetailsModelToJson(CheckOutUserDetailsModel data) => 
    json.encode(data.toJson());

class CheckOutUserDetailsModel {
  int? id;
  int? user;
  String? userName;
  String? userEmail;
  String? userPhoneNumber;  // Changed from dynamic to String? for consistency
  String? totalPrice;
  String? advanceFee;

  CheckOutUserDetailsModel({
    this.id,
    this.user,
    this.userName,
    this.userEmail,
    this.userPhoneNumber,
    this.totalPrice,
    this.advanceFee,
  });

  factory CheckOutUserDetailsModel.fromJson(Map<String, dynamic> json) => CheckOutUserDetailsModel(
        id: json["id"] ?? 0,  // Default to 0 if null
        user: json["user"] ?? 0,  // Default to 0 if null
        userName: json["user_name"] ?? "Unknown",  // Default to "Unknown"
        userEmail: json["user_email"] ?? "No email",  
        userPhoneNumber: json["user_phone_number"]?.toString() ?? "No phone",  // Ensure String format
        totalPrice: json["total_price"] ?? "0.0",
        advanceFee: json["advance_fee"] ?? "0.0",
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "user": user ?? 0,
        "user_name": userName ?? "Unknown",
        "user_email": userEmail ?? "No email",
        "user_phone_number": userPhoneNumber ?? "No phone",
        "total_price": totalPrice ?? "0.0",
        "advance_fee": advanceFee ?? "0.0",
      };
}
