// To parse this JSON data, do
//
//     final userLoginModel = userLoginModelFromJson(jsonString);

import 'dart:convert';

UserRegisterModel userLoginModelFromJson(String str) => UserRegisterModel.fromJson(json.decode(str));

String userLoginModelToJson(UserRegisterModel data) => json.encode(data.toJson());

class UserRegisterModel {
    String? message;
    int? userId;
    String? role;

    UserRegisterModel({
        this.message,
        this.userId,
        this.role,
    });

    factory UserRegisterModel.fromJson(Map<String, dynamic> json) => UserRegisterModel(
        message: json["message"],
        userId: json["user_id"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "user_id": userId,
        "role": role,
    };
}
