import 'dart:convert';

import 'package:payvidence/model/business_model.dart';
import 'package:payvidence/model/client_model.dart';
import 'package:payvidence/model/record_product_details.dart';

class TransactionsResponse {
  final bool success;
  final String message;
  final List<Transaction> data;

  TransactionsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) {
    return TransactionsResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((transaction) => transaction.toJson()).toList(),
    };
  }
}

class Transaction {
  final String id;
  final String? clientId;
  final String businessId;
  final String status;
  final String? modeOfPayment;
  final double total;
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ClientModel client;
  final Business business;
  final List<RecordProductDetail> recordProductDetails;

  Transaction({
    required this.id,
    this.clientId,
    required this.businessId,
    required this.status,
    this.modeOfPayment,
    required this.total,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.client,
    required this.business,
    required this.recordProductDetails,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      clientId: json['client_id'] as String?,
      businessId: json['business_id'] as String,
      status: json['status'] as String,
      modeOfPayment: json['mode_of_payment'] as String?,
      total: double.parse(json['total'] as String),
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      client: ClientModel.fromJson(json['client'] as Map<String, dynamic>),
      business: json['business'] != null
          ? Business.fromJson(json['business'] as Map<String, dynamic>)
          : const Business(), // Fallback to empty Business if null
      recordProductDetails: (json['record_product_details'] as List<dynamic>)
          .map((item) =>
          RecordProductDetail.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'business_id': businessId,
      'status': status,
      'mode_of_payment': modeOfPayment,
      'total': total.toString(),
      'published_at': publishedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'client': client.toJson(),
      'business': business.toJson(),
      'record_product_details':
      recordProductDetails.map((detail) => detail.toJson()).toList(),
    };
  }
}