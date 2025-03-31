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
  static String get resetPasswordInit => '/api/account/reset-password';
  static String get resetPasswordComplete => '/api/account/reset-password/new-password';
  static String get changePassword => '/api/account/change-password';
  static String get logout => '/api/account/logout';

  //Profile Endpoints
  static String get updateProfilePicture => '/api/account/profile-picture';


  // Business Endpoints //
  static String get business => '/api/business/';
  //static String get createBusiness => '/api/business';

  // Product Endpoints
  static String get product => '/api/product';
  static String get saleRecord => '/api/sale-record';
  static String get analytics => '/api/analytics/sales';

  // Category Endpoints
  //static String get category => '/api/category/';

//Notification Endpoints
static String get getAllNotifications => '/api/notification';
static String getOneNotification(String notificationId) => '/api/notification/$notificationId';
static String markNotificationAsRead(String notificationId) => '/api/notification/$notificationId';


//Transaction Endpoints
static String get getAllTransactions => '/api/sale-record';


//Client Endpoints
static String createClient(String businessId) => "/api/business/$businessId/client";
static String getClient(String businessId, String clientId) => "/api/business/$businessId/client/$clientId";
static String listClients(String businessId) => "/api/business/$businessId/client";
static String deleteClient(String businessId, String clientId) => "/api/business/$businessId/client/$clientId";
static String updateClient(String businessId, String clientId) => "/api/business/$businessId/client/$clientId";

//Subscription Endpoints
static String get createSubscription => '/api/subscription';
static String getSubcriptionById(String subId) => '/api/subscription/$subId';
static String get listSubscriptions => '/api/subscription';


//Plan Endpoints
static String get getPlans => '/api/plan';
static String  getOnePlan(String planId) => '/api/plan/$planId';
}