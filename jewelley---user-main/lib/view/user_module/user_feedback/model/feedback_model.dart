// To parse this JSON data, do
//
//     final userFeedbackModel = userFeedbackModelFromJson(jsonString);

import 'dart:convert';

UserFeedbackModel userFeedbackModelFromJson(String str) => UserFeedbackModel.fromJson(json.decode(str));

String userFeedbackModelToJson(UserFeedbackModel data) => json.encode(data.toJson());

class UserFeedbackModel {
    Data? data;
    String? status;
    String? message;

    UserFeedbackModel({
        this.data,
        this.status,
        this.message,
    });

    factory UserFeedbackModel.fromJson(Map<String, dynamic> json) => UserFeedbackModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "status": status,
        "message": message,
    };
}

class Data {
    int? id;
    int? user;
    int? rating;
    String? feedbackText;
    DateTime? createdAt;

    Data({
        this.id,
        this.user,
        this.rating,
        this.feedbackText,
        this.createdAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        user: json["user"],
        rating: json["rating"],
        feedbackText: json["feedback_text"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "rating": rating,
        "feedback_text": feedbackText,
        "created_at": createdAt?.toIso8601String(),
    };
}
