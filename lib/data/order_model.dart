// To parse this JSON data, do
//
//     final orderDisplay = orderDisplayFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

OrderDisplay orderDisplayFromJson(String str) =>
    OrderDisplay.fromJson(json.decode(str));

String orderDisplayToJson(OrderDisplay data) => json.encode(data.toJson());

class OrderDisplay {
  OrderDisplay({
    required this.orderDisplay,
    required this.message,
    required this.reason,
  });

  List<OrderDisplayElement> orderDisplay;
  String message;
  String reason;

  factory OrderDisplay.fromJson(Map<String, dynamic> json) => OrderDisplay(
        orderDisplay: List<OrderDisplayElement>.from(
            json["orderDisplay"].map((x) => OrderDisplayElement.fromJson(x))),
        message: json["message"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "orderDisplay": List<dynamic>.from(orderDisplay.map((x) => x.toJson())),
        "message": message,
        "reason": reason,
      };
}

class OrderDisplayElement {
  OrderDisplayElement({
    required this.username,
    required this.orderId,
    required this.statusPrepare,
    required this.createdDate,
    required this.quantity,
    required this.price,
  });

  String username;
  int orderId;
  String statusPrepare;
  String createdDate;
  int quantity;
  double price;

  factory OrderDisplayElement.fromJson(Map<String, dynamic> json) =>
      OrderDisplayElement(
        username: json["username"],
        orderId: json["order_id"],
        statusPrepare: json["status_prepare"],
        createdDate: DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(json["created_date"])),
        quantity: json["quantity"],
        price: double.parse(json["price"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "order_id": orderId,
        "status_prepare": statusPrepare,
        "created_date": createdDate,
        "quantity": quantity,
        "price": price,
      };
}
