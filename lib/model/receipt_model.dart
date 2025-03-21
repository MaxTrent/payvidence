import 'dart:convert';

class Receipt {
  final String? id;
  final String? clientId;
  final String? businessId;
  final String? status;
  final dynamic modeOfPayment;
  final String? total;
  final dynamic publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<RecordProductDetail>? recordProductDetails;

  Receipt({
    this.id,
    this.clientId,
    this.businessId,
    this.status,
    this.modeOfPayment,
    this.total,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.recordProductDetails,
  });

  factory Receipt.fromRawJson(String str) => Receipt.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Receipt.fromJson(Map<String, dynamic> json) => Receipt(
    id: json["id"],
    clientId: json["client_id"],
    businessId: json["business_id"],
    status: json["status"],
    modeOfPayment: json["mode_of_payment"],
    total: json["total"],
    publishedAt: json["published_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    recordProductDetails: json["record_product_details"] == null ? [] : List<RecordProductDetail>.from(json["record_product_details"]!.map((x) => RecordProductDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "client_id": clientId,
    "business_id": businessId,
    "status": status,
    "mode_of_payment": modeOfPayment,
    "total": total,
    "published_at": publishedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "record_product_details": recordProductDetails == null ? [] : List<dynamic>.from(recordProductDetails!.map((x) => x.toJson())),
  };
}

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
  });

  factory RecordProductDetail.fromRawJson(String str) => RecordProductDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecordProductDetail.fromJson(Map<String, dynamic> json) => RecordProductDetail(
    id: json["id"],
    saleRecordId: json["sale_record_id"],
    productId: json["product_id"],
    quantity: json["quantity"],
    price: json["price"],
    discount: json["discount"],
    total: json["total"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
  };
}
