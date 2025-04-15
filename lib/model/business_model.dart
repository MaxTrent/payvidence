import 'dart:convert';

import 'package:equatable/equatable.dart';

class Business extends Equatable {
  final String? id;
  final String? accountId;
  final String? name;
  final String? address;
  final String? phoneNumber;
  final String? logoUrl;
  final String? issuer;
  final String? issuerRole;
  final String? issuerSignatureUrl;
  final dynamic bankName;
  final dynamic accountNumber;
  final dynamic accountName;
  final dynamic noOfReceipts;
  final dynamic noOfInvoices;
  final int? vat;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Business({
    this.id,
    this.accountId,
    this.name,
    this.address,
    this.phoneNumber,
    this.logoUrl,
    this.issuer,
    this.issuerRole,
    this.issuerSignatureUrl,
    this.bankName,
    this.accountNumber,
    this.accountName,
    this.vat,
    this.createdAt,
    this.updatedAt,
    this.noOfReceipts,
    this.noOfInvoices,
  });

  @override
  List<Object?> get props => [
        id,
        accountId,
        name,
        address,
        phoneNumber,
        logoUrl,
        issuer,
        issuerRole,
        issuerSignatureUrl,
        bankName,
        accountNumber,
        accountName,
        vat,
        noOfReceipts,
        noOfInvoices,
        createdAt,
        updatedAt,
      ];

  factory Business.fromRawJson(String str) =>
      Business.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Business.fromJson(Map<String, dynamic> json) => Business(
        id: json["id"],
        accountId: json["account_id"],
        name: json["name"],
        address: json["address"],
        phoneNumber: json["phone_number"],
        logoUrl: json["logo_url"],
        issuer: json["issuer"],
        issuerRole: json["issuer_role"],
        issuerSignatureUrl: json["issuer_signature_url"],
        bankName: json["bank_name"],
        accountNumber: json["account_number"],
        accountName: json["account_name"],
        vat: json["vat"],
        noOfInvoices: json["no_of_invoices"],
        noOfReceipts: json["no_of_receipts"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "account_id": accountId,
        "name": name,
        "address": address,
        "phone_number": phoneNumber,
        "logo_url": logoUrl,
        "issuer": issuer,
        "issuer_role": issuerRole,
        "issuer_signature_url": issuerSignatureUrl,
        "bank_name": bankName,
        "account_number": accountNumber,
        "account_name": accountName,
        "vat": vat,
        "no_of_receipts": noOfReceipts,
        "no_of_invoices": noOfInvoices,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
