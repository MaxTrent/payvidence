import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';
import 'package:payvidence/utilities/extensions.dart';
import 'package:share_plus/share_plus.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'dart:ui' as ui;
import '../../utilities/animations.dart';
import '../../components/app_button.dart';
import '../../components/app_naira.dart';
import '../../constants/app_colors.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/responsive.dart';
import '../../utilities/responsive_wrapper.dart';

@RoutePage(name: 'ReceiptScreenRoute')
class ReceiptScreen extends ConsumerWidget {
  final Receipt record;
  final bool? isInvoice;
  final String? source;

  ReceiptScreen(this.record, this.isInvoice, {super.key, this.source});

  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsiveData = ResponsiveInherited.of(context);

    Future<XFile> capturePng() async {
      RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 2);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      return XFile.fromData(
        pngBytes!,
        name: 'receipt_${DateTime.now().toIso8601String()}',
        mimeType: 'image/png',
      );
    }

    Future<void> shareReceipt() async {
      XFile image = await capturePng();
      final result = await Share.shareXFiles([image], text: 'Transaction Receipt');
      if (result.status == ShareResultStatus.success) {
        print('Thank you for sharing the receipt!');
      }
    }

    return ResponsiveWrapper(
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (!didPop) {
            if (source == 'home') {
              Navigator.of(context).pop();
            } else if (source == 'transactions') {
              locator<PayvidenceAppRouter>().navigate(const AllTransactionsRoute());
            } else if (source == 'product') {
              locator<PayvidenceAppRouter>().navigate(ProductRoute());
            } else {
              locator<PayvidenceAppRouter>().navigate(
                isInvoice == true ? const AllInvoicesRoute() : const AllReceiptsRoute()
              );
            }
          }
        },
        child: Scaffold(
        appBar: AppBar(
          actions: [
            if (isInvoice == true)
              Center(
                child: Padding(
                  padding: EdgeInsets.only(right: responsiveData.scaleWidth(20)),
                  child: GestureDetector(
                    onTap: () {
                      locator<PayvidenceAppRouter>().navigate(CompleteDraftRoute(
                          draft: record, isInvoice: true, inVoiceToReceipt: true));
                    },
                    child: Text(
                      'Re-issue to receipt',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontSize: Responsive.fontSize(context, 12), color: primaryColor2), // Reduced from 14
                    ),
                  ),
                ),
              )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: responsiveData.scaleHeight(32)),
                FadeInWidget(
                  child: RepaintBoundary(
                    key: globalKey,
                    child: ContainerWithClippedCircles(
                      record: record,
                      isInvoice: isInvoice ?? false,
                    ),
                  ),
                ),
                SizedBox(height: responsiveData.scaleHeight(20)),
                SlideInWidget(
                  begin: const Offset(0, 0.3),
                  delay: const Duration(milliseconds: 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppButton(
                        buttonText: 'Share ${isInvoice == true ? 'invoice' : 'receipt'}',
                        onPressed: () {
                          shareReceipt();
                        },
                      ),
                      SizedBox(height: responsiveData.scaleHeight(26)),
                      SizedBox(height: responsiveData.scaleHeight(24)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}

class ContainerWithClippedCircles extends StatelessWidget {
  final Receipt record;
  final bool isInvoice;

  const ContainerWithClippedCircles(
      {super.key, required this.record, required this.isInvoice});

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    final productDetails = record.recordProductDetails ?? [];
    double subtotal = productDetails.fold(
        0,
            (sum, item) =>
        sum + (double.tryParse(item.price ?? '0') ?? 0) * (item.quantity ?? 0));
    double discountRate = productDetails.isNotEmpty
        ? (double.tryParse(productDetails.first.discount ?? '0') ?? 0) / 100
        : 0;
    double vatRate = productDetails.isNotEmpty
        ? (double.tryParse(productDetails.first.product?.vat ?? '0') ?? 0) / 100
        : 0;
    double discount = subtotal * discountRate;
    double vat = (subtotal - discount) * vatRate;
    double grandTotal = subtotal - discount + vat;
    final date = record.createdAt!;
    final formattedDate =
        "${getDayWithSuffix(date.day)} ${DateFormat('MMM. yyyy').format(date)}";

    // Local function to cap font size
    double capFontSize(double baseSize, double maxSize) {
      double scaledSize = Responsive.fontSize(context, baseSize);
      return scaledSize > maxSize ? maxSize : scaledSize;
    }

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
              top: responsiveData.scaleHeight(40), bottom: responsiveData.scaleHeight(24)),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "TRANSACTION ${isInvoice == true ? 'INVOICE' : 'RECEIPT'}"
                    .toUpperCase(),
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: capFontSize(14, 18)), // Reduced from 18, capped at 18
              ),
              SizedBox(height: responsiveData.scaleHeight(24)),
              record.business?.logoUrl != null
                  ? CircleAvatar(
                radius: responsiveData.scaleHeight(32),
                backgroundColor: Colors.black,
                child: ClipOval(
                  child: Image.network(
                    record.business!.logoUrl!,
                    width: responsiveData.scaleHeight(64),
                    height: responsiveData.scaleHeight(64),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Failed to load logo: $error');
                      return Center(
                        child: Text(
                          "K",
                          style: TextStyle(
                            fontSize: capFontSize(16, 20), // Reduced from 20, capped at 20
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
                  : CircleAvatar(
                radius: responsiveData.scaleHeight(24),
                backgroundColor: Colors.black,
                child: Text(
                  "K",
                  style: TextStyle(
                    fontSize: capFontSize(16, 20), // Reduced from 20, capped at 20
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(14)),
              Text(
                record.business?.name ?? '',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: capFontSize(12, 16)), // Reduced from 14, capped at 16
              ),
              Text(
                record.business?.address ?? '',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(
                    fontSize: capFontSize(10, 14), // Reduced from 14, capped at 14
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              Text(
                record.business?.phoneNumber ?? '',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(
                    fontSize: capFontSize(10, 14), // Reduced from 14, capped at 14
                    color: Colors.black),
              ),
              SizedBox(height: responsiveData.scaleHeight(24)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsiveData.scaleWidth(18)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "BILL TO:",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                fontSize: capFontSize(14, 18), // Reduced from 18, capped at 18
                                color: Colors.black),
                          ),
                          SizedBox(height: responsiveData.scaleHeight(8)),
                          Text(
                            record.client?.name ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                color: Colors.black,
                                fontSize: capFontSize(12, 15)), // Reduced from 14, capped at 15
                          ),
                          SizedBox(height: responsiveData.scaleHeight(4)),
                          Text(
                            record.client?.phoneNumber ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                color: Colors.black,
                                fontSize: capFontSize(10, 14)), // Reduced from 14, capped at 14
                          ),
                          SizedBox(height: responsiveData.scaleHeight(4)),
                          Text(
                            record.client?.address ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                fontSize: capFontSize(10, 14), // Reduced from 16, capped at 14
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: responsiveData.scaleWidth(12)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "TRACKING ID:",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                fontSize: capFontSize(14, 18), // Reduced from 18, capped at 18
                                color: Colors.black),
                          ),
                          SizedBox(height: responsiveData.scaleHeight(8)),
                          Text(
                            record.id?.substring(0, 13) ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                color: Colors.black,
                                fontSize: capFontSize(12, 15)), // Reduced from 14, capped at 15
                          ),
                          SizedBox(height: responsiveData.scaleHeight(4)),
                          Text(
                            formattedDate,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                color: Colors.black,
                                fontSize: capFontSize(10, 14)), // Reduced from 14, capped at 14
                          ),
                          SizedBox(height: responsiveData.scaleHeight(8)),
                          BarcodeWidget(
                            barcode: Barcode.code128(),
                            data: record.id ?? 'N/A',
                            width: responsiveData.scaleWidth(100),
                            height: responsiveData.scaleHeight(50),
                            drawText: false,
                            color: primaryColor2,
                            backgroundColor: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(32)),
              Table(
                border: TableBorder.all(width: 0, color: Colors.transparent),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FlexColumnWidth(1), // DESCRIPTION
                  1: FlexColumnWidth(1), // RATE
                  2: FlexColumnWidth(1), // QTY
                  3: FlexColumnWidth(1), // AMOUNT
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: primaryColor4,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(responsiveData.smallRadius),
                        topRight: Radius.circular(responsiveData.smallRadius),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(8),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: Text(
                          'DESC.',
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                              fontSize: capFontSize(10, 14), // Reduced from 14, capped at 14
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(8),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                fontSize: capFontSize(10, 14), // Reduced from 14, capped at 14
                                color: Colors.white),
                            children: [
                              const TextSpan(text: 'RATE ('),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: AppNaira(fontSize: 10, color: Colors.white),
                              ),
                              const TextSpan(text: ')'),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(8),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: Text(
                          'QTY',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                              fontSize: capFontSize(10, 14), // Reduced from 14, capped at 14
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(8),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                fontSize: capFontSize(10, 14), // Reduced from 14, capped at 14
                                color: Colors.white),
                            children: [
                              const TextSpan(text: 'AMT. ('),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: AppNaira(fontSize: 10, color: Colors.white),
                              ),
                              const TextSpan(text: ')'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...productDetails.map(
                        (row) => TableRow(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: responsiveData.scaleHeight(6),
                              horizontal: responsiveData.scaleWidth(8)),
                          child: Text(
                            row.product?.name ?? '',
                            textAlign: TextAlign.left,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                fontSize: capFontSize(10, 14), // Reduced from 14, capped at 14
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: responsiveData.scaleHeight(6),
                              horizontal: responsiveData.scaleWidth(8)),
                          child: Text(
                            (double.tryParse(row.price ?? '0') ?? 0).toString().commaSeparated(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                fontSize: capFontSize(10, 14), // Reduced from 14, capped at 14
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: responsiveData.scaleHeight(6),
                              horizontal: responsiveData.scaleWidth(8)),
                          child: Text(
                            (row.quantity ?? 0).toString(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                fontSize: capFontSize(10, 14), // Reduced from 14, capped at 14
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: responsiveData.scaleHeight(6),
                              horizontal: responsiveData.scaleWidth(8)),
                          child: Text(
                            ((double.tryParse(row.price ?? '0') ?? 0) * (row.quantity ?? 0))
                                .toString()
                                .commaSeparated(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                fontSize: capFontSize(10, 14), // Reduced from 14, capped at 14
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(12),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: Text(
                          "SUBTOTAL",
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                              fontSize: capFontSize(11, 15), // Reduced from 14, capped at 15
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(12),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: const Text(
                          "",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(12),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: const Text(
                          "",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(12),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: Text(
                          subtotal.toString().commaSeparated(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                              fontSize: capFontSize(10, 14), // Reduced from 14, capped at 14
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(12),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: Text(
                          "DISCOUNT",
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                              fontSize: capFontSize(11, 15), // Reduced from 14, capped at 15
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(12),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: const Text(
                          "",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(12),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: const Text(
                          "",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(12),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: Text(
                          discount.toString().commaSeparated(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                              fontSize: capFontSize(10, 14), // Reduced from 14, capped at 14
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(12),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: Text(
                          "VAT",
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                              fontSize: capFontSize(11, 15), // Reduced from 14, capped at 15
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(12),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: const Text(
                          "",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(12),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: const Text(
                          "",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(12),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: Text(
                          vat.toString().commaSeparated(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                              fontSize: capFontSize(10, 14), // Reduced from 14, capped at 14
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    decoration: const BoxDecoration(
                      color: primaryColor4,
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(6),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: Text(
                          "GRAND TOTAL",
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                              fontSize: capFontSize(11, 15), // Reduced from 14, capped at 15
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(6),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: const Text(
                          "",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(6),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: const Text(
                          "",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: responsiveData.scaleHeight(6),
                            horizontal: responsiveData.scaleWidth(8)),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                fontSize: capFontSize(11, 15), // Reduced from 14, capped at 15
                                color: Colors.white),
                            children: [
                              const WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: AppNaira(fontSize: 10, color: Colors.white),
                              ),
                              TextSpan(text: grandTotal.toString().commaSeparated()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: responsiveData.scaleHeight(38)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsiveData.scaleWidth(18)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Visibility(
                        visible: isInvoice == false,
                        replacement: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Payment info".toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: capFontSize(12, 16)), // Reduced from 14, capped at 16
                            ),
                            SizedBox(height: responsiveData.scaleHeight(12)),
                            if (record.business != null) ...[
                              Text(
                                record.business!.accountNumber?.toString() ?? 'N/A',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                    fontSize: capFontSize(12, 16), // Reduced from 16, capped at 16
                                    color: Colors.black),
                              ),
                              SizedBox(height: responsiveData.scaleHeight(4)),
                              Text(
                                record.business!.bankName?.toString() ?? 'N/A',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                    fontSize: capFontSize(12, 16), // Reduced from 16, capped at 16
                                    color: Colors.black),
                              ),
                              SizedBox(height: responsiveData.scaleHeight(4)),
                              Text(
                                record.business!.accountName?.toString() ?? 'N/A',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                    fontSize: capFontSize(12, 16), // Reduced from 16, capped at 16
                                    color: Colors.black),
                              ),
                            ] else ...[
                              Text(
                                'Business information unavailable',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                    fontSize: capFontSize(11, 15), // Reduced from 15, capped at 15
                                    color: Colors.black),
                              ),
                            ],
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "PAID",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                  fontSize: capFontSize(30, 36), // Reduced from 44, capped at 36
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Via ${record.modeOfPayment ?? ''}".capitalizeEachWord(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                  fontSize: capFontSize(10, 14), // Reduced from 14, capped at 14
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          record.business?.issuerSignatureUrl != null
                              ? Image.network(
                            record.business!.issuerSignatureUrl!,
                            width: responsiveData.scaleWidth(100),
                            height: responsiveData.scaleHeight(50),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: responsiveData.scaleWidth(100),
                                  height: responsiveData.scaleHeight(50),
                                  color: Colors.grey[200],
                                ),
                          )
                              : Container(
                            width: responsiveData.scaleWidth(40),
                            height: responsiveData.scaleHeight(24),
                            color: Colors.grey[200],
                          ),
                          SizedBox(height: responsiveData.scaleHeight(18)),
                          Text(
                            record.business?.issuer ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                color: Colors.black,
                                fontSize: capFontSize(11, 15)), // Reduced from 14, capped at 15
                          ),
                          Text(
                            "Business Manager",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                fontSize: capFontSize(10, 14), // Reduced from 14, capped at 14
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(24)),
              Text(
                "Generated with Payvidence",
                textAlign: TextAlign.center,
                style: GoogleFonts.marckScript(
                  fontSize: capFontSize(12, 16), // Reduced from 16, capped at 16
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(12)),
            ],
          ),
        ),
        Positioned(
          top: -responsiveData.scaleHeight(50),
          right: -responsiveData.scaleWidth(50),
          child: ClipOval(
            child: Container(
              width: responsiveData.scaleWidth(100),
              height: responsiveData.scaleHeight(100),
              color: primaryColor4,
            ),
          ),
        ),
        Positioned(
          top: -responsiveData.scaleHeight(50),
          left: -responsiveData.scaleWidth(50),
          child: ClipOval(
            child: Container(
              width: responsiveData.scaleWidth(100),
              height: responsiveData.scaleHeight(100),
              color: primaryColor4,
            ),
          ),
        ),
      ],
    );
  }
}