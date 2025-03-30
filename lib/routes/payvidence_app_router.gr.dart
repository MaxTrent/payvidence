// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i63;
import 'package:flutter/cupertino.dart' as _i68;
import 'package:flutter/material.dart' as _i64;
import 'package:payvidence/model/business_model.dart' as _i66;
import 'package:payvidence/model/product_model.dart' as _i65;
import 'package:payvidence/model/receipt_model.dart' as _i67;
import 'package:payvidence/screens/account_success/account_success.dart' as _i1;
import 'package:payvidence/screens/add_brand/add_brand.dart' as _i2;
import 'package:payvidence/screens/add_business/add_business.dart' as _i3;
import 'package:payvidence/screens/add_business_success/add_business_success.dart'
    as _i4;
import 'package:payvidence/screens/add_category/add_category.dart' as _i5;
import 'package:payvidence/screens/add_client/add_client.dart' as _i6;
import 'package:payvidence/screens/add_product/add_product.dart' as _i7;
import 'package:payvidence/screens/add_product_success/add_product_success.dart'
    as _i8;
import 'package:payvidence/screens/all_businesses/all_businesses.dart' as _i9;
import 'package:payvidence/screens/all_invoices/all_invoices.dart' as _i10;
import 'package:payvidence/screens/all_receipts/all_receipts.dart' as _i11;
import 'package:payvidence/screens/all_receipts/receipt_screen.dart' as _i51;
import 'package:payvidence/screens/all_transactions/all_transactions.dart'
    as _i12;
import 'package:payvidence/screens/brands/brands.dart' as _i13;
import 'package:payvidence/screens/business_data/business_data.dart' as _i14;
import 'package:payvidence/screens/business_detail/business_detail.dart'
    as _i15;
import 'package:payvidence/screens/category/category.dart' as _i29;
import 'package:payvidence/screens/change_password/change_password.dart'
    as _i16;
import 'package:payvidence/screens/change_password_success/change_password_success.dart'
    as _i17;
import 'package:payvidence/screens/change_profile_picture/change_profile_picture.dart'
    as _i18;
import 'package:payvidence/screens/choose_subscription_plan/choose_subscription_plan.dart'
    as _i19;
import 'package:payvidence/screens/client_details/client_details.dart' as _i20;
import 'package:payvidence/screens/client_success/client_success.dart' as _i21;
import 'package:payvidence/screens/clients/clients.dart' as _i22;
import 'package:payvidence/screens/complete_draft/complete_draft.dart' as _i23;
import 'package:payvidence/screens/create_account/create_account.dart' as _i24;
import 'package:payvidence/screens/create_new_password/create_new_password.dart'
    as _i25;
import 'package:payvidence/screens/create_new_password_reset/create_new_password_reset.dart'
    as _i26;
import 'package:payvidence/screens/drafts/drafts.dart' as _i27;
import 'package:payvidence/screens/empty_business/empty_business.dart' as _i28;
import 'package:payvidence/screens/forgot_password/forgot_password.dart'
    as _i30;
import 'package:payvidence/screens/generate_invoices/generate_invoices.dart'
    as _i31;
import 'package:payvidence/screens/generate_receipt/generate_receipt.dart'
    as _i32;
import 'package:payvidence/screens/invoice/invoice.dart' as _i35;
import 'package:payvidence/screens/login/login.dart' as _i36;
import 'package:payvidence/screens/my_subscription/my_subscription.dart'
    as _i37;
import 'package:payvidence/screens/nav_screens/home.dart' as _i34;
import 'package:payvidence/screens/nav_screens/home_page.dart' as _i33;
import 'package:payvidence/screens/notification_settings/notification_settings.dart'
    as _i38;
import 'package:payvidence/screens/notifications/notifications.dart' as _i39;
import 'package:payvidence/screens/onboarding/onboarding.dart' as _i40;
import 'package:payvidence/screens/otp/otp.dart' as _i43;
import 'package:payvidence/screens/otp_login/otp_login.dart' as _i41;
import 'package:payvidence/screens/otp_reset/otp_reset.dart' as _i42;
import 'package:payvidence/screens/payment_screen/payment_screen.dart' as _i44;
import 'package:payvidence/screens/payvidence_info/payvidence_info.dart'
    as _i45;
import 'package:payvidence/screens/privacy_and_security/privacy_and_security.dart'
    as _i46;
import 'package:payvidence/screens/product/product.dart' as _i47;
import 'package:payvidence/screens/product_details/product_details.dart'
    as _i48;
import 'package:payvidence/screens/profile/profile.dart' as _i49;
import 'package:payvidence/screens/receipt/receipt.dart' as _i50;
import 'package:payvidence/screens/reset_password/reset_password.dart' as _i52;
import 'package:payvidence/screens/reset_password_success/reset_password_success.dart'
    as _i53;
import 'package:payvidence/screens/sales/sales.dart' as _i54;
import 'package:payvidence/screens/select_client/select_client.dart' as _i55;
import 'package:payvidence/screens/settings/settings.dart' as _i56;
import 'package:payvidence/screens/subscription_plans/subscription_plans.dart'
    as _i57;
