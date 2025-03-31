import 'dart:io';
import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';
import 'package:payvidence/utilities/extensions.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../../components/app_button.dart';
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
        name: 'receipt${DateTime.now().toIso8601String()}.png',
        mimeType: 'image/png',
      );
    }

    Future<void> saveImage(XFile imageFile) async {
      //final request = await Permission.storage.request();
      // Create Progress Dialog
      ProgressDialog pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: 'File Downloading...');

      // Get the app's documents directory
      Directory directory = await getApplicationDocumentsDirectory();

      // Save the image to a file path
      String imagePath =
          '${directory.path}/${imageFile.name}.png'; // Add a proper file extension (like .png)

// Write the file to the correct path
      File file =
          await File(imagePath).writeAsBytes(await imageFile.readAsBytes());

      // Save to gallery using ImageGallerySaver (alternative for direct access)
      await ImageGallerySaver.saveFile(file.path);

      pd.close(); // Hide the progress dialog

      // Show success message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Image Saved"),
          content: const Text("Image has been saved to device"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
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
                        draft: record,
                        isInvoice: true,
                        inVoiceToReceipt: true));
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
              SizedBox(
                height: 32.h,
              ),
              RepaintBoundary(
                key: globalKey,
                child: ContainerWithClippedCircles(
                  record: record,
                  isInvoice: isInvoice ?? false,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
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
                  SizedBox(
                    height: 26.h,
                  ),
                  GestureDetector(
                    onTap: () async {
                      saveImage(await capturePng());
                    },
                    child: Text(
                      'Download ${isInvoice == true ? 'invoice' : 'receipt'}',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: primaryColor2),
                    ),
                  ),
                  12.verticalSpace
                ],
              )
            ],
          ),
        ),
      ),
      // AppButton(buttonText: 'Generate receipt', onPressed: (){
      //   // context.push('/addBusiness');
      // }),
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
    return Stack(
      children: [
        // Main Container
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          width: ScreenUtil().screenWidth,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              50.verticalSpace,
              Text("Transaction ${isInvoice == true ? 'invoice' : 'receipt'}"),
              12.verticalSpace,
              const CircleAvatar(
                radius: 30,
              ),
              12.verticalSpace,
              Text(record.business?.name ?? ''),
              6.verticalSpace,
              Text(record.business?.address ?? ''),
              6.verticalSpace,
              Text(record.business?.phoneNumber ?? ''),
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Bill to: "),
                      6.verticalSpace,
                      Text(record.client?.name ?? ''),
                      6.verticalSpace,
                      Text(record.client?.phoneNumber ?? ''),
                      6.verticalSpace,
                      Text(record.client?.address ?? ''),
                    ],
                  )),
                  12.horizontalSpace,
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("Tracking id: "),
                      6.verticalSpace,
                      Text(record.id?.substring(0, 13) ?? ''),
                      6.verticalSpace,
                      Text(DateFormat.yMMMEd().format(record.createdAt!)),
                    ],
                  ))
                ],
              ),
              6.verticalSpace,
              Table(
                  border: TableBorder.all(width: 0), // Adds borders to cells
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    // Header Row
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Description',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Rate(N)',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Qty',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Amount(N)',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    ...record.recordProductDetails!
                        .map((row) => TableRow(
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(row.product?.name ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      row.product?.price?.commaSeparated() ??
                                          '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(row.quantity.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      '${double.tryParse(row.price!)! * row.quantity!}'
                                          .commaSeparated(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ))
                        .toList()
                  ]),
              6.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Subtotal",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(record.total!.commaSeparated(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              6.verticalSpace,
              for (var row in record.recordProductDetails!)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("discount",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(row.discount ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Text(/*row.price!.commaSeparated()*/ '',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              6.verticalSpace,
              for (var row in record.recordProductDetails!)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("VAT        ",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(row.product?.vat ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Text(/*row.price!.commaSeparated()*/ '',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              6.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Grand total",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(record.total!.commaSeparated(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              12.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Visibility(
                      visible: isInvoice == false,
                      replacement: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Payment info"),
                          Text(record.business?.accountNumber ?? ''),
                          Text(record.business?.bankName ?? ''),
                          Text(record.business?.accountName ?? '')
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text("Paid via"),
                          Text(record.modeOfPayment ?? '')
                        ],
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      children: [
                        Text(record.business?.name ?? ''),
                        const Text("Business Manager")
                      ],
                    ),
                  ),
                ],
              ),
              12.verticalSpace,
              const Text("Generated with payvidence",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              12.verticalSpace,
            ],
          ),
        ),

        // Purple Circle (Top-Right)
        Positioned(
          top: -50, // Adjust position to clip
          right: -50,
          child: ClipOval(
            child: Container(
              width: 100,
              height: 100,
              color: Colors.purple[400],
            ),
          ),
        ),

        // Purple Circle (Top-Left)
        Positioned(
          top: -50,
          left: -50,
          child: ClipOval(
            child: Container(
              width: 100,
              height: 100,
              color: Colors.purple[400],
            ),
          ),
        ),
      ],
    );
  }
}
