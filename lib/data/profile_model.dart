// To parse this JSON data, do
//
//     final displayProfile = displayProfileFromJson(jsonString);

import 'dart:convert';

DisplayProfile displayProfileFromJson(String str) =>
    DisplayProfile.fromJson(json.decode(str));

String displayProfileToJson(DisplayProfile data) => json.encode(data.toJson());

class DisplayProfile {
  DisplayProfile({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.message,
    required this.reason,
  });

  String username;
  String email;
  String phoneNumber;
  String message;
  String reason;

  factory DisplayProfile.fromJson(Map<String, dynamic> json) => DisplayProfile(
        username: json["username"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        message: json["message"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "phone_number": phoneNumber,
        "message": message,
        "reason": reason,
      };
}
