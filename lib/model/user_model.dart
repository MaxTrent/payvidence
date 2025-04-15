class User {
  final Account account;
  final String? token;
  final String? refreshToken;

  User({required this.account, this.token, this.refreshToken});

  factory User.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('account')) {
      return User(
        account: Account.fromJson(json['account'] as Map<String, dynamic>),
        token: json['token'] as String?,
        refreshToken: json['refresh_token'] as String?,
      );
    } else {
      return User(
        account: Account.fromJson(json),
        token: json['token'] as String?,
        refreshToken: json['refresh_token'] as String?,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'account': account.toJson(),
      'token': token,
      'refresh_token': refreshToken,
    };
  }

  User copyWith({Account? account, String? token, String? refreshToken}) {
    return User(
      account: account ?? this.account,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

class Account {
  final String? id;
  final String firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? status;
  final String? profilePictureUrl;
  final bool? transactionalAlerts;
  final bool? promotionalUpdates;
  final bool? securityAlerts;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Account({
    this.id,
    required this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.status,
    this.profilePictureUrl,
    this.transactionalAlerts = false,
    this.promotionalUpdates = false,
    this.securityAlerts = false,
    this.createdAt,
    this.updatedAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String?,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      status: json['status'] as String?,
      profilePictureUrl: json['profile_picture_url'] as String?,
      transactionalAlerts: json['transactional_alerts'] as bool?,
      promotionalUpdates: json['promotional_updates'] as bool?,
      securityAlerts: json['security_alerts'] as bool?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
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
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Account copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? status,
    String? profilePictureUrl,
    bool? transactionalAlerts,
    bool? promotionalUpdates,
    bool? securityAlerts,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Account(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      transactionalAlerts: transactionalAlerts ?? this.transactionalAlerts,
      promotionalUpdates: promotionalUpdates ?? this.promotionalUpdates,
      securityAlerts: securityAlerts ?? this.securityAlerts,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}