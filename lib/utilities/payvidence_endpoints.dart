class PayvidenceEndpoints{
  PayvidenceEndpoints():super();



  // Authentication Endpoints //
  static String get createAccount => '/api/account';
  static String get verifyOtp => '/api/account/9dccbdc2-d0e7-4ce9-9032-1602bb01caaa/verify-otp';
  static String get resendOtp => '/api/account/9da9b5f3-e42c-4cba-816d-fca35fdd49b3/resend-otp';
  static String get login => '/api/account/login';
  static String get getAccount => '/api/account';

  // Business Endpoints //
  static String get business => '/api/business/';
  //static String get createBusiness => '/api/business';

  // Product Endpoints
  static String get product => '/api/product';
  static String get saleRecord => '/api/sale-record';

  // Category Endpoints
  //static String get category => '/api/category/';
}