// To parse this JSON data, do
//
//     final singleProductModel = singleProductModelFromJson(jsonString);

import 'dart:convert';

List<SingleProductModel> singleProductModelFromJson(String str) => List<SingleProductModel>.from(json.decode(str).map((x) => SingleProductModel.fromJson(x)));

String singleProductModelToJson(List<SingleProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SingleProductModel {
    int? id;
    int? category;
    String? categoryName;
    String? subcategory;
    String? name;
    String? description;
    String? price;
    int? stock;
    String? mainImage;
    List<String>? images;
    List<String>? sizes;
    List<String>? weights;

    SingleProductModel({
        this.id,
        this.category,
        this.categoryName,
        this.subcategory,
        this.name,
        this.description,
        this.price,
        this.stock,
        this.mainImage,
        this.images,
        this.sizes,
        this.weights,
    });

    factory SingleProductModel.fromJson(Map<String, dynamic> json) => SingleProductModel(
        id: json["id"],
        category: json["category"],
        categoryName: json["category_name"],
        subcategory: json["subcategory"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        stock: json["stock"],
        mainImage: json["main_image"],
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
        sizes: json["sizes"] == null ? [] : List<String>.from(json["sizes"]!.map((x) => x)),
        weights: json["weights"] == null ? [] : List<String>.from(json["weights"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "category_name": categoryName,
        "subcategory": subcategory,
        "name": name,
        "description": description,
        "price": price,
        "stock": stock,
        "main_image": mainImage,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "sizes": sizes == null ? [] : List<dynamic>.from(sizes!.map((x) => x)),
        "weights": weights == null ? [] : List<dynamic>.from(weights!.map((x) => x)),
    };
}
