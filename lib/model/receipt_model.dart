class Receipt {
  final String? id;
  final String? clientId;
  final String? businessId;
  final String? status;
  final String? modeOfPayment;
  final String? publishedAt;
  final double? total;
  final String? createdAt;
  final String? updatedAt;
  final List<RecordProductDetails>? recordProductDetails;

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

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'],
      clientId: json['client_id'],
      businessId: json['business_id'],
      status: json['status'],
      modeOfPayment: json['mode_of_payment'],
      total: json['total'] != null ? double.tryParse(json['total']) : null,
      publishedAt: json['published_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      recordProductDetails: json['record_product_details'] != null
          ? (json['record_product_details'] as List)
          .map((item) => RecordProductDetails.fromJson(item))
          .toList()
          : null,
    );
  }
}

class RecordProductDetails {
  final String? id;
  final String? saleRecordId;
  final String? productId;
  final int? quantity;
  final double? price;
  final double? discount;
  final double? total;
  final ReceiptProduct? product;

  RecordProductDetails({
    this.id,
    this.saleRecordId,
    this.productId,
    this.quantity,
    this.price,
    this.discount,
    this.total,
    this.product,
  });

  factory RecordProductDetails.fromJson(Map<String, dynamic> json) {
    return RecordProductDetails(
      id: json['id'],
      saleRecordId: json['sale_record_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: json['price'] != null ? double.tryParse(json['price']) : null,
      discount: json['discount'] != null ? double.tryParse(json['discount']) : null,
      total: json['total'] != null ? double.tryParse(json['total']) : null,
      product: json['product'] != null ? ReceiptProduct.fromJson(json['product']) : null,
    );
  }
}

class ReceiptProduct {
  final String? id;
  final String? name;
  final String? businessId;
  final String? categoryId;
  final String? brandId;
  final String? description;
  final String? logoUrl;
  final double? price;
  final int? quantitySold;
  final int? quantityAvailable;
  final double? vat;

  ReceiptProduct({
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
  });

  factory ReceiptProduct.fromJson(Map<String, dynamic> json) {
    return ReceiptProduct(
      id: json['id'],
      name: json['name'],
      businessId: json['business_id'],
      categoryId: json['category_id'],
      brandId: json['brand_id'],
      description: json['description'],
      logoUrl: json['logo_url'],
      price: json['price'] != null ? double.tryParse(json['price']) : null,
      quantitySold: json['quantity_sold'],
      quantityAvailable: json['quantity_available'],
      vat: json['vat'] != null ? double.tryParse(json['vat']) : null,
    );
  }
}