import 'package:payvidence/screens/subscription_prompt/subscription_prompt.dart'
    as _i58;
import 'package:payvidence/screens/update_bank_details/update_bank_details.dart'
    as _i59;
import 'package:payvidence/screens/update_personal_details/update_personal_details.dart'
    as _i60;
import 'package:payvidence/screens/update_quantity/update_quantity.dart'
    as _i61;
import 'package:payvidence/screens/upgrade_subscription/upgrade_subscription.dart'
    as _i62;

/// generated route for
/// [_i1.AccountSuccessScreen]
class AccountSuccessRoute extends _i63.PageRouteInfo<void> {
  const AccountSuccessRoute({List<_i63.PageRouteInfo>? children})
      : super(
          AccountSuccessRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountSuccessRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i1.AccountSuccessScreen();
    },
  );
}

/// generated route for
/// [_i2.AddBrand]
class AddBrandRoute extends _i63.PageRouteInfo<AddBrandRouteArgs> {
  AddBrandRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          AddBrandRoute.name,
          args: AddBrandRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AddBrandRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddBrandRouteArgs>(
          orElse: () => const AddBrandRouteArgs());
      return _i2.AddBrand(key: args.key);
    },
  );
}

class AddBrandRouteArgs {
  const AddBrandRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'AddBrandRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.AddBusiness]
class AddBusinessRoute extends _i63.PageRouteInfo<AddBusinessRouteArgs> {
  AddBusinessRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          AddBusinessRoute.name,
          args: AddBusinessRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AddBusinessRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddBusinessRouteArgs>(
          orElse: () => const AddBusinessRouteArgs());
      return _i3.AddBusiness(key: args.key);
    },
  );
}

class AddBusinessRouteArgs {
  const AddBusinessRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'AddBusinessRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i4.AddBusinessSuccess]
class AddBusinessSuccessRoute extends _i63.PageRouteInfo<void> {
  const AddBusinessSuccessRoute({List<_i63.PageRouteInfo>? children})
      : super(
          AddBusinessSuccessRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddBusinessSuccessRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i4.AddBusinessSuccess();
    },
  );
}

/// generated route for
/// [_i5.AddCategory]
class AddCategoryRoute extends _i63.PageRouteInfo<AddCategoryRouteArgs> {
  AddCategoryRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          AddCategoryRoute.name,
          args: AddCategoryRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AddCategoryRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddCategoryRouteArgs>(
          orElse: () => const AddCategoryRouteArgs());
      return _i5.AddCategory(key: args.key);
    },
  );
}

class AddCategoryRouteArgs {
  const AddCategoryRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'AddCategoryRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i6.AddClient]
class AddClientRoute extends _i63.PageRouteInfo<AddClientRouteArgs> {
  AddClientRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          AddClientRoute.name,
          args: AddClientRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AddClientRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddClientRouteArgs>(
          orElse: () => const AddClientRouteArgs());
      return _i6.AddClient(key: args.key);
    },
  );
}

class AddClientRouteArgs {
  const AddClientRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'AddClientRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i7.AddProduct]
class AddProductRoute extends _i63.PageRouteInfo<AddProductRouteArgs> {
  AddProductRoute({
    _i64.Key? key,
    _i65.Product? product,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          AddProductRoute.name,
          args: AddProductRouteArgs(
            key: key,
            product: product,
          ),
          initialChildren: children,
        );

  static const String name = 'AddProductRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddProductRouteArgs>(
          orElse: () => const AddProductRouteArgs());
      return _i7.AddProduct(
        key: args.key,
        product: args.product,
      );
    },
  );
}

class AddProductRouteArgs {
  const AddProductRouteArgs({
    this.key,
    this.product,
  });

  final _i64.Key? key;

  final _i65.Product? product;

  @override
  String toString() {
    return 'AddProductRouteArgs{key: $key, product: $product}';
  }
}

/// generated route for
/// [_i8.AddProductSuccess]
class AddProductSuccessRoute extends _i63.PageRouteInfo<void> {
  const AddProductSuccessRoute({List<_i63.PageRouteInfo>? children})
      : super(
          AddProductSuccessRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddProductSuccessRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i8.AddProductSuccess();
    },
  );
}

/// generated route for
/// [_i9.AllBusinesses]
class AllBusinessesRoute extends _i63.PageRouteInfo<AllBusinessesRouteArgs> {
  AllBusinessesRoute({
    required List<_i66.Business> allBusiness,
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          AllBusinessesRoute.name,
          args: AllBusinessesRouteArgs(
            allBusiness: allBusiness,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'AllBusinessesRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AllBusinessesRouteArgs>();
      return _i9.AllBusinesses(
        args.allBusiness,
        key: args.key,
      );
    },
  );
}

class AllBusinessesRouteArgs {
  const AllBusinessesRouteArgs({
    required this.allBusiness,
    this.key,
  });

