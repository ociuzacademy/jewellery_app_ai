// To parse this JSON data, do
//
//     final addtoWishlistModel = addtoWishlistModelFromJson(jsonString);

import 'dart:convert';

AddtoWishlistModel addtoWishlistModelFromJson(String str) => AddtoWishlistModel.fromJson(json.decode(str));

String addtoWishlistModelToJson(AddtoWishlistModel data) => json.encode(data.toJson());

class AddtoWishlistModel {
    String? message;
    WishlistItem? wishlistItem;

    AddtoWishlistModel({
        this.message,
        this.wishlistItem,
    });

    factory AddtoWishlistModel.fromJson(Map<String, dynamic> json) => AddtoWishlistModel(
        message: json["message"],
        wishlistItem: json["wishlist_item"] == null ? null : WishlistItem.fromJson(json["wishlist_item"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "wishlist_item": wishlistItem?.toJson(),
    };
}

class WishlistItem {
    int? id;
    int? user;
    int? product;
    String? size;
    String? weight;
    int? quantity;
    DateTime? createdAt;

    WishlistItem({
        this.id,
        this.user,
        this.product,
        this.size,
        this.weight,
        this.quantity,
        this.createdAt,
    });

    factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
        id: json["id"],
        user: json["user"],
        product: json["product"],
        size: json["size"],
        weight: json["weight"],
        quantity: json["quantity"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "product": product,
        "size": size,
        "weight": weight,
        "quantity": quantity,
        "created_at": createdAt?.toIso8601String(),
    };
}
