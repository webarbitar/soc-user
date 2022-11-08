import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:path_provider/path_provider.dart';

import '../../modal/booking/booked_service_details_model.dart';
import '../../modal/service/category_service_modal.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class BookingInvoiceUtil {
  final BookedServiceDetailsModel _bookingDetails;
  final List<CategoryServiceModal> _bookedServices;

  BookingInvoiceUtil(
      {required BookedServiceDetailsModel bookingDetails,
      required List<CategoryServiceModal> bookedServices})
      : _bookingDetails = bookingDetails,
        _bookedServices = bookedServices;

  final pdf = Document();

  late Font _montserrat;

  static formatPrice(double price) => 'Rs. ${price.toStringAsFixed(2)}';

  static formatDate(DateTime date) => DateFormat.yMd().format(date);

  static priceWithoutGST(int price) {
    return price - (price * 0.18);
  }

  static Future<File> saveDocument({required String name, required Document pdf}) async {
    final bytes = await pdf.save();
    const dir = '/storage/emulated/0/Download';
    final file = File('$dir/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<File> generate() async {
    final font = await rootBundle.load("assets/fonts/Montserrat-Regular.ttf");
    _montserrat = Font.ttf(font);
    final logo = MemoryImage(
      (await rootBundle.load('assets/images/logo-banner.jpeg')).buffer.asUint8List(),
    );
    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        maxPages: 2,
        build: (context) => [
          buildHeader(logo),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Divider(),
          SizedBox(height: 1 * PdfPageFormat.cm),
          _buildSubHeader(),
          SizedBox(height: 1 * PdfPageFormat.cm),
          _buildInvoice(),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          if (_bookingDetails.spares.isNotEmpty)
            Text(
              "Additional Parts",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                font: _montserrat,
              ),
            ),
          if (_bookingDetails.spares.isNotEmpty) SizedBox(height: PdfPageFormat.cm),
          if (_bookingDetails.spares.isNotEmpty) _buildCustomPartInvoice(),
          Divider(),
          buildTotal(),
          _buildEndingNotes(),
        ],
        footer: (context) => buildFooter(),
      ),
    );

    return saveDocument(name: 'invoice-${_bookingDetails.bookingId}.pdf', pdf: pdf);
  }

  Widget buildHeader(logo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(logo, width: 140),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Service On Clap",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                font: _montserrat,
              ),
            ),
            Text(
              "Shivaji Nagar, Ramjaipal path Bailey Road",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                font: _montserrat,
              ),
            ),
            Text(
              "Patna Bihar, Bihar 801503",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                font: _montserrat,
              ),
            ),
            Text(
              "Patna 91-8544070668 , Jamshedpur +917004215423 +916209376053, Howrah +916291541796, Kolkata +919804110237",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                font: _montserrat,
              ),
              textDirection: TextDirection.rtl,
            ),
            Text(
              "info@socspl.com",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: PdfColor.fromHex("#4287f5"),
                font: _montserrat,
              ),
            ),
            Text(
              "GSTIN : 10ABECS0453K1ZN",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                font: _montserrat,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildSubHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "BILL TO:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  font: _montserrat,
                ),
              ),
              Text(
                _bookingDetails.address.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  font: _montserrat,
                ),
              ),
              Text(
                _bookingDetails.address.formattedAddress,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  font: _montserrat,
                ),
              ),
              Text(
                "N/A",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  font: _montserrat,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _bookingDetails.bookingId,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: PdfColor.fromHex("#4287f5"),
                  font: _montserrat,
                ),
              ),
              Text(
                "Booking Date: ${formatDate(_bookingDetails.bookingDateTime)}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  font: _montserrat,
                ),
              ),
              Text(
                "Technician Name : ${_bookingDetails.serviceProvider!.name}",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  font: _montserrat,
                ),
              ),
              Text(
                "Payment Mode: ",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  font: _montserrat,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInvoice() {
    final headers = ['SN', 'SERVICE DETAILS', 'QUANTITY', 'SALE PRICE', 'TOTAL'];
    final List<List> dataList = [];
    for (var bk in _bookingDetails.services) {
      var srv = _bookedServices.singleWhere((element) => element.id == bk.serviceId);
      dataList.add([
        '${_bookingDetails.services.indexOf(bk) + 1}',
        srv.name,
        "${bk.quantity}",
        '${formatPrice(priceWithoutGST(bk.price))}',
        '${formatPrice(priceWithoutGST(bk.total))}',
      ]);
      for (var adn in bk.addonService) {
        dataList.add([
          '',
          adn.addOn.name,
          "${adn.quantity}",
          '${formatPrice(priceWithoutGST(adn.price))}',
          '${formatPrice(priceWithoutGST(adn.total))}',
        ]);
      }
      for (var rt in bk.rateCards) {
        dataList.add([
          '',
          rt.rateCard.name,
          "${rt.quantity}",
          '${formatPrice(priceWithoutGST(rt.price))}',
          '${formatPrice(priceWithoutGST(rt.amount))}',
        ]);
      }
    }

    return Table.fromTextArray(
      headers: headers,
      columnWidths: {
        0: const FlexColumnWidth(1),
        1: const FlexColumnWidth(4),
        2: const FlexColumnWidth(2),
        3: const FlexColumnWidth(3),
        4: const FlexColumnWidth(3),
      },
      data: dataList,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
      },
    );
  }

  Widget _buildCustomPartInvoice() {
    final headers = ['SN', 'ADDITIONAL PARTS NAME', 'PART PRICE', 'TOTAL'];
    final List<List> dataList = [];
    for (var bk in _bookingDetails.spares) {
      dataList.add([
        '${_bookingDetails.spares.indexOf(bk) + 1}',
        bk.name,
        '${formatPrice(priceWithoutGST(bk.total))}',
        '${formatPrice(priceWithoutGST(bk.total))}',
      ]);
    }

    return Table.fromTextArray(
      headerAlignment: Alignment.center,
      headers: headers,
      data: dataList,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      columnWidths: {
        0: const FlexColumnWidth(2),
        1: const FlexColumnWidth(4),
        2: const FlexColumnWidth(2),
        3: const FlexColumnWidth(2),
        4: const FlexColumnWidth(2),
      },
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
      },
    );
  }

  Widget _buildEndingNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Thank you!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, font: _montserrat),
        ),
        SizedBox(height: 2 * PdfPageFormat.cm),
        Text(
          "TERMS",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, font: _montserrat),
        ),
        Text(
          "Please read term & Condition https://www.socspl.com/terms_conditions",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, font: _montserrat),
        ),
      ],
    );
  }

  Widget buildTotal() {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Sub total',
                  value: formatPrice(priceWithoutGST(_bookingDetails.amount)),
                  unite: true,
                ),
                Divider(),
                SizedBox(height: 2 * PdfPageFormat.mm),
                buildText(
                  title: 'GST (18%)',
                  value: formatPrice(_bookingDetails.amount * 0.18),
                  unite: true,
                ),
                Divider(),
                SizedBox(height: 2 * PdfPageFormat.mm),
                buildText(
                  title: 'Total',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: formatPrice(_bookingDetails.amount.toDouble()),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(
              title: '', value: "Note: System generated invoice seal & signature not required"),
        ],
      );

  static buildSimpleText({required String title, required String value}) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
