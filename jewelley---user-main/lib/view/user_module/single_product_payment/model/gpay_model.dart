// To parse this JSON data, do
//
//     final gpaySingleModel = gpaySingleModelFromJson(jsonString);

import 'dart:convert';

GpaySingleModel gpaySingleModelFromJson(String str) => GpaySingleModel.fromJson(json.decode(str));

String gpaySingleModelToJson(GpaySingleModel data) => json.encode(data.toJson());

class GpaySingleModel {
    String? status;
    Data? data;

    GpaySingleModel({
        this.status,
        this.data,
    });

    factory GpaySingleModel.fromJson(Map<String, dynamic> json) => GpaySingleModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    int? id;
    String? status;
    String? upiId;
    int? booking;

    Data({
        this.id,
        this.status,
        this.upiId,
        this.booking,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        status: json["status"],
        upiId: json["upi_id"],
        booking: json["booking"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "upi_id": upiId,
        "booking": booking,
    };
}
