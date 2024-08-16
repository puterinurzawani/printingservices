// To parse this JSON data, do
//
//     final sizedisplay = sizedisplayFromJson(jsonString);

import 'dart:convert';

Sizedisplay sizedisplayFromJson(String str) =>
    Sizedisplay.fromJson(json.decode(str));

String sizedisplayToJson(Sizedisplay data) => json.encode(data.toJson());

class Sizedisplay {
  Sizedisplay({
    required this.sizeDisplay,
    required this.message,
    required this.reason,
  });

  List<SizeDisplay> sizeDisplay;
  String message;
  String reason;

  factory Sizedisplay.fromJson(Map<String, dynamic> json) => Sizedisplay(
        sizeDisplay: List<SizeDisplay>.from(
            json["sizeDisplay"].map((x) => SizeDisplay.fromJson(x))),
        message: json["message"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "sizeDisplay": List<dynamic>.from(sizeDisplay.map((x) => x.toJson())),
        "message": message,
        "reason": reason,
      };
}

class SizeDisplay {
  SizeDisplay({
    required this.id,
    required this.sizeName,
    required this.price,
    required this.typeId,
  });

  int id;
  String sizeName;
  double price;
  int typeId;

  factory SizeDisplay.fromJson(Map<String, dynamic> json) => SizeDisplay(
        id: json["id"],
        sizeName: json["size_name"],
        price: json["price"]?.toDouble(),
        typeId: json["type_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "size_name": sizeName,
        "price": price,
        "type_id": typeId,
      };
}