  final List<_i66.Business> allBusiness;

  final _i64.Key? key;

  @override
  String toString() {
    return 'AllBusinessesRouteArgs{allBusiness: $allBusiness, key: $key}';
  }
}

/// generated route for
/// [_i10.AllInvoices]
class AllInvoicesRoute extends _i63.PageRouteInfo<AllInvoicesRouteArgs> {
  AllInvoicesRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          AllInvoicesRoute.name,
          args: AllInvoicesRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AllInvoicesRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AllInvoicesRouteArgs>(
          orElse: () => const AllInvoicesRouteArgs());
      return _i10.AllInvoices(key: args.key);
    },
  );
}

class AllInvoicesRouteArgs {
  const AllInvoicesRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'AllInvoicesRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i11.AllReceipts]
class AllReceiptsRoute extends _i63.PageRouteInfo<AllReceiptsRouteArgs> {
  AllReceiptsRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          AllReceiptsRoute.name,
          args: AllReceiptsRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AllReceiptsRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AllReceiptsRouteArgs>(
          orElse: () => const AllReceiptsRouteArgs());
      return _i11.AllReceipts(key: args.key);
    },
  );
}

class AllReceiptsRouteArgs {
  const AllReceiptsRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'AllReceiptsRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i12.AllTransactions]
class AllTransactionsRoute
    extends _i63.PageRouteInfo<AllTransactionsRouteArgs> {
  AllTransactionsRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          AllTransactionsRoute.name,
          args: AllTransactionsRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AllTransactionsRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AllTransactionsRouteArgs>(
          orElse: () => const AllTransactionsRouteArgs());
      return _i12.AllTransactions(key: args.key);
    },
  );
}

class AllTransactionsRouteArgs {
  const AllTransactionsRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'AllTransactionsRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i13.Brands]
class BrandsRoute extends _i63.PageRouteInfo<BrandsRouteArgs> {
  BrandsRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          BrandsRoute.name,
          args: BrandsRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'BrandsRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<BrandsRouteArgs>(orElse: () => const BrandsRouteArgs());
      return _i13.Brands(key: args.key);
    },
  );
}

class BrandsRouteArgs {
  const BrandsRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'BrandsRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i14.BusinessData]
class BusinessDataRoute extends _i63.PageRouteInfo<void> {
  const BusinessDataRoute({List<_i63.PageRouteInfo>? children})
      : super(
          BusinessDataRoute.name,
          initialChildren: children,
        );

  static const String name = 'BusinessDataRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i14.BusinessData();
    },
  );
}

/// generated route for
/// [_i15.BusinessDetail]
class BusinessDetailRoute extends _i63.PageRouteInfo<void> {
  const BusinessDetailRoute({List<_i63.PageRouteInfo>? children})
      : super(
          BusinessDetailRoute.name,
          initialChildren: children,
        );

  static const String name = 'BusinessDetailRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i15.BusinessDetail();
    },
  );
}

/// generated route for
/// [_i16.ChangePassword]
class ChangePasswordRoute extends _i63.PageRouteInfo<ChangePasswordRouteArgs> {
  ChangePasswordRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          ChangePasswordRoute.name,
          args: ChangePasswordRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ChangePasswordRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChangePasswordRouteArgs>(
          orElse: () => const ChangePasswordRouteArgs());
      return _i16.ChangePassword(key: args.key);
    },
  );
}

class ChangePasswordRouteArgs {
  const ChangePasswordRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'ChangePasswordRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i17.ChangePasswordSuccess]
class ChangePasswordSuccessRoute extends _i63.PageRouteInfo<void> {
  const ChangePasswordSuccessRoute({List<_i63.PageRouteInfo>? children})
      : super(
          ChangePasswordSuccessRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangePasswordSuccessRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i17.ChangePasswordSuccess();
    },
  );
}

/// generated route for
/// [_i18.ChangeProfilePicture]
class ChangeProfilePictureRoute extends _i63.PageRouteInfo<void> {
  const ChangeProfilePictureRoute({List<_i63.PageRouteInfo>? children})
      : super(
          ChangeProfilePictureRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangeProfilePictureRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i18.ChangeProfilePicture();
    },
  );
}

/// generated route for
/// [_i19.ChooseSubscriptionPlan]
class ChooseSubscriptionPlanRoute extends _i63.PageRouteInfo<void> {
  const ChooseSubscriptionPlanRoute({List<_i63.PageRouteInfo>? children})
      : super(
          ChooseSubscriptionPlanRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChooseSubscriptionPlanRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i19.ChooseSubscriptionPlan();
    },
  );
}

/// generated route for
/// [_i20.ClientDetails]
class ClientDetailsRoute extends _i63.PageRouteInfo<ClientDetailsRouteArgs> {
  ClientDetailsRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          ClientDetailsRoute.name,
          args: ClientDetailsRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ClientDetailsRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ClientDetailsRouteArgs>(
          orElse: () => const ClientDetailsRouteArgs());
      return _i20.ClientDetails(key: args.key);
    },
  );
}

