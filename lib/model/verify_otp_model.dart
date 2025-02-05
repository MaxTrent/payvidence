class VerifyOtpModel {
  final bool success;
  final String message;
  final VerifyOtpData? data;

  VerifyOtpModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? VerifyOtpData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class VerifyOtpData {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String status;
  final String? profilePictureUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  VerifyOtpData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.status,
    this.profilePictureUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      status: json['status'],
      profilePictureUrl: json['profile_picture_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}