import 'dart:convert';
import 'package:payvidence/model/business_model.dart';
import 'package:payvidence/model/client_model.dart';
import 'package:payvidence/model/record_product_details.dart';

class Receipt {
  final String? id;
  final String? clientId;
  final String? businessId;
  final String? status;
  final String? modeOfPayment;
  final String? total;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ClientModel? client;
  final Business? business;
  final List<RecordProductDetail> recordProductDetails;

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
    this.client,
    required this.recordProductDetails,
    this.business,
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
    publishedAt: json["published_at"] == null
        ? null
        : DateTime.parse(json["published_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    client: json["client"] == null
        ? null
        : ClientModel.fromJson(json["client"]),
    business: json["business"] == null
        ? null
        : Business.fromJson(json["business"]),
    recordProductDetails: json["record_product_details"] == null
        ? []
        : List<RecordProductDetail>.from(json["record_product_details"]!
        .map((x) => RecordProductDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "client_id": clientId,
    "business_id": businessId,
    "status": status,
    "mode_of_payment": modeOfPayment,
    "total": total,
    "published_at": publishedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "client": client?.toJson(),
    "business": business?.toJson(),
    "record_product_details":
    List<dynamic>.from(recordProductDetails.map((x) => x.toJson())),
  };
}