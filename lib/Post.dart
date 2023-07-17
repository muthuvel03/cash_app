// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

List<Post> postFromJson(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
  String invoiceNumber;
  int invoiceId;
  String invoiceDiscount;
  int clientId;
  double amount;
  String clinicName;
  String clientName;
  dynamic address;
  String city;
  String mobileNo;
  DateTime dueDate;
  bool isRequestCompleted;
  String status;
  String inBalance;

  Post({
    required this.invoiceNumber,
    required this.invoiceId,
    required this.invoiceDiscount,
    required this.clientId,
    required this.amount,
    required this.clinicName,
    required this.clientName,
    this.address,
    required this.city,
    required this.mobileNo,
    required this.dueDate,
    required this.status,
    this.isRequestCompleted = false,
    required this.inBalance,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        invoiceNumber: json["Invoice Number"] ?? "",
        invoiceId: json["Invoice id"] ?? 0,
        invoiceDiscount: json["invoice_discount"] ?? "",
        clientId: json["client id"] ?? 0,
        amount: json["Amount"] != null ? double.parse(json["Amount"]) : 0.0,
        clinicName: json["clinic_name"] ?? "Clinic Name",
        clientName: json["client_name"] ?? "",
        address: json["address"],
        city: json["city"] ?? "",
        mobileNo: json["mobile_no"] ?? "",
        dueDate: json["due_date"] != null
            ? DateTime.parse(json["due_date"])
            : DateTime.now(),
        status: json['Status'] ?? "",
        inBalance: json["in_balance"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Invoice Number": invoiceNumber,
        "Invoice id": invoiceId,
        "invoice_discount": invoiceDiscount,
        "client id": clientId,
        "Amount": amount,
        "clinic_name": clinicName,
        "client_name": clientName,
        "address": address,
        "city": city,
        "mobile_no": mobileNo,
        "in_balance": inBalance,
        "due_date":
            "${dueDate.year.toString().padLeft(4, '0')}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}",
      };
}
