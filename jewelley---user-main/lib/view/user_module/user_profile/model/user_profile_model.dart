// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
    int? id;
    String? name;
    String? email;
    dynamic phoneNumber;
    dynamic address;
    dynamic profile;
    String? status;

    UserProfileModel({
        this.id,
        this.name,
        this.email,
        this.phoneNumber,
        this.address,
        this.profile,
        this.status,
    });

    factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        address: json["address"],
        profile: json["profile"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone_number": phoneNumber,
        "address": address,
        "profile": profile,
        "status": status,
    };
}