class ClientDetailsRouteArgs {
  const ClientDetailsRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'ClientDetailsRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i21.ClientSuccess]
class ClientSuccessRoute extends _i63.PageRouteInfo<void> {
  const ClientSuccessRoute({List<_i63.PageRouteInfo>? children})
      : super(
          ClientSuccessRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClientSuccessRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i21.ClientSuccess();
    },
  );
}

/// generated route for
/// [_i22.Clients]
class ClientsRoute extends _i63.PageRouteInfo<ClientsRouteArgs> {
  ClientsRoute({
    _i64.Key? key,
    bool? forSelection = false,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          ClientsRoute.name,
          args: ClientsRouteArgs(
            key: key,
            forSelection: forSelection,
          ),
          initialChildren: children,
        );

  static const String name = 'ClientsRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<ClientsRouteArgs>(orElse: () => const ClientsRouteArgs());
      return _i22.Clients(
        key: args.key,
        forSelection: args.forSelection,
      );
    },
  );
}

class ClientsRouteArgs {
  const ClientsRouteArgs({
    this.key,
    this.forSelection = false,
  });

  final _i64.Key? key;

  final bool? forSelection;

  @override
  String toString() {
    return 'ClientsRouteArgs{key: $key, forSelection: $forSelection}';
  }
}

/// generated route for
/// [_i23.CompleteDraft]
class CompleteDraftRoute extends _i63.PageRouteInfo<CompleteDraftRouteArgs> {
  CompleteDraftRoute({
    _i64.Key? key,
    required _i67.Receipt draft,
    bool? isInvoice = false,
    bool? inVoiceToReceipt = false,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          CompleteDraftRoute.name,
          args: CompleteDraftRouteArgs(
            key: key,
            draft: draft,
            isInvoice: isInvoice,
            inVoiceToReceipt: inVoiceToReceipt,
          ),
          initialChildren: children,
        );

  static const String name = 'CompleteDraftRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CompleteDraftRouteArgs>();
      return _i23.CompleteDraft(
        key: args.key,
        draft: args.draft,
        isInvoice: args.isInvoice,
        inVoiceToReceipt: args.inVoiceToReceipt,
      );
    },
  );
}

class CompleteDraftRouteArgs {
  const CompleteDraftRouteArgs({
    this.key,
    required this.draft,
    this.isInvoice = false,
    this.inVoiceToReceipt = false,
  });

  final _i64.Key? key;

  final _i67.Receipt draft;

  final bool? isInvoice;

  final bool? inVoiceToReceipt;

  @override
  String toString() {
    return 'CompleteDraftRouteArgs{key: $key, draft: $draft, isInvoice: $isInvoice, inVoiceToReceipt: $inVoiceToReceipt}';
  }
}

/// generated route for
/// [_i24.CreateAccountScreen]
class CreateAccountRoute extends _i63.PageRouteInfo<void> {
  const CreateAccountRoute({List<_i63.PageRouteInfo>? children})
      : super(
          CreateAccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateAccountRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i24.CreateAccountScreen();
    },
  );
}

/// generated route for
/// [_i25.CreateNewPassword]
class CreateNewPasswordRoute
    extends _i63.PageRouteInfo<CreateNewPasswordRouteArgs> {
  CreateNewPasswordRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          CreateNewPasswordRoute.name,
          args: CreateNewPasswordRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'CreateNewPasswordRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateNewPasswordRouteArgs>(
          orElse: () => const CreateNewPasswordRouteArgs());
      return _i25.CreateNewPassword(key: args.key);
    },
  );
}

class CreateNewPasswordRouteArgs {
  const CreateNewPasswordRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'CreateNewPasswordRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i26.CreateNewPasswordReset]
class CreateNewPasswordResetRoute
    extends _i63.PageRouteInfo<CreateNewPasswordResetRouteArgs> {
  CreateNewPasswordResetRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          CreateNewPasswordResetRoute.name,
          args: CreateNewPasswordResetRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'CreateNewPasswordResetRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateNewPasswordResetRouteArgs>(
          orElse: () => const CreateNewPasswordResetRouteArgs());
      return _i26.CreateNewPasswordReset(key: args.key);
    },
  );
}

class CreateNewPasswordResetRouteArgs {
  const CreateNewPasswordResetRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'CreateNewPasswordResetRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i27.Drafts]
class DraftsRoute extends _i63.PageRouteInfo<DraftsRouteArgs> {
  DraftsRoute({
    _i64.Key? key,
    bool? isInvoice = false,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          DraftsRoute.name,
          args: DraftsRouteArgs(
            key: key,
            isInvoice: isInvoice,
          ),
          initialChildren: children,
        );

  static const String name = 'DraftsRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<DraftsRouteArgs>(orElse: () => const DraftsRouteArgs());
      return _i27.Drafts(
        key: args.key,
        isInvoice: args.isInvoice,
      );
    },
  );
}

class DraftsRouteArgs {
  const DraftsRouteArgs({
    this.key,
    this.isInvoice = false,
  });

