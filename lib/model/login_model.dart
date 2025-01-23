class LoginModel {
  final bool success;
  final String message;
  final LoginData data;

  LoginModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: LoginData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class LoginData {
  final Account account;
  final String? token;

  LoginData({
    required this.account,
    required this.token,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      account: Account.fromJson(json['account'] as Map<String, dynamic>),
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account': account.toJson(),
      'token': token,
    };
  }
}

class Account {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String status;
  final String? profilePictureUrl;
  final bool transactionalAlerts;
  final bool promotionalUpdates;
  final bool securityAlerts;
  final DateTime createdAt;
  final DateTime updatedAt;

  Account({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.status,
    this.profilePictureUrl,
    required this.transactionalAlerts,
    required this.promotionalUpdates,
    required this.securityAlerts,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      status: json['status'] as String,
      profilePictureUrl: json['profile_picture_url'] as String?,
      transactionalAlerts: json['transactional_alerts'] as bool,
      promotionalUpdates: json['promotional_updates'] as bool,
      securityAlerts: json['security_alerts'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'status': status,
      'profile_picture_url': profilePictureUrl,
      'transactional_alerts': transactionalAlerts,
      'promotional_updates': promotionalUpdates,
      'security_alerts': securityAlerts,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}