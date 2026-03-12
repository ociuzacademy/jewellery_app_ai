// To parse this JSON data, do
//
//     final employeeLoginModel = employeeLoginModelFromJson(jsonString);

import 'dart:convert';

EmployeeLoginModel employeeLoginModelFromJson(String str) => EmployeeLoginModel.fromJson(json.decode(str));

String employeeLoginModelToJson(EmployeeLoginModel data) => json.encode(data.toJson());

class EmployeeLoginModel {
    String? message;
    int? employeeId;
    String? name;
    String? email;
    String? phone;

    EmployeeLoginModel({
        this.message,
        this.employeeId,
        this.name,
        this.email,
        this.phone,
    });

    factory EmployeeLoginModel.fromJson(Map<String, dynamic> json) => EmployeeLoginModel(
        message: json["message"],
        employeeId: json["employee_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "employee_id": employeeId,
        "name": name,
        "email": email,
        "phone": phone,
    };
}