  final _i64.Key? key;

  final bool? isInvoice;

  @override
  String toString() {
    return 'DraftsRouteArgs{key: $key, isInvoice: $isInvoice}';
  }
}

/// generated route for
/// [_i28.EmptyBusiness]
class EmptyBusinessRoute extends _i63.PageRouteInfo<void> {
  const EmptyBusinessRoute({List<_i63.PageRouteInfo>? children})
      : super(
          EmptyBusinessRoute.name,
          initialChildren: children,
        );

  static const String name = 'EmptyBusinessRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i28.EmptyBusiness();
    },
  );
}

/// generated route for
/// [_i29.EmptyCategory]
class EmptyCategoryRoute extends _i63.PageRouteInfo<EmptyCategoryRouteArgs> {
  EmptyCategoryRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          EmptyCategoryRoute.name,
          args: EmptyCategoryRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'EmptyCategoryRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EmptyCategoryRouteArgs>(
          orElse: () => const EmptyCategoryRouteArgs());
      return _i29.EmptyCategory(key: args.key);
    },
  );
}

class EmptyCategoryRouteArgs {
  const EmptyCategoryRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'EmptyCategoryRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i30.ForgotPassword]
class ForgotPasswordRoute extends _i63.PageRouteInfo<ForgotPasswordRouteArgs> {
  ForgotPasswordRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          ForgotPasswordRoute.name,
          args: ForgotPasswordRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ForgotPasswordRouteArgs>(
          orElse: () => const ForgotPasswordRouteArgs());
      return _i30.ForgotPassword(key: args.key);
    },
  );
}

class ForgotPasswordRouteArgs {
  const ForgotPasswordRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'ForgotPasswordRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i31.GenerateInvoices]
class GenerateInvoicesRoute
    extends _i63.PageRouteInfo<GenerateInvoicesRouteArgs> {
  GenerateInvoicesRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          GenerateInvoicesRoute.name,
          args: GenerateInvoicesRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'GenerateInvoicesRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GenerateInvoicesRouteArgs>(
          orElse: () => const GenerateInvoicesRouteArgs());
      return _i31.GenerateInvoices(key: args.key);
    },
  );
}

class GenerateInvoicesRouteArgs {
  const GenerateInvoicesRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'GenerateInvoicesRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i32.GenerateReceipt]
class GenerateReceiptRoute
    extends _i63.PageRouteInfo<GenerateReceiptRouteArgs> {
  GenerateReceiptRoute({
    _i64.Key? key,
    bool? isInvoice = false,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          GenerateReceiptRoute.name,
          args: GenerateReceiptRouteArgs(
            key: key,
            isInvoice: isInvoice,
          ),
          initialChildren: children,
        );

  static const String name = 'GenerateReceiptRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GenerateReceiptRouteArgs>(
          orElse: () => const GenerateReceiptRouteArgs());
      return _i32.GenerateReceipt(
        key: args.key,
        isInvoice: args.isInvoice,
      );
    },
  );
}

class GenerateReceiptRouteArgs {
  const GenerateReceiptRouteArgs({
    this.key,
    this.isInvoice = false,
  });

  final _i64.Key? key;

  final bool? isInvoice;

  @override
  String toString() {
    return 'GenerateReceiptRouteArgs{key: $key, isInvoice: $isInvoice}';
  }
}

/// generated route for
/// [_i33.HomePage]
class HomePageRoute extends _i63.PageRouteInfo<HomePageRouteArgs> {
  HomePageRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          HomePageRoute.name,
          args: HomePageRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'HomePageRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HomePageRouteArgs>(
          orElse: () => const HomePageRouteArgs());
      return _i33.HomePage(key: args.key);
    },
  );
}

class HomePageRouteArgs {
  const HomePageRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'HomePageRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i34.HomeScreen]
class HomeScreenRoute extends _i63.PageRouteInfo<HomeScreenRouteArgs> {
  HomeScreenRoute({
    _i64.Key? key,
    required _i64.VoidCallback onViewAllTransactions,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          HomeScreenRoute.name,
          args: HomeScreenRouteArgs(
            key: key,
            onViewAllTransactions: onViewAllTransactions,
          ),
          initialChildren: children,
        );

  static const String name = 'HomeScreenRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HomeScreenRouteArgs>();
      return _i34.HomeScreen(
        key: args.key,
        onViewAllTransactions: args.onViewAllTransactions,
      );
    },
  );
}

class HomeScreenRouteArgs {
  const HomeScreenRouteArgs({
    this.key,
    required this.onViewAllTransactions,
  });

  final _i64.Key? key;

  final _i64.VoidCallback onViewAllTransactions;

  @override
  String toString() {
    return 'HomeScreenRouteArgs{key: $key, onViewAllTransactions: $onViewAllTransactions}';
  }
}

