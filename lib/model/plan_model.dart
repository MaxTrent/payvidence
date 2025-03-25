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
  final String invoiceGenerationPerMonth;
  final String receiptGenerationPerMonth;
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
  final double amount; // Using double to handle potential decimals
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
      invoiceGenerationPerMonth: json['invoice_generation_per_month'] as String,
      receiptGenerationPerMonth: json['receipt_generation_per_month'] as String,
      salesReport: (json['sales_report'] as int) == 1,
      receiptSharing: (json['receipt_sharing'] as int) == 1,
      receiptPrinting: (json['receipt_printing'] as int) == 1,
      inventoryManagement: (json['inventory_management'] as int) == 1,
      pdfCsvExport: (json['pdf_csv_export'] as int) == 1,
      clientManagement: (json['client_management'] as int) == 1,
      brandManagement: (json['brand_management'] as int) == 1,
      letterheadTransaction: (json['letterhead_transaction'] as int) == 1,
      paymentInstructions: (json['payment_instructions'] as int) == 1,
      advancedReportingAndAnalytics: (json['advanced_reporting_and_analytics'] as int) == 1,
      templates: json['templates'] as int,
      isRecommended: (json['is_recommended'] as int) == 1,
      duration: json['duration'] as String,
      amount: (json['amount'] as num).toDouble(), // Convert to double for flexibility
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'business_accounts_allowed': businessAccountsAllowed,
      'invoice_generation_per_month': invoiceGenerationPerMonth,
      'receipt_generation_per_month': receiptGenerationPerMonth,
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
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// function to parse the full response from a raw JSON string
PlanResponse parsePlans(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
  return PlanResponse.fromJson(parsed);
}

// function to parse just the data list (if response is already decoded)
List<Plan> parsePlanList(dynamic data) {
  if (data is List<dynamic>) {
    return data.map((item) => Plan.fromJson(item as Map<String, dynamic>)).toList();
  }
  throw Exception('Expected a list of plans');
}