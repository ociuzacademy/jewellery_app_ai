// To parse this JSON data, do
//
//     final categoryListModel = categoryListModelFromJson(jsonString);

import 'dart:convert';

List<CategoryListModel> categoryListModelFromJson(String str) => List<CategoryListModel>.from(json.decode(str).map((x) => CategoryListModel.fromJson(x)));

String categoryListModelToJson(List<CategoryListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryListModel {
    int? id;
    String? name;
    String? iconUrl;

    CategoryListModel({
        this.id,
        this.name,
        this.iconUrl,
    });

    factory CategoryListModel.fromJson(Map<String, dynamic> json) => CategoryListModel(
        id: json["id"],
        name: json["name"],
        iconUrl: json["icon_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon_url": iconUrl,
    };
}