/// generated route for
/// [_i35.Invoice]
class InvoiceRoute extends _i63.PageRouteInfo<InvoiceRouteArgs> {
  InvoiceRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          InvoiceRoute.name,
          args: InvoiceRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'InvoiceRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<InvoiceRouteArgs>(orElse: () => const InvoiceRouteArgs());
      return _i35.Invoice(key: args.key);
    },
  );
}

class InvoiceRouteArgs {
  const InvoiceRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'InvoiceRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i36.Login]
class LoginRoute extends _i63.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<LoginRouteArgs>(orElse: () => const LoginRouteArgs());
      return _i36.Login(key: args.key);
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i37.MySubscription]
class MySubscriptionRoute extends _i63.PageRouteInfo<void> {
  const MySubscriptionRoute({List<_i63.PageRouteInfo>? children})
      : super(
          MySubscriptionRoute.name,
          initialChildren: children,
        );

  static const String name = 'MySubscriptionRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i37.MySubscription();
    },
  );
}

/// generated route for
/// [_i38.NotificationSettings]
class NotificationSettingsRoute extends _i63.PageRouteInfo<void> {
  const NotificationSettingsRoute({List<_i63.PageRouteInfo>? children})
      : super(
          NotificationSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationSettingsRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i38.NotificationSettings();
    },
  );
}

/// generated route for
/// [_i39.Notifications]
class NotificationsRoute extends _i63.PageRouteInfo<void> {
  const NotificationsRoute({List<_i63.PageRouteInfo>? children})
      : super(
          NotificationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i39.Notifications();
    },
  );
}

/// generated route for
/// [_i40.OnboardingScreen]
class OnboardingScreenRoute
    extends _i63.PageRouteInfo<OnboardingScreenRouteArgs> {
  OnboardingScreenRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          OnboardingScreenRoute.name,
          args: OnboardingScreenRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'OnboardingScreenRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OnboardingScreenRouteArgs>(
          orElse: () => const OnboardingScreenRouteArgs());
      return _i40.OnboardingScreen(key: args.key);
    },
  );
}

class OnboardingScreenRouteArgs {
  const OnboardingScreenRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'OnboardingScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i41.OtpLogin]
class OtpLoginRoute extends _i63.PageRouteInfo<OtpLoginRouteArgs> {
  OtpLoginRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          OtpLoginRoute.name,
          args: OtpLoginRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'OtpLoginRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OtpLoginRouteArgs>(
          orElse: () => const OtpLoginRouteArgs());
      return _i41.OtpLogin(key: args.key);
    },
  );
}

class OtpLoginRouteArgs {
  const OtpLoginRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'OtpLoginRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i42.OtpReset]
class OtpResetRoute extends _i63.PageRouteInfo<OtpResetRouteArgs> {
  OtpResetRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          OtpResetRoute.name,
          args: OtpResetRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'OtpResetRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OtpResetRouteArgs>(
          orElse: () => const OtpResetRouteArgs());
      return _i42.OtpReset(key: args.key);
    },
  );
}

class OtpResetRouteArgs {
  const OtpResetRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'OtpResetRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i43.OtpScreen]
class OtpScreenRoute extends _i63.PageRouteInfo<OtpScreenRouteArgs> {
  OtpScreenRoute({
    _i68.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          OtpScreenRoute.name,
          args: OtpScreenRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'OtpScreenRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OtpScreenRouteArgs>(
          orElse: () => const OtpScreenRouteArgs());
      return _i43.OtpScreen(key: args.key);
    },
  );
}

class OtpScreenRouteArgs {
  const OtpScreenRouteArgs({this.key});

  final _i68.Key? key;

  @override
  String toString() {
    return 'OtpScreenRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i44.PaymentWebViewPage]
class PaymentWebViewRoute extends _i63.PageRouteInfo<PaymentWebViewRouteArgs> {
  PaymentWebViewRoute({
    _i64.Key? key,
    String paymentLink = '',
    List<_i63.PageRouteInfo>? children,
  }) : super(
          PaymentWebViewRoute.name,
          args: PaymentWebViewRouteArgs(
            key: key,
            paymentLink: paymentLink,
          ),
          rawQueryParams: {'paymentLink': paymentLink},
          initialChildren: children,
        );

  static const String name = 'PaymentWebViewRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<PaymentWebViewRouteArgs>(
          orElse: () => PaymentWebViewRouteArgs(
                  paymentLink: queryParams.getString(
                'paymentLink',
                '',
              )));
      return _i44.PaymentWebViewPage(
        key: args.key,
        paymentLink: args.paymentLink,
      );
    },
  );
}

class PaymentWebViewRouteArgs {
  const PaymentWebViewRouteArgs({
    this.key,
    this.paymentLink = '',
  });

  final _i64.Key? key;

  final String paymentLink;

  @override
  String toString() {
    return 'PaymentWebViewRouteArgs{key: $key, paymentLink: $paymentLink}';
  }
}

/// generated route for
/// [_i45.PayvidenceInfo]
class PayvidenceInfoRoute extends _i63.PageRouteInfo<void> {
  const PayvidenceInfoRoute({List<_i63.PageRouteInfo>? children})
      : super(
          PayvidenceInfoRoute.name,
          initialChildren: children,
        );

