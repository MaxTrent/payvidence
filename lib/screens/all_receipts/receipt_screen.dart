import 'dart:io';
import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';
import 'package:payvidence/utilities/extensions.dart';
import 'package:payvidence/utilities/toast_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../../components/app_button.dart';
import '../../components/app_naira.dart';
import '../../constants/app_colors.dart';
import 'dart:ui' as ui;
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'ReceiptScreenRoute')
class ReceiptScreen extends ConsumerWidget {
  final Receipt record;
  final bool? isInvoice;

  ReceiptScreen(this.record, this.isInvoice, {super.key});

  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<XFile> capturePng() async {
      RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 2);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      return XFile.fromData(
        pngBytes!,
        name: 'receipt_${DateTime.now().toIso8601String()}',
        mimeType: 'image/png',
      );
    }

    Future<bool> requestStoragePermissions() async {
      if (Platform.isAndroid) {
        Permission permission;
        if (Platform.version.startsWith('13')) {
          permission = Permission.photos;
          print('Android 13+: Requesting Permission.photos');
        } else {
          permission = Permission.storage;
          print('Android < 13: Requesting Permission.storage');
        }

        var status = await permission.status;
        print('Permission status: $status');
        if (status.isDenied) {
          status = await permission.request();
          print('Permission request result: $status');
        }

        if (status.isPermanentlyDenied) {
          print('Permission permanently denied, opening settings');
          await openAppSettings();
          ToastService.showErrorSnackBar(
              "Please enable storage/photos permission in settings to save the receipt.");
          return false;
        }

        if (!status.isGranted) {
          print('Permission not granted');
          ToastService.showErrorSnackBar(
              "Storage or photo library access is required to save the receipt.");
          return false;
        }
      } else if (Platform.isIOS) {
        var status = await Permission.photos.status;
        print('iOS Permission.photos status: $status');
        if (status.isDenied) {
          status = await Permission.photos.request();
          print('iOS Permission request result: $status');
        }

        if (status.isPermanentlyDenied) {
          print('iOS Permission permanently denied, opening settings');
          await openAppSettings();
          ToastService.showErrorSnackBar(
              "Please enable photo library access in settings to save the receipt.");
          return false;
        }

        if (!status.isGranted) {
          print('iOS Permission not granted');
          ToastService.showErrorSnackBar(
              "Photo library access is required to save the receipt.");
          return false;
        }
      }
      print('Permissions granted');
      return true;
    }

    Future<void> saveImage(XFile imageFile) async {
      ProgressDialog pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: 'Preparing Receipt...');

      try {
        // Get temporary directory
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/receipt_${DateTime.now().toIso8601String()}.png';
        final file = File(filePath);
        await file.writeAsBytes(await imageFile.readAsBytes());

        pd.close();

        // Share the file, allowing the user to save it
        await Share.shareXFiles([XFile(filePath)], text: 'Save or share your receipt');
      } catch (e) {
        pd.close();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text("Failed to prepare receipt: $e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }

    Future<void> shareReceipt() async {
      XFile image = await capturePng();
      final result =
      await Share.shareXFiles([image], text: 'Transaction Receipt');
      if (result.status == ShareResultStatus.success) {
        print('Thank you for sharing the receipt!');
      }
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (isInvoice == true)
            Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: GestureDetector(
                      onTap: () {
                        locator<PayvidenceAppRouter>().navigate(CompleteDraftRoute(
                            draft: record, isInvoice: true, inVoiceToReceipt: true));
                      },
                      child: Text('Re-issue to receipt',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontSize: 14.sp, color: primaryColor2))),
                ))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 32.h),
              RepaintBoundary(
                key: globalKey,
                child: ContainerWithClippedCircles(
                  record: record,
                  isInvoice: isInvoice ?? false,
                ),
              ),
              SizedBox(height: 20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppButton(
                    buttonText:
                    'Share ${isInvoice == true ? 'invoice' : 'receipt'}',
                    onPressed: () {
                      shareReceipt();
                    },
                  ),
                  SizedBox(height: 26.h),
                  // GestureDetector(
                  //   onTap: () async {
                  //     saveImage(await capturePng());
                  //   },
                  //   child: Text(
                  //     'Download ${isInvoice == true ? 'invoice' : 'receipt'}',
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .displayMedium!
                  //         .copyWith(color: primaryColor2),
                  //   ),
                  // ),
                  24.verticalSpace
                ],
              )
            ],
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
    double subtotal = record.recordProductDetails.fold(
        0,
            (sum, item) =>
        sum +
            (double.tryParse(item.price ?? '0') ?? 0) * (item.quantity ?? 0));
    double discountRate =
        (double.tryParse(record.recordProductDetails.first.discount ?? '0') ??
            0) /
            100;
    double vatRate =
        (double.tryParse(record.recordProductDetails.first.product?.vat ?? '0') ?? 0) / 100;
    double discount = subtotal * discountRate;
    double vat = (subtotal - discount) * vatRate;
    double grandTotal = subtotal - discount + vat;
    final date = record.createdAt!;
    final formattedDate =
        "${getDayWithSuffix(date.day)} ${DateFormat('MMM. yyyy').format(date)}";

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 40.h, bottom: 24.h),
          width: ScreenUtil().screenWidth,
          decoration: const BoxDecoration(
            color: Colors.white,
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [
            //     // Colors.white
            //     Color(0xCCE3DDFF),
            //     Color(0xE5888599),
            //     Color(0x99888599),
            //   ],
            // ),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "TRANSACTION ${isInvoice == true ? 'INVOICE' : 'RECEIPT'}"
                    .toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
              ),
              24.verticalSpace,
              record.business?.logoUrl != null
                  ? CircleAvatar(
                radius: 32.r,
                backgroundColor: Colors.black,
                child: ClipOval(
                  child: Image.network(
                    record.business!.logoUrl!,
                    width: 64.r,
                    height: 64.r,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Failed to load logo: $error');
                      return Center(
                        child: Text(
                          "K",
                          style: TextStyle(
                            fontSize: 20.sp,
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
                radius: 24.r,
                backgroundColor: Colors.black,
                child: Text(
                  "K",
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              14.verticalSpace,
              Text(
                record.business?.name ?? '',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w400),
              ),
              8.verticalSpace,
              Text(
                record.business?.address ?? '',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontSize: 14.sp, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              6.verticalSpace,
              Text(
                record.business?.phoneNumber ?? '',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontSize: 14.sp, color: Colors.black),
              ),
              24.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
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
                                .copyWith(fontSize: 22.sp, color: Colors.black),
                          ),
                          8.verticalSpace,
                          Text(
                            record.client?.name ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(color: Colors.black),
                          ),
                          4.verticalSpace,
                          Text(
                            record.client?.phoneNumber ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(color: Colors.black),
                          ),
                          4.verticalSpace,
                          Text(
                            record.client?.address ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 16.sp, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "TRACKING ID:",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(fontSize: 22.sp, color: Colors.black),
                          ),
                          8.verticalSpace,
                          Text(
                            record.id?.substring(0, 13) ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(color: Colors.black),
                          ),
                          4.verticalSpace,
                          Text(
                            formattedDate,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(color: Colors.black),
                          ),
                          8.verticalSpace,
                          BarcodeWidget(
                            barcode: Barcode.code128(),
                            data: record.id ?? 'N/A',
                            width: 100.w,
                            height: 50.h,
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
              32.verticalSpace,
              Table(
                border: TableBorder.all(width: 0, color: Colors.transparent),
                defaultVerticalAlignment: TableCellVerticalAlignment.top,
                columnWidths: const {
                  0: FlexColumnWidth(3), // DESCRIPTION
                  1: FlexColumnWidth(2), // RATE
                  2: FlexColumnWidth(1), // QTY
                  3: FlexColumnWidth(3), // AMOUNT
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: primaryColor4,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 5.w, top: 8.h, bottom: 8.h),
                        child: Text(
                          'DESC.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(color: Colors.white),
                            children:  [
                              TextSpan(text: 'RATE (', style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(color: Colors.white),),
                              const WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child:
                                AppNaira(fontSize: 16, color: Colors.white),
                              ),
                              TextSpan(text: ')'),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                        child: Text(
                          'QTY',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: 14.w, top: 8.h, bottom: 8.h),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(color: Colors.white),
                            children: const [
                              TextSpan(text: 'AMT. ('),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child:
                                AppNaira(fontSize: 16, color: Colors.white),
                              ),
                              TextSpan(text: ')'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...record.recordProductDetails.map(
                        (row) => TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 4.h, bottom: 4.h, left: 18.w),
                          child: Text(
                            row.product?.name ?? '',
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 14.sp, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 4.h, bottom: 4.h, left: 5.w),
                          child: Text(
                            (double.tryParse(row.price ?? '0') ?? 0)
                                .toString()
                                .commaSeparated(),
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 14.sp, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 4.h, bottom: 4.h, left: 5.w),
                          child: Text(
                            (row.quantity ?? 0).toString(),
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 14.sp, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 4.h, bottom: 4.h, left: 5.w, right: 18.w),
                          child: Text(
                            ((double.tryParse(row.price ?? '0') ?? 0) *
                                (row.quantity ?? 0))
                                .toString()
                                .commaSeparated(),
                            textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 14.sp, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 24.h, bottom: 12.h, left: 18.w),
                        child: Text(
                          "SUBTOTAL",
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(fontSize: 14.sp, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24.h, bottom: 12.h),
                        child: const Text(
                          "",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24.h, bottom: 12.h),
                        child: const Text(
                          "",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 24.h, bottom: 12.h, left: 5.w, right: 18.w),
                        child: Text(
                          subtotal.toString().commaSeparated(),
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontSize: 14.sp, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 18.w),
                        child: Text(
                          "DISCOUNT",
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(fontSize: 14.sp, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          " ",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontSize: 14.sp, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 12.h, bottom: 12.h, right: 18.w, left: 5.w),
                        child: Text(
                          discount.toString().commaSeparated(),
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontSize: 14.sp, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 18.w),
                        child: Text(
                          "VAT",
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(fontSize: 14.sp, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          " ",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontSize: 14.sp, color: Colors.black),
                        ),
                      ),
                      Text(
                        "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 12.h, bottom: 12.h, left: 5.w, right: 18.w),
                        child: Text(
                          vat.toString().commaSeparated(),
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontSize: 14.sp, color: Colors.black),
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
                        padding: EdgeInsets.only(
                            top: 6.h, bottom: 6.h, left: 18.w),
                        child: Text(
                          "GRAND TOTAL",
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(fontSize: 14.sp, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: const Text(
                          "",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: const Text(
                          "",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 6.h, bottom: 6.h, left: 5.w, right: 18.w),
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(fontSize: 14.sp, color: Colors.white),
                            children: [
                              const WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child:
                                AppNaira(fontSize: 14, color: Colors.white),
                              ),
                              TextSpan(
                                  text: grandTotal.toString().commaSeparated()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              38.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
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
                                  fontWeight: FontWeight.w600),
                            ),
                            12.verticalSpace,
                            if (record.business != null) ...[
                              Text(
                                record.business!.accountNumber?.toString() ??
                                    'N/A',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                    fontSize: 16.sp, color: Colors.black),
                              ),
                              4.verticalSpace,
                              Text(
                                record.business!.bankName?.toString() ?? 'N/A',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                    fontSize: 16.sp, color: Colors.black),
                              ),
                              4.verticalSpace,
                              Text(
                                record.business!.accountName?.toString() ??
                                    'N/A',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                    fontSize: 16.sp, color: Colors.black),
                              ),
                            ] else ...[
                              Text(
                                'Business information unavailable',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                    fontSize: 15.sp, color: Colors.black),
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
                                  fontSize: 44.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Via ${record.modeOfPayment ?? ''}"
                                  .capitalizeEachWord(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                  fontSize: 14.sp, color: Colors.black),
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
                            width: 100.w,
                            height: 50.h,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 100.w,
                                  height: 50.h,
                                  color: Colors.grey[200],
                                ),
                          )
                              : Container(
                            width: 40.w,
                            height: 24.h,
                            color: Colors.grey[200],
                          ),
                          18.verticalSpace,
                          Text(
                            record.business?.issuer ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(color: Colors.black),
                          ),
                          Text(
                            "Business Manager",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                fontSize: 14.sp, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              24.verticalSpace,
              Text(
                "Generated with Payvidence",
                textAlign: TextAlign.center,
                style: GoogleFonts.marckScript(
                  fontSize: 16.sp,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              12.verticalSpace,
            ],
          ),
        ),
        Positioned(
          top: -50,
          right: -50,
          child: ClipOval(
            child: Container(
              width: 100,
              height: 100,
              color: primaryColor4,
            ),
          ),
        ),
        Positioned(
          top: -50,
          left: -50,
          child: ClipOval(
            child: Container(
              width: 100,
              height: 100,
              color: primaryColor4,
            ),
          ),
        ),
      ],
    );
  }
}