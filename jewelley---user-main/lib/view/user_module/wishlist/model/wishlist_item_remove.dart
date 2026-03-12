// To parse this JSON data, do
//
//     final itemRemoveWishlistModel = itemRemoveWishlistModelFromJson(jsonString);

import 'dart:convert';

ItemRemoveWishlistModel itemRemoveWishlistModelFromJson(String str) => ItemRemoveWishlistModel.fromJson(json.decode(str));

String itemRemoveWishlistModelToJson(ItemRemoveWishlistModel data) => json.encode(data.toJson());

class ItemRemoveWishlistModel {
    String? status;
    String? message;

    ItemRemoveWishlistModel({
        this.status,
        this.message,
    });

    factory ItemRemoveWishlistModel.fromJson(Map<String, dynamic> json) => ItemRemoveWishlistModel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
