/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsPngGen {
  const $AssetsPngGen();

  /// File path: assets/png/onboarding1.png
  AssetGenImage get onboarding1 =>
      const AssetGenImage('assets/png/onboarding1.png');

  /// File path: assets/png/onboarding2.png
  AssetGenImage get onboarding2 =>
      const AssetGenImage('assets/png/onboarding2.png');

  /// File path: assets/png/onboarding3.png
  AssetGenImage get onboarding3 =>
      const AssetGenImage('assets/png/onboarding3.png');

  /// File path: assets/png/payvidence_logo.png
  AssetGenImage get payvidenceLogo =>
      const AssetGenImage('assets/png/payvidence_logo.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [onboarding1, onboarding2, onboarding3, payvidenceLogo];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/backbutton.svg
  String get backbutton => 'assets/svg/backbutton.svg';

  /// File path: assets/svg/home.svg
  String get home => 'assets/svg/home.svg';

  /// File path: assets/svg/home_ol.svg
  String get homeOl => 'assets/svg/home_ol.svg';

  /// File path: assets/svg/password.svg
  String get password => 'assets/svg/password.svg';

  /// File path: assets/svg/password_success.svg
  String get passwordSuccess => 'assets/svg/password_success.svg';

  /// File path: assets/svg/profile.svg
  String get profile => 'assets/svg/profile.svg';

  /// File path: assets/svg/profile_confetti.svg
  String get profileConfetti => 'assets/svg/profile_confetti.svg';

  /// File path: assets/svg/profile_ol.svg
  String get profileOl => 'assets/svg/profile_ol.svg';

  /// File path: assets/svg/transaction.svg
  String get transaction => 'assets/svg/transaction.svg';

  /// File path: assets/svg/transaction_ol.svg
  String get transactionOl => 'assets/svg/transaction_ol.svg';

  /// File path: assets/svg/wallet.svg
  String get wallet => 'assets/svg/wallet.svg';

  /// File path: assets/svg/wallet_ol.svg
  String get walletOl => 'assets/svg/wallet_ol.svg';

  /// List of all assets
  List<String> get values => [
        backbutton,
        home,
        homeOl,
        password,
        passwordSuccess,
        profile,
        profileConfetti,
        profileOl,
        transaction,
        transactionOl,
        wallet,
        walletOl
      ];
}

class Assets {
  Assets._();

  static const $AssetsPngGen png = $AssetsPngGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
