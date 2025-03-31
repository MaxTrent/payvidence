import 'dart:convert';

class PlanResponse {
  final bool success;
  final String message;
  final List<Plan> data;

  PlanResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PlanResponse.fromJson(Map<String, dynamic> json) {
    return PlanResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => Plan.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Plan {
  final String id;
  final String name;
  final int businessAccountsAllowed;
  final int invoiceGenerationPerMonth;
  final int receiptGenerationPerMonth;
  final bool salesReport;
  final bool receiptSharing;
  final bool receiptPrinting;
  final bool inventoryManagement;
  final bool pdfCsvExport;
  final bool clientManagement;
  final bool brandManagement;
  final bool letterheadTransaction;
  final bool paymentInstructions;
  final bool advancedReportingAndAnalytics;
  final int templates;
  final bool isRecommended;
  final String duration;
  final double amount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Plan({
    required this.id,
    required this.name,
    required this.businessAccountsAllowed,
    required this.invoiceGenerationPerMonth,
    required this.receiptGenerationPerMonth,
    required this.salesReport,
    required this.receiptSharing,
    required this.receiptPrinting,
    required this.inventoryManagement,
    required this.pdfCsvExport,
    required this.clientManagement,
    required this.brandManagement,
    required this.letterheadTransaction,
    required this.paymentInstructions,
    required this.advancedReportingAndAnalytics,
    required this.templates,
    required this.isRecommended,
    required this.duration,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] as String,
      name: json['name'] as String,
      businessAccountsAllowed: json['business_accounts_allowed'] as int,
      invoiceGenerationPerMonth:
          int.parse(json['invoice_generation_per_month'] as String),
      receiptGenerationPerMonth:
          int.parse(json['receipt_generation_per_month'] as String),
      salesReport: json['sales_report'] as bool,
      receiptSharing: json['receipt_sharing'] as bool,
      receiptPrinting: json['receipt_printing'] as bool,
      inventoryManagement: json['inventory_management'] as bool,
      pdfCsvExport: json['pdf_csv_export'] as bool,
      clientManagement: json['client_management'] as bool,
      brandManagement: json['brand_management'] as bool,
      letterheadTransaction: json['letterhead_transaction'] as bool,
      paymentInstructions: json['payment_instructions'] as bool,
      advancedReportingAndAnalytics:
          json['advanced_reporting_and_analytics'] as bool,
      templates: json['templates'] as int,
      isRecommended: json['is_recommended'] as bool,
      duration: json['duration'] as String,
      amount: double.parse(json['amount'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'business_accounts_allowed': businessAccountsAllowed,
      'invoice_generation_per_month': invoiceGenerationPerMonth.toString(),
      'receipt_generation_per_month': receiptGenerationPerMonth.toString(),
      'sales_report': salesReport ? 1 : 0,
      'receipt_sharing': receiptSharing ? 1 : 0,
      'receipt_printing': receiptPrinting ? 1 : 0,
      'inventory_management': inventoryManagement ? 1 : 0,
      'pdf_csv_export': pdfCsvExport ? 1 : 0,
      'client_management': clientManagement ? 1 : 0,
      'brand_management': brandManagement ? 1 : 0,
      'letterhead_transaction': letterheadTransaction ? 1 : 0,
      'payment_instructions': paymentInstructions ? 1 : 0,
      'advanced_reporting_and_analytics': advancedReportingAndAnalytics ? 1 : 0,
      'templates': templates,
      'is_recommended': isRecommended ? 1 : 0,
      'duration': duration,
      'amount': amount.toString(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

PlanResponse parsePlans(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
  return PlanResponse.fromJson(parsed);
}

List<Plan> parsePlanList(dynamic data) {
  if (data is List<dynamic>) {
    return data
        .map((item) => Plan.fromJson(item as Map<String, dynamic>))
        .toList();
  }
  throw Exception('Expected a list of plans');
}
