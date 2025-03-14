import 'dart:convert';

import 'brand_model.dart';
import 'category_model.dart';

class Product {
  final String? id;
  final String? name;
  final String? businessId;
  final String? categoryId;
  final String? brandId;
  final String? description;
  final String? logoUrl;
  final String? price;
  final int? quantitySold;
  final int? quantityAvailable;
  final String? vat;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final BrandModel? brand;
  final CategoryModel? category;

  Product({
    this.id,
    this.name,
    this.businessId,
    this.categoryId,
    this.brandId,
    this.description,
    this.logoUrl,
    this.price,
    this.quantitySold,
    this.quantityAvailable,
    this.vat,
    this.createdAt,
    this.updatedAt,
    this.brand,
    this.category,
  });

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    businessId: json["business_id"],
    categoryId: json["category_id"],
    brandId: json["brand_id"],
    description: json["description"],
    logoUrl: json["logo_url"],
    price: json["price"],
    quantitySold: json["quantity_sold"],
    quantityAvailable: json["quantity_available"],
    vat: json["vat"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    brand: json["brand"] == null ? null : BrandModel.fromJson(json["brand"]),
    category: json["category"] == null ? null : CategoryModel.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "business_id": businessId,
    "category_id": categoryId,
    "brand_id": brandId,
    "description": description,
    "logo_url": logoUrl,
    "price": price,
    "quantity_sold": quantitySold,
    "quantity_available": quantityAvailable,
    "vat": vat,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "brand": brand?.toJson(),
    "category": category?.toJson(),
  };
}

