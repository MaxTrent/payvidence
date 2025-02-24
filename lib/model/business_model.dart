class Business {
  final String id;
  final String accountId;
  final String name;
  final String address;
  final String phoneNumber;
  final String? logoUrl;
  final String issuer;
  final String issuerRole;
  final String? issuerSignatureUrl;
  final String? bankName;
  final String? accountNumber;
  final String? accountName;
  final int vat;
  final DateTime createdAt;
  final DateTime updatedAt;

  Business({
    required this.id,
    required this.accountId,
    required this.name,
    required this.address,
    required this.phoneNumber,
    this.logoUrl,
    required this.issuer,
    required this.issuerRole,
    this.issuerSignatureUrl,
    this.bankName,
    this.accountNumber,
    this.accountName,
    required this.vat,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
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
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }
}