import 'dart:convert';

class ClientModel {
  final String? id;
  final String? businessId;
  final String? name;
  final String? phoneNumber;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ClientModel({
    this.id,
    this.businessId,
    this.name,
    this.phoneNumber,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory ClientModel.fromRawJson(String str) => ClientModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
    id: json["id"],
    businessId: json["business_id"],
    name: json["name"],
    phoneNumber: json["phone_number"],
    address: json["address"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "business_id": businessId,
    "name": name,
    "phone_number": phoneNumber,
    "address": address,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
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