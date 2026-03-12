// To parse this JSON data, do
//
//     final viewWishlistModel = viewWishlistModelFromJson(jsonString);

import 'dart:convert';

List<ViewWishlistModel> viewWishlistModelFromJson(String str) => List<ViewWishlistModel>.from(json.decode(str).map((x) => ViewWishlistModel.fromJson(x)));

String viewWishlistModelToJson(List<ViewWishlistModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ViewWishlistModel {
    int? id;
    int? user;
    int? product;
    String? productName;
    String? productPrice;
    String? productMainImage;
    DateTime? createdAt;

    ViewWishlistModel({
        this.id,
        this.user,
        this.product,
        this.productName,
        this.productPrice,
        this.productMainImage,
        this.createdAt,
    });

    factory ViewWishlistModel.fromJson(Map<String, dynamic> json) => ViewWishlistModel(
        id: json["id"],
        user: json["user"],
        product: json["product"],
        productName: json["product_name"],
        productPrice: json["product_price"],
        productMainImage: json["product_main_image"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "product": product,
        "product_name": productName,
        "product_price": productPrice,
        "product_main_image": productMainImage,
        "created_at": createdAt?.toIso8601String(),
    };
}
