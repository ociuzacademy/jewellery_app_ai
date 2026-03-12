// To parse this JSON data, do
//
//     final tocartModel = tocartModelFromJson(jsonString);

import 'dart:convert';

TocartModel tocartModelFromJson(String str) => TocartModel.fromJson(json.decode(str));

String tocartModelToJson(TocartModel data) => json.encode(data.toJson());

class TocartModel {
    String? message;
    CartItem? cartItem;

    TocartModel({
        this.message,
        this.cartItem,
    });

    factory TocartModel.fromJson(Map<String, dynamic> json) => TocartModel(
        message: json["message"],
        cartItem: json["cart_item"] == null ? null : CartItem.fromJson(json["cart_item"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "cart_item": cartItem?.toJson(),
    };
}

class CartItem {
    int? productId;
    String? size;
    String? weight;
    int? quantity;
    String? totalPrice;
    String? advanceFee;

    CartItem({
        this.productId,
        this.size,
        this.weight,
        this.quantity,
        this.totalPrice,
        this.advanceFee,
    });

    factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json["product_id"],
        size: json["size"],
        weight: json["weight"],
        quantity: json["quantity"],
        totalPrice: json["total_price"],
        advanceFee: json["advance_fee"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "size": size,
        "weight": weight,
        "quantity": quantity,
        "total_price": totalPrice,
        "advance_fee": advanceFee,
    };
}
