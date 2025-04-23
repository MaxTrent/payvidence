import 'dart:convert';

class ClientModel {
  final String id;
  final String businessId;
  final String name;
  final String phoneNumber;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClientModel({
    required this.id,
    required this.businessId,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClientModel.fromRawJson(String str) =>
      ClientModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
    id: json["id"] as String,
    businessId: json["business_id"] as String,
    name: json["name"] as String,
    phoneNumber: json["phone_number"] as String,
    address: json["address"] as String,
    createdAt: DateTime.parse(json["created_at"] as String),
    updatedAt: DateTime.parse(json["updated_at"] as String),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "business_id": businessId,
    "name": name,
    "phone_number": phoneNumber,
    "address": address,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };

  ClientModel copyWith({
    String? id,
    String? businessId,
    String? name,
    String? phoneNumber,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClientModel(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'ClientModel(id: $id, name: $name)';
}