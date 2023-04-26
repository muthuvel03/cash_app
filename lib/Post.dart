// To parse this JSON data, do
//
//     final post = postFromMap(jsonString);

import 'dart:convert';

class Post {
  Post({
    this.invoiceNumber,
    this.amount,
    this.clinicName,
    this.address,
    this.city,
    required this.dueDate,
    this.message,
  });

  String? invoiceNumber;
  String? amount;
  String? clinicName;
  String? address;
  String? city;
  DateTime dueDate;
  String? message;

  factory Post.fromJson(Map<String, dynamic> m) => Post.fromMap(m);

  String toJson() => json.encode(toMap());

  factory Post.fromMap(Map<String, dynamic> json) => Post(
    invoiceNumber: json["invoice_number"],
    amount: json["amount"],
    clinicName: json["clinic_name"],
    address: json["address"],
    city: json["city"],
    dueDate: DateTime.parse(json["due_date"]),
    message: json["message"],
  );

  Map<String, dynamic> toMap() => {
    "invoice_number": invoiceNumber,
    "amount": amount,
    "clinic_name": clinicName,
    "address": address,
    "city": city,
    "due_date":
    "${dueDate.year.toString().padLeft(4, '0')}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}",
    "message": message,
  };
}