import 'dart:convert';

EmpProfileModel empProfileModelFromJson(String str) => EmpProfileModel.fromJson(json.decode(str));

String empProfileModelToJson(EmpProfileModel data) => json.encode(data.toJson());

class EmpProfileModel {
  int? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? position;
  String? address;
  String? photo;
  DateTime? dateJoined;

  EmpProfileModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.phone,
    this.position,
    this.address,
    this.photo,
    this.dateJoined,
  });

  factory EmpProfileModel.fromJson(Map<String, dynamic> json) => EmpProfileModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        password: json["password"] ?? "",
        phone: json["phone"] ?? "",
        position: json["position"] ?? "",
        address: json["address"] ?? "",
        photo: json["photo"] ?? "",
        dateJoined: json["date_joined"] != null ? DateTime.tryParse(json["date_joined"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "name": name ?? "",
        "email": email ?? "",
        "password": password ?? "",
        "phone": phone ?? "",
        "position": position ?? "",
        "address": address ?? "",
        "photo": photo ?? "",
        "date_joined": dateJoined != null
            ? "${dateJoined!.year.toString().padLeft(4, '0')}-${dateJoined!.month.toString().padLeft(2, '0')}-${dateJoined!.day.toString().padLeft(2, '0')}"
            : null,
      };
}
