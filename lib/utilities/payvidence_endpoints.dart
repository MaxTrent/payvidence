class PayvidenceEndpoints{
  PayvidenceEndpoints():super();



  // Authentication Endpoints //
  static String get createAccount => '/api/account';
  static String verifyOtp(String userId) => '/api/account/$userId/verify-otp';
  static String resendOtp(String userId) => '/api/account/$userId/resend-otp';
  static String get login => '/api/account/login';
  static String get getAccount => '/api/account';
  static String get forgotPasswordInit => '/api/account/forgot-password';
  static String forgotPasswordComplete(String userId) => '/api/account/$userId/forgot-password/new-password';


  // Business Endpoints //
  static String get business => '/api/business/';
  //static String get createBusiness => '/api/business';

  // Product Endpoints
  static String get product => '/api/product';

  // Category Endpoints
  //static String get category => '/api/category/';

//Notification Endpoints
static String get getAllNotifications => '/api/notification';

}