import 'dart:convert';
import 'package:payvidence/model/product_model.dart';

class RecordProductDetail {
  final String? id;
  final String? saleRecordId;
  final String? productId;
  final int? quantity;
  final String? price;
  final String? discount;
  final String? total;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Product? product;

  RecordProductDetail({
    this.id,
    this.saleRecordId,
    this.productId,
    this.quantity,
    this.price,
    this.discount,
    this.total,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  factory RecordProductDetail.fromRawJson(String str) =>
      RecordProductDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecordProductDetail.fromJson(Map<String, dynamic> json) =>
      RecordProductDetail(
        id: json["id"] as String?,
        saleRecordId: json["sale_record_id"] as String?,
        productId: json["product_id"] as String?,
        quantity: json["quantity"] as int?,
        price: json["price"] as String?,
        discount: json["discount"] as String?,
        total: json["total"] as String?,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"] as String),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"] as String),
        product:
        json["product"] == null ? null : Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sale_record_id": saleRecordId,
    "product_id": productId,
    "quantity": quantity,
    "price": price,
    "discount": discount,
    "total": total,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "product": product?.toJson(),
  };
}