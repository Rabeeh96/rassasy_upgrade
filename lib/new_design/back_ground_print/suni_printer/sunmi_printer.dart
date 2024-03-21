import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

class SunmiPrint {
  initialPrint() {
    _bindingPrinter().then((bool isBind) async {});
  }

  Future<bool> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result!;
  }

  printType() {
    printSunmi();
  }

  printSunmi() async {
    print("sunmi start to print");

    try {
      var invoiceType;
      var invoiceTypeArabic;

      invoiceType = "SIMPLIFIED TAX INVOICE";
      invoiceTypeArabic = "فاتورة ضريبية مبسطة";

      var companyName = "Vikn";
      var companyDescription = "Sahya complex calicut";

      var voucherNumber = "SO 13";
      var name = "Nashid ";
      var date = "2020-02-02";
      var phone = "8714152075";
      var grossAmount = "250";
      var discount = "20";
      var totalTax = "10";
      var grandTotal = "260";
      var token = "TK 002";

      await SunmiPrinter.initPrinter();
      await SunmiPrinter.startTransactionPrint(true);
      await SunmiPrinter.bold();

      await SunmiPrinter.printText(companyName,
          style: SunmiStyle(align: SunmiPrintAlign.CENTER));

      if (companyDescription != "") {
        await SunmiPrinter.printText(companyDescription,
            style: SunmiStyle(align: SunmiPrintAlign.CENTER));
      }

      await SunmiPrinter.resetBold();

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
            text: invoiceType, width: 30, align: SunmiPrintAlign.CENTER),
      ]);
      await SunmiPrinter.printText(invoiceTypeArabic,
          style: SunmiStyle(align: SunmiPrintAlign.CENTER));

      await SunmiPrinter.line();

      await SunmiPrinter.printText('     رمز لا' + " : " + token,
          style: SunmiStyle(align: SunmiPrintAlign.CENTER));
      await SunmiPrinter.printText('    رقم الفاتورة' + " : " + voucherNumber,
          style: SunmiStyle(align: SunmiPrintAlign.CENTER));
      await SunmiPrinter.printText('    تاريخ' + " : " + date,
          style: SunmiStyle(align: SunmiPrintAlign.CENTER));

      await SunmiPrinter.printText('    اسم' + " : " + name,
          style: SunmiStyle(align: SunmiPrintAlign.CENTER));

      await SunmiPrinter.printText('    هاتف' + " : " + phone,
          style: SunmiStyle(align: SunmiPrintAlign.CENTER));

      await SunmiPrinter.line();
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(text: 'Name', width: 9, align: SunmiPrintAlign.LEFT),
        ColumnMaker(text: 'Qty', width: 6, align: SunmiPrintAlign.CENTER),
        ColumnMaker(text: 'Price', width: 8, align: SunmiPrintAlign.RIGHT),
        ColumnMaker(text: 'Net', width: 7, align: SunmiPrintAlign.RIGHT),
      ]);
      await SunmiPrinter.printText('مقدار    وحدة      كمية       اسم',
          style: SunmiStyle(align: SunmiPrintAlign.LEFT));

      await SunmiPrinter.line();
      await SunmiPrinter.setCustomFontSize(20);

      await SunmiPrinter.printText('(خصم)',
          style: SunmiStyle(align: SunmiPrintAlign.LEFT));
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(text: 'Total Tax', width: 20, align: SunmiPrintAlign.LEFT),
        ColumnMaker(text: totalTax, width: 10, align: SunmiPrintAlign.RIGHT),
      ]);
      await SunmiPrinter.printText('(مجموع الضريبة)',
          style: SunmiStyle(align: SunmiPrintAlign.LEFT));
      await SunmiPrinter.line();
      await SunmiPrinter.bold();
      await SunmiPrinter.line();
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.line();
      await SunmiPrinter.lineWrap(2);
      await SunmiPrinter.cut();
      await SunmiPrinter.exitTransactionPrint(true);
    } catch (e) {
      print(e.toString());
    }
  }
}
