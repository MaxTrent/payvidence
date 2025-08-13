import 'dart:convert';
import 'package:payvidence/model/product_model.dart';

class RecordProductDetail {
  final String? id;
  final String? saleRecordId;
  final String? recordId;
  final String? productId;
  final int? quantity;
  final String? price;
  final String? discount;
  final String? total;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Product? product;
  final bool? isService;

  RecordProductDetail({
    this.id,
    this.saleRecordId,
    this.recordId,
    this.productId,
    this.quantity,
    this.price,
    this.discount,
    this.total,
    this.createdAt,
    this.updatedAt,
    this.product,
    this.isService,
  });

  factory RecordProductDetail.fromRawJson(String str) =>
      RecordProductDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecordProductDetail.fromJson(Map<String, dynamic> json) {
    // Handle quantity which might be an int or a string
    int? quantity;
    if (json["quantity"] != null) {
      if (json["quantity"] is int) {
        quantity = json["quantity"] as int;
      } else if (json["quantity"] is String) {
        quantity = int.tryParse(json["quantity"] as String);
      }
    } else if (json["quantity_purchased"] != null) {
      if (json["quantity_purchased"] is int) {
        quantity = json["quantity_purchased"] as int;
      } else if (json["quantity_purchased"] is String) {
        quantity = int.tryParse(json["quantity_purchased"] as String);
      }
    }
    
    // Handle item_type to determine if it's a service
    bool isService = false;
    if (json["is_service"] != null) {
      isService = json["is_service"] as bool? ?? false;
    } else if (json["item_type"] != null) {
      isService = (json["item_type"] as String?)?.toLowerCase() == "service";
    } else if (json["service_id"] != null) {
      isService = true;
    }
    
    // Handle product ID which might be product_id or service_id
    String? productId = json["product_id"] as String?;
    if (productId == null && isService) {
      productId = json["service_id"] as String?;
    }
    
    // Debug: Print available keys for product name debugging
    print("RecordProductDetail JSON keys: ${json.keys.toList()}");
    if (!isService && json["product_id"] != null) {
      print("Product ID: ${json["product_id"]}");
    }
    
    return RecordProductDetail(
      id: json["id"] as String?,
      saleRecordId: json["sale_record_id"] as String?,
      recordId: json["record_id"] as String?,
      productId: productId,
      quantity: quantity,
      price: json["price"]?.toString(),
      discount: json["discount"]?.toString(),
      total: json["total"]?.toString(),
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"].toString()),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"].toString()),
      product: json["product"] != null ? Product.fromJson(json["product"]) :
              json["item"] != null ? Product.fromJson(json["item"]) :
              json["name"] != null ? Product(
                name: json["name"] as String?,
                price: json["price"]?.toString(),
                quantitySold: json["quantity_purchased"] is int ? json["quantity_purchased"] : 
                             json["quantity_purchased"] is String ? int.tryParse(json["quantity_purchased"]) : null,
              ) : isService && json["item"] != null ? Product(
                id: json["service_id"] as String?,
                name: (json["item"] as Map<String, dynamic>)["name"] as String? ?? "Service",
                price: json["price"]?.toString(),
              ) : Product(
                id: json["product_id"] as String?,
                name: null, // We'll look up the name using the product provider
                price: json["price"]?.toString(),
              ),
      isService: isService,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "sale_record_id": saleRecordId,
    "record_id": recordId,
    "product_id": productId,
    "quantity": quantity,
    "price": price,
    "discount": discount,
    "total": total,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "product": product?.toJson(),
    "is_service": isService,
  };
}