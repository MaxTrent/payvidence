import 'dart:convert';

class Subscription {
  final String id;
  final String planId;
  final String accountId;
  final DateTime startDate;
  final DateTime expiryDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Plan plan;
  final Transaction transaction;

  Subscription({
    required this.id,
    required this.planId,
    required this.accountId,
    required this.startDate,
    required this.expiryDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.plan,
    required this.transaction,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      planId: json['plan_id'],
      accountId: json['account_id'],
      startDate: DateTime.parse(json['start_date']),
      expiryDate: DateTime.parse(json['expiry_date']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      plan: Plan.fromJson(json['plan']),
      transaction: Transaction.fromJson(json['transaction']),
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
  final String amount;
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
      id: json['id'],
      name: json['name'],
      businessAccountsAllowed: json['business_accounts_allowed'],
      invoiceGenerationPerMonth: json['invoice_generation_per_month'],
      receiptGenerationPerMonth: json['receipt_generation_per_month'],
      salesReport: json['sales_report'],
      receiptSharing: json['receipt_sharing'],
      receiptPrinting: json['receipt_printing'],
      inventoryManagement: json['inventory_management'],
      pdfCsvExport: json['pdf_csv_export'],
      clientManagement: json['client_management'],
      brandManagement: json['brand_management'],
      letterheadTransaction: json['letterhead_transaction'],
      paymentInstructions: json['payment_instructions'],
      advancedReportingAndAnalytics: json['advanced_reporting_and_analytics'],
      templates: json['templates'],
      isRecommended: json['is_recommended'],
      duration: json['duration'],
      amount: json['amount'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Transaction {
  final String id;
  final String subscriptionId;
  final String reference;
  final String status;
  final double amount;
  final String currency;
  final String? gatewayResponse;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.subscriptionId,
    required this.reference,
    required this.status,
    required this.amount,
    required this.currency,
    this.gatewayResponse,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      subscriptionId: json['subscription_id'],
      reference: json['reference'],
      status: json['status'],
      amount: double.parse(json['amount']),
      currency: json['currency'],
      gatewayResponse: json['gateway_response'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}


List<Subscription> parseSubscriptionsList(dynamic data) {
  if (data is List) {
    return data.map((json) => Subscription.fromJson(json as Map<String, dynamic>)).toList();
  } else if (data is Map<String, dynamic>) {
    return [Subscription.fromJson(data)];
  }
  throw Exception("Expected a list or map of subscriptions");
}


List<Subscription> parseSubscriptions(String responseBody) {
  final parsed = jsonDecode(responseBody)['data'] as List;
  return parsed.map((json) => Subscription.fromJson(json)).toList();
}