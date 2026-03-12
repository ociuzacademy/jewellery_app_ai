// To parse this JSON data, do
//
//     final cartItemModel = cartItemModelFromJson(jsonString);

import 'dart:convert';

CartItemModel cartItemModelFromJson(String str) => CartItemModel.fromJson(json.decode(str));

String cartItemModelToJson(CartItemModel data) => json.encode(data.toJson());

class CartItemModel {
    String? status;
    String? message;
    CartItem? cartItem;

    CartItemModel({
        this.status,
        this.message,
        this.cartItem,
    });

    factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        status: json["status"],
        message: json["message"],
        cartItem: json["cart_item"] == null ? null : CartItem.fromJson(json["cart_item"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "cart_item": cartItem?.toJson(),
    };
}

class CartItem {
    int? userId;
    int? productId;
    String? size;
    String? weight;
    int? quantity;
    String? totalPrice;
    String? advanceFee;
    String? status;

    CartItem({
        this.userId,
        this.productId,
        this.size,
        this.weight,
        this.quantity,
        this.totalPrice,
        this.advanceFee,
        this.status,
    });

    factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        userId: json["user_id"],
        productId: json["product_id"],
        size: json["size"],
        weight: json["weight"],
        quantity: json["quantity"],
        totalPrice: json["total_price"],
        advanceFee: json["advance_fee"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "product_id": productId,
        "size": size,
        "weight": weight,
        "quantity": quantity,
        "total_price": totalPrice,
        "advance_fee": advanceFee,
        "status": status,
    };
}
