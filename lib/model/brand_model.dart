import 'dart:convert';

class BrandModel {
  final String? id;
  final String? businessId;
  final String? name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BrandModel({
    this.id,
    this.businessId,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory BrandModel.fromRawJson(String str) =>
      BrandModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
        id: json["id"],
        businessId: json["business_id"],
        name: json["name"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "business_id": businessId,
        "name": name,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