  static const String name = 'PayvidenceInfoRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i45.PayvidenceInfo();
    },
  );
}

/// generated route for
/// [_i46.PrivacyAndSecurity]
class PrivacyAndSecurityRoute extends _i63.PageRouteInfo<void> {
  const PrivacyAndSecurityRoute({List<_i63.PageRouteInfo>? children})
      : super(
          PrivacyAndSecurityRoute.name,
          initialChildren: children,
        );

  static const String name = 'PrivacyAndSecurityRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i46.PrivacyAndSecurity();
    },
  );
}

/// generated route for
/// [_i47.Product]
class ProductRoute extends _i63.PageRouteInfo<ProductRouteArgs> {
  ProductRoute({
    _i64.Key? key,
    bool? forProductSelection = false,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          ProductRoute.name,
          args: ProductRouteArgs(
            key: key,
            forProductSelection: forProductSelection,
          ),
          initialChildren: children,
        );

  static const String name = 'ProductRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<ProductRouteArgs>(orElse: () => const ProductRouteArgs());
      return _i47.Product(
        key: args.key,
        forProductSelection: args.forProductSelection,
      );
    },
  );
}

class ProductRouteArgs {
  const ProductRouteArgs({
    this.key,
    this.forProductSelection = false,
  });

  final _i64.Key? key;

  final bool? forProductSelection;

  @override
  String toString() {
    return 'ProductRouteArgs{key: $key, forProductSelection: $forProductSelection}';
  }
}

/// generated route for
/// [_i48.ProductDetails]
class ProductDetailsRoute extends _i63.PageRouteInfo<ProductDetailsRouteArgs> {
  ProductDetailsRoute({
    _i64.Key? key,
    required _i65.Product product,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          ProductDetailsRoute.name,
          args: ProductDetailsRouteArgs(
            key: key,
            product: product,
          ),
          initialChildren: children,
        );

  static const String name = 'ProductDetailsRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductDetailsRouteArgs>();
      return _i48.ProductDetails(
        key: args.key,
        product: args.product,
      );
    },
  );
}

class ProductDetailsRouteArgs {
  const ProductDetailsRouteArgs({
    this.key,
    required this.product,
  });

  final _i64.Key? key;

  final _i65.Product product;

  @override
  String toString() {
    return 'ProductDetailsRouteArgs{key: $key, product: $product}';
  }
}

/// generated route for
/// [_i49.Profile]
class ProfileRoute extends _i63.PageRouteInfo<void> {
  const ProfileRoute({List<_i63.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i49.Profile();
    },
  );
}

/// generated route for
/// [_i50.Receipt]
class ReceiptRoute extends _i63.PageRouteInfo<void> {
  const ReceiptRoute({List<_i63.PageRouteInfo>? children})
      : super(
          ReceiptRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReceiptRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i50.Receipt();
    },
  );
}

/// generated route for
/// [_i51.ReceiptScreen]
class ReceiptScreenRoute extends _i63.PageRouteInfo<ReceiptScreenRouteArgs> {
  ReceiptScreenRoute({
    required _i67.Receipt record,
    required bool? isInvoice,
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          ReceiptScreenRoute.name,
          args: ReceiptScreenRouteArgs(
            record: record,
            isInvoice: isInvoice,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ReceiptScreenRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReceiptScreenRouteArgs>();
      return _i51.ReceiptScreen(
        args.record,
        args.isInvoice,
        key: args.key,
      );
    },
  );
}

class ReceiptScreenRouteArgs {
  const ReceiptScreenRouteArgs({
    required this.record,
    required this.isInvoice,
    this.key,
  });

  final _i67.Receipt record;

  final bool? isInvoice;

  final _i64.Key? key;

  @override
  String toString() {
    return 'ReceiptScreenRouteArgs{record: $record, isInvoice: $isInvoice, key: $key}';
  }
}

/// generated route for
/// [_i52.ResetPassword]
class ResetPasswordRoute extends _i63.PageRouteInfo<ResetPasswordRouteArgs> {
  ResetPasswordRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          ResetPasswordRoute.name,
          args: ResetPasswordRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ResetPasswordRouteArgs>(
          orElse: () => const ResetPasswordRouteArgs());
      return _i52.ResetPassword(key: args.key);
    },
  );
}

class ResetPasswordRouteArgs {
  const ResetPasswordRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'ResetPasswordRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i53.ResetPasswordSuccess]
class ResetPasswordSuccessRoute extends _i63.PageRouteInfo<void> {
  const ResetPasswordSuccessRoute({List<_i63.PageRouteInfo>? children})
      : super(
          ResetPasswordSuccessRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetPasswordSuccessRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i53.ResetPasswordSuccess();
    },
  );
}

/// generated route for
/// [_i54.Sales]
class SalesRoute extends _i63.PageRouteInfo<SalesRouteArgs> {
  SalesRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          SalesRoute.name,
          args: SalesRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SalesRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<SalesRouteArgs>(orElse: () => const SalesRouteArgs());
      return _i54.Sales(key: args.key);
    },
  );
}

