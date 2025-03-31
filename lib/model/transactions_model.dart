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
  final Client client;
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
      client: Client.fromJson(json['client'] as Map<String, dynamic>),
      business: Business.fromJson(json['business'] as Map<String, dynamic>),
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

class Client {
  final String id;
  final String businessId;
  final String name;
  final String phoneNumber;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;

  Client({
    required this.id,
    required this.businessId,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
      address: json['address'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_id': businessId,
      'name': name,
      'phone_number': phoneNumber,
      'address': address,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Business {
  final String id;
  final String accountId;
  final String name;
  final String address;
  final String phoneNumber;
  final String logoUrl;
  final String issuer;
  final String issuerRole;
  final String issuerSignatureUrl;
  final String bankName;
  final String accountNumber;
  final String accountName;
  final DateTime createdAt;
  final DateTime updatedAt;

  Business({
    required this.id,
    required this.accountId,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.logoUrl,
    required this.issuer,
    required this.issuerRole,
    required this.issuerSignatureUrl,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] as String,
      accountId: json['account_id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phoneNumber: json['phone_number'] as String,
      logoUrl: json['logo_url'] as String,
      issuer: json['issuer'] as String,
      issuerRole: json['issuer_role'] as String,
      issuerSignatureUrl: json['issuer_signature_url'] as String,
      bankName: json['bank_name'] as String,
      accountNumber: json['account_number'] as String,
      accountName: json['account_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_id': accountId,
      'name': name,
      'address': address,
      'phone_number': phoneNumber,
      'logo_url': logoUrl,
      'issuer': issuer,
      'issuer_role': issuerRole,
      'issuer_signature_url': issuerSignatureUrl,
      'bank_name': bankName,
      'account_number': accountNumber,
      'account_name': accountName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class RecordProductDetail {
  final String id;
  final String saleRecordId;
  final String productId;
  final int quantity;
  final double price;
  final double discount;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Product product;

  RecordProductDetail({
    required this.id,
    required this.saleRecordId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.discount,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory RecordProductDetail.fromJson(Map<String, dynamic> json) {
    return RecordProductDetail(
      id: json['id'] as String,
      saleRecordId: json['sale_record_id'] as String,
      productId: json['product_id'] as String,
      quantity: json['quantity'] as int,
      price: double.parse(json['price'] as String),
      discount: double.parse(json['discount'] as String),
      total: double.parse(json['total'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sale_record_id': saleRecordId,
      'product_id': productId,
      'quantity': quantity,
      'price': price.toString(),
      'discount': discount.toString(),
      'total': total.toString(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'product': product.toJson(),
    };
  }
}

class Product {
  final String id;
  final String name;
  final String businessId;
  final String categoryId;
  final String brandId;
  final String description;
  final String logoUrl;
  final double price;
  final int quantitySold;
  final int quantityAvailable;
  final double vat;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.businessId,
    required this.categoryId,
    required this.brandId,
    required this.description,
    required this.logoUrl,
    required this.price,
    required this.quantitySold,
    required this.quantityAvailable,
    required this.vat,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      businessId: json['business_id'] as String,
      categoryId: json['category_id'] as String,
      brandId: json['brand_id'] as String,
      description: json['description'] as String,
      logoUrl: json['logo_url'] as String,
      price: double.parse(json['price'] as String),
      quantitySold: json['quantity_sold'] as int,
      quantityAvailable: json['quantity_available'] as int,
      vat: double.parse(json['vat'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'business_id': businessId,
      'category_id': categoryId,
      'brand_id': brandId,
      'description': description,
      'logo_url': logoUrl,
      'price': price.toString(),
      'quantity_sold': quantitySold,
      'quantity_available': quantityAvailable,
      'vat': vat.toString(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
