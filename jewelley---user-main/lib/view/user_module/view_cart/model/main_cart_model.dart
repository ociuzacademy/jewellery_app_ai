// To parse this JSON data, do
//
//     final mainCartModel = mainCartModelFromJson(jsonString);

import 'dart:convert';

MainCartModel mainCartModelFromJson(String str) => MainCartModel.fromJson(json.decode(str));

String mainCartModelToJson(MainCartModel data) => json.encode(data.toJson());

class MainCartModel {
    String? status;
    List<CartItem>? cartItems;
    double? totalPrice;

    MainCartModel({
        this.status,
        this.cartItems,
        this.totalPrice,
    });

    factory MainCartModel.fromJson(Map<String, dynamic> json) => MainCartModel(
        status: json["status"],
        cartItems: json["cart_items"] == null ? [] : List<CartItem>.from(json["cart_items"]!.map((x) => CartItem.fromJson(x))),
        totalPrice: json["total_price"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "cart_items": cartItems == null ? [] : List<dynamic>.from(cartItems!.map((x) => x.toJson())),
        "total_price": totalPrice,
    };
}

class CartItem {
    int? id;
    String? productName;
    int? quantity;
    String? size;
    String? weight;
    double? singleItemPrice;
    double? itemTotalPrice;
    int? stock;
    String? productImage;

    CartItem({
        this.id,
        this.productName,
        this.quantity,
        this.size,
        this.weight,
        this.singleItemPrice,
        this.itemTotalPrice,
        this.stock,
        this.productImage,
    });

    factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"],
        productName: json["product_name"],
        quantity: json["quantity"],
        size: json["size"],
        weight: json["weight"],
        singleItemPrice: json["single_item_price"]?.toDouble(),
        itemTotalPrice: json["item_total_price"]?.toDouble(),
        stock: json["stock"],
        productImage: json["product_image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "quantity": quantity,
        "size": size,
        "weight": weight,
        "single_item_price": singleItemPrice,
        "item_total_price": itemTotalPrice,
        "stock": stock,
        "product_image": productImage,
    };
}