class SalesRouteArgs {
  const SalesRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'SalesRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i55.SelectClient]
class SelectClientRoute extends _i63.PageRouteInfo<SelectClientRouteArgs> {
  SelectClientRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          SelectClientRoute.name,
          args: SelectClientRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SelectClientRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SelectClientRouteArgs>(
          orElse: () => const SelectClientRouteArgs());
      return _i55.SelectClient(key: args.key);
    },
  );
}

class SelectClientRouteArgs {
  const SelectClientRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'SelectClientRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i56.Settings]
class SettingsRoute extends _i63.PageRouteInfo<void> {
  const SettingsRoute({List<_i63.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i56.Settings();
    },
  );
}

/// generated route for
/// [_i57.SubscriptionPlans]
class SubscriptionPlansRoute
    extends _i63.PageRouteInfo<SubscriptionPlansRouteArgs> {
  SubscriptionPlansRoute({
    _i64.Key? key,
    String planId = '',
    List<_i63.PageRouteInfo>? children,
  }) : super(
          SubscriptionPlansRoute.name,
          args: SubscriptionPlansRouteArgs(
            key: key,
            planId: planId,
          ),
          rawQueryParams: {'planId': planId},
          initialChildren: children,
        );

  static const String name = 'SubscriptionPlansRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<SubscriptionPlansRouteArgs>(
          orElse: () => SubscriptionPlansRouteArgs(
                  planId: queryParams.getString(
                'planId',
                '',
              )));
      return _i57.SubscriptionPlans(
        key: args.key,
        planId: args.planId,
      );
    },
  );
}

class SubscriptionPlansRouteArgs {
  const SubscriptionPlansRouteArgs({
    this.key,
    this.planId = '',
  });

  final _i64.Key? key;

  final String planId;

  @override
  String toString() {
    return 'SubscriptionPlansRouteArgs{key: $key, planId: $planId}';
  }
}

/// generated route for
/// [_i58.SubscriptionPrompt]
class SubscriptionPrompt extends _i63.PageRouteInfo<void> {
  const SubscriptionPrompt({List<_i63.PageRouteInfo>? children})
      : super(
          SubscriptionPrompt.name,
          initialChildren: children,
        );

  static const String name = 'SubscriptionPrompt';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i58.SubscriptionPrompt();
    },
  );
}

/// generated route for
/// [_i59.UpdateBankDetails]
class UpdateBankDetailsRoute
    extends _i63.PageRouteInfo<UpdateBankDetailsRouteArgs> {
  UpdateBankDetailsRoute({
    _i64.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          UpdateBankDetailsRoute.name,
          args: UpdateBankDetailsRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'UpdateBankDetailsRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UpdateBankDetailsRouteArgs>(
          orElse: () => const UpdateBankDetailsRouteArgs());
      return _i59.UpdateBankDetails(key: args.key);
    },
  );
}

class UpdateBankDetailsRouteArgs {
  const UpdateBankDetailsRouteArgs({this.key});

  final _i64.Key? key;

  @override
  String toString() {
    return 'UpdateBankDetailsRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i60.UpdatePersonalDetails]
class UpdatePersonalDetailsRoute extends _i63.PageRouteInfo<void> {
  const UpdatePersonalDetailsRoute({List<_i63.PageRouteInfo>? children})
      : super(
          UpdatePersonalDetailsRoute.name,
          initialChildren: children,
        );

  static const String name = 'UpdatePersonalDetailsRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i60.UpdatePersonalDetails();
    },
  );
}

/// generated route for
/// [_i61.UpdateQuantity]
class UpdateQuantityRoute extends _i63.PageRouteInfo<UpdateQuantityRouteArgs> {
  UpdateQuantityRoute({
    _i64.Key? key,
    required _i65.Product product,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          UpdateQuantityRoute.name,
          args: UpdateQuantityRouteArgs(
            key: key,
            product: product,
          ),
          initialChildren: children,
        );

  static const String name = 'UpdateQuantityRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UpdateQuantityRouteArgs>();
      return _i61.UpdateQuantity(
        key: args.key,
        product: args.product,
      );
    },
  );
}

class UpdateQuantityRouteArgs {
  const UpdateQuantityRouteArgs({
    this.key,
    required this.product,
  });

  final _i64.Key? key;

  final _i65.Product product;

  @override
  String toString() {
    return 'UpdateQuantityRouteArgs{key: $key, product: $product}';
  }
}

/// generated route for
/// [_i62.UpgradeSubscription]
class UpgradeSubscriptionRoute extends _i63.PageRouteInfo<void> {
  const UpgradeSubscriptionRoute({List<_i63.PageRouteInfo>? children})
      : super(
          UpgradeSubscriptionRoute.name,
          initialChildren: children,
        );

  static const String name = 'UpgradeSubscriptionRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i62.UpgradeSubscription();
    },
  );
}
