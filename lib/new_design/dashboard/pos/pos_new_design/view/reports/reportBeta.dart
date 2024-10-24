import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/controller/report_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/view/reports/reportlist.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/view/reports/rms.dart';

class ReportPageNewbeta extends StatefulWidget {
  const ReportPageNewbeta({super.key});

  @override
  State<ReportPageNewbeta> createState() => _ReportPageNewbetaState();
}

class _ReportPageNewbetaState extends State<ReportPageNewbeta> {
  final ReportController reportController = Get.put(ReportController());
  final FocusNode _focusNode = FocusNode();
  DateTime _selectedDate = DateTime.now();

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != TimeOfDay.now()) {
      print("Selected time: ${picked.format(context)}");
    }
  }

  final int _radioValue = 1;

  @override
  void initState() {
    // TODO: implement initState
    reportController.getSalesReport();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      //!Left
                      SizedBox(
                          width: constraints.maxWidth * 0.7,
                          height: constraints.maxHeight * 1,
                          // height: constraints.maxHeight * 1,
                          child: Obx(
                            () {
                              return SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  icon: const Icon(
                                                    Icons.arrow_back,
                                                    color: Colors.black,
                                                  )),
                                              SizedBox(width: screenSize.width * 0.01),
                                              Text(
                                                "Report",
                                                style: googleFontStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      thickness: 1,
                                      color: Color(0xFFDEDEDE),
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    reportController.selectedValue.value == 'Invoice'
                                                        ? 'Invoice Report'
                                                        : reportController.selectedValue.value == 'Sales'
                                                            ? 'Sales Report'
                                                            : reportController.selectedValue.value == 'Salesorder'
                                                                ? 'Sales Order Report'
                                                                : reportController.selectedValue.value == 'Product'
                                                                    ? 'Product Report'
                                                                    : reportController.selectedValue.value == 'Tablewise'
                                                                        ? 'Table Wise Report'
                                                                        : reportController.selectedValue.value == 'Dailysummary'
                                                                            ? 'Daily Summary'
                                                                            : '',
                                                    style: googleFontStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Dining- 01 ',
                                                            style: googleFontStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                          const Text("|"),
                                                          Text(' Take Away- 03 ', style: googleFontStyle(fontWeight: FontWeight.bold)),
                                                          const Text("|"),
                                                          Text(' Online- 01', style: googleFontStyle(fontWeight: FontWeight.bold)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      ElevatedButton(
                                                        onPressed: () {},
                                                        style: ElevatedButton.styleFrom(
                                                          minimumSize: const Size(120, 45),
                                                          backgroundColor: Colors.white,
                                                          side: const BorderSide(width: 1, color: Color(0xFFDFE1E7)),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.cloud_download_outlined,
                                                              color: Color(0xFF394358),
                                                            ),
                                                            Text(
                                                              " Export",
                                                              style: googleFontStyle(
                                                                color: const Color(0xFF394358),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: screenSize.width * 0.01),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          reportController.getSalesReport();
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          minimumSize: const Size(120, 45),
                                                          backgroundColor: const Color(0xFF0A46A1),
                                                        ),
                                                        child: const Text(
                                                          "Print",
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: screenSize.height * 0.01),
                                              SizedBox(
                                                  // color: Colors.blue,
                                                  width: screenSize.width,
                                                  height: screenSize.height * 0.7,
                                                  child: SingleChildScrollView(
                                                    physics: const BouncingScrollPhysics(),
                                                    child: Column(
                                                      children: [
                                                        if (reportController.reporttype.value == 'Daily Summary') ...[
                                                          const Rms()
                                                        ] else if (reportController.reporttype.value == 'Sales Report') ...[
                                                          Padding(
                                                            padding: const EdgeInsets.all(16.0),
                                                            child: SizedBox(
                                                                height: screenSize.height * 0.8,
                                                                child: Obx(
                                                                  () {
                                                                    if (reportController.salesReportList.value.data!.isEmpty) {
                                                                      return const Center(child: Text('No data available'));
                                                                      // return const Center(
                                                                      //     child:
                                                                      //         CircularProgressIndicator());
                                                                    } else {
                                                                      return ListView.builder(
                                                                        itemCount: reportController.salesReportList.value.data!.length,
                                                                        itemBuilder: (context, index) {
                                                                          var reportData = reportController.salesReportList.value.data![index];
                                                                          return   ListTile(
                                                                            title: Text(
                                                                              'Voucher No: ${reportData.tokenNumber}',
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    }
                                                                  },
                                                                )),
                                                          )
                                                        ] else ...[
                                                          Padding(
                                                            padding: const EdgeInsets.all(16.0),
                                                            child: Column(
                                                              children: List.generate(
                                                                3,
                                                                (index) {
                                                                  return Column(
                                                                    children: [
                                                                      ReportList(),
                                                                      SizedBox(
                                                                        height: screenSize.height * 0.01,
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ],
                                                    ),
                                                  )),
                                              //          SizedBox(
                                              //   height:
                                              //       screenSize.height * 0.01,
                                              // ),
                                              if (reportController.reporttype.value == "Invoice Report" ||
                                                  reportController.reporttype.value == "Sales Report" ||
                                                  reportController.reporttype.value == "Sales Order Report") ...[
                                                Container(
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Gross: ",
                                                                  style: googleFontStyle(
                                                                      color: const Color(0xFF0C4000), fontWeight: FontWeight.w400, fontSize: 16),
                                                                ),
                                                                Text(
                                                                  "Rs.2123.00",
                                                                  style: googleFontStyle(
                                                                      color: const Color(0xFF0C4000), fontWeight: FontWeight.bold, fontSize: 16),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Tax: ",
                                                                  style: googleFontStyle(
                                                                      color: const Color(0xFF004067), fontWeight: FontWeight.w400, fontSize: 16),
                                                                ),
                                                                Text(
                                                                  "Rs.2123.00",
                                                                  style: googleFontStyle(
                                                                      color: const Color(0xFF004067), fontWeight: FontWeight.bold, fontSize: 16),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Bill Discount: ",
                                                                  style: googleFontStyle(
                                                                      color: const Color(0xFFB44800), fontWeight: FontWeight.w400, fontSize: 16),
                                                                ),
                                                                Text(
                                                                  "Rs.2123.00",
                                                                  style: googleFontStyle(
                                                                      color: const Color(0xFFB44800), fontWeight: FontWeight.bold, fontSize: 16),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Total: ",
                                                                  style: googleFontStyle(
                                                                      color: const Color(0xff000000), fontWeight: FontWeight.w400, fontSize: 16),
                                                                ),
                                                                Text(
                                                                  "Rs.2123.00",
                                                                  style: googleFontStyle(
                                                                      color: const Color(0xff000000), fontWeight: FontWeight.bold, fontSize: 16),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ] else if (reportController.reporttype.value == "Product Report") ...[
                                                Container(
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Total Sold: ",
                                                                  style: googleFontStyle(
                                                                      color: const Color(0xff000000), fontWeight: FontWeight.w400, fontSize: 16),
                                                                ),
                                                                Text(
                                                                  "Rs.150",
                                                                  style: googleFontStyle(
                                                                      color: const Color(0xff000000), fontWeight: FontWeight.bold, fontSize: 16),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(width: screenSize.width * 0.03),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Total: ",
                                                                  style: googleFontStyle(
                                                                      color: const Color(0xff000000), fontWeight: FontWeight.w400, fontSize: 16),
                                                                ),
                                                                Text(
                                                                  "Rs.2000.00",
                                                                  style: googleFontStyle(
                                                                      color: const Color(0xff000000), fontWeight: FontWeight.bold, fontSize: 16),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ] else if (reportController.reporttype.value == "Table Wise Report") ...[
                                                Container(
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Ordered Amount: ",
                                                                  style: googleFontStyle(
                                                                      color: const Color(0xff000000), fontWeight: FontWeight.w400, fontSize: 16),
                                                                ),
                                                                Text(
                                                                  "Rs.2123.00",
                                                                  style: googleFontStyle(
                                                                      color: const Color(0xff000000), fontWeight: FontWeight.bold, fontSize: 16),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(width: screenSize.width * 0.03),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Total Sales: ",
                                                                  style: googleFontStyle(
                                                                      color: const Color(0xff000000), fontWeight: FontWeight.w400, fontSize: 16),
                                                                ),
                                                                Text(
                                                                  "Rs.2123.00",
                                                                  style: googleFontStyle(
                                                                      color: const Color(0xff000000), fontWeight: FontWeight.bold, fontSize: 16),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ]
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          )),
                      //!Right
                      Obx(
                        () {
                          return Column(
                            children: [
                              Container(
                                height: constraints.maxHeight * 0.1,
                                width: constraints.maxWidth - (constraints.maxWidth * 0.7),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF6F8FE),
                                  border: Border(
                                    left: BorderSide(
                                      width: 2,
                                      color: Color(0xFFDFE1E7),
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: constraints.maxHeight * 0.9,
                                    width: constraints.maxWidth - (constraints.maxWidth * 0.7),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF6F8FE),
                                      border: Border(
                                        left: BorderSide(
                                          width: 2,
                                          color: Color(0xFFDFE1E7),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 25, right: 25, top: 8, bottom: 25),
                                      child: Container(
                                        color: const Color(0xFFF6F8FE),
                                        child: SingleChildScrollView(
                                          physics: const BouncingScrollPhysics(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Report Type",
                                                  style: googleFontStyle(fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: screenSize.height * 0.01),
                                                Center(
                                                  child: Container(
                                                    width: screenSize.width,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(color: Colors.grey),
                                                    ),
                                                    child: DropdownButtonFormField<String>(
                                                      icon: const Icon(null),
                                                      focusNode: _focusNode,
                                                      decoration: InputDecoration(
                                                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                        suffixIcon: const Icon(
                                                          Icons.keyboard_arrow_down_outlined,
                                                          color: Color(0xFF000000),
                                                        ),
                                                        fillColor: Colors.white,
                                                        focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(5),
                                                          borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                        ),
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(5),
                                                          borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(5),
                                                          borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                        ),
                                                      ),
                                                      value: reportController.selectedValue.value,
                                                      onChanged: (value) {
                                                        reportController.reportonChanged(value);
                                                        _focusNode.unfocus();
                                                      },
                                                      dropdownColor: Colors.white,
                                                      items: const [
                                                        DropdownMenuItem<String>(
                                                          value: 'Invoice',
                                                          child: Text('Invoice Report'),
                                                        ),
                                                        DropdownMenuItem<String>(
                                                          value: 'Sales',
                                                          child: Text('Sales Report'),
                                                        ),
                                                        DropdownMenuItem<String>(
                                                          value: 'Salesorder',
                                                          child: Text('Sales Order Report'),
                                                        ),
                                                        DropdownMenuItem<String>(
                                                          value: 'Product',
                                                          child: Text('Product Report'),
                                                        ),
                                                        DropdownMenuItem<String>(
                                                          value: 'Tablewise',
                                                          child: Text('Table Wise Report'),
                                                        ),
                                                        DropdownMenuItem<String>(
                                                          value: 'Dailysummary',
                                                          child: Text('Daily Summary'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: screenSize.height * 0.01),
                                                if (reportController.reporttype.value == 'Product Report') ...[
                                                  SizedBox(height: screenSize.height * 0.01),
                                                  Container(
                                                    height: screenSize.height * 0.08,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(color: Colors.grey, width: 1),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Radio(
                                                              activeColor: const Color(0xFF00428E),
                                                              value: 1,
                                                              groupValue: reportController.productValue.value,
                                                              onChanged: (value) {
                                                                reportController.productValue.value = value as int;
                                                              },
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                reportController.productValue.value = 1;
                                                              },
                                                              child: Text(
                                                                "Product",
                                                                style: googleFontStyle(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Radio(
                                                              activeColor: const Color(0xFF00428E),
                                                              value: 2,
                                                              groupValue: reportController.productValue.value,
                                                              onChanged: (value) {
                                                                reportController.productValue.value = value as int;
                                                              },
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                reportController.productValue.value = 2;
                                                              },
                                                              child: Text(
                                                                "Product Group",
                                                                style: googleFontStyle(),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                                SizedBox(height: screenSize.height * 0.01),
                                                Text(
                                                  "User",
                                                  style: googleFontStyle(fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: screenSize.height * 0.01),
                                                Center(
                                                  child: Container(
                                                    width: screenSize.width,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(color: Colors.grey),
                                                    ),
                                                    child: DropdownButtonFormField<String>(
                                                      icon: const Icon(null),
                                                      value: 'None',
                                                      onChanged: (value) {},
                                                      decoration: InputDecoration(
                                                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                        suffixIcon: const Icon(
                                                          Icons.keyboard_arrow_down_outlined,
                                                          color: Color(0xFF000000),
                                                        ),
                                                        fillColor: Colors.white,
                                                        focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(5),
                                                          borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                        ),
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(5),
                                                          borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(5),
                                                          borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                        ),
                                                      ),
                                                      dropdownColor: Colors.white,
                                                      items: const [
                                                        DropdownMenuItem<String>(
                                                          value: 'None',
                                                          child: Text('None'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: screenSize.height * 0.01),
                                                if (reportController.reporttype.value == 'Product Report') ...[
                                                  Text(
                                                    "Select Product",
                                                    style: googleFontStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(height: screenSize.height * 0.01),
                                                  Center(
                                                    child: Container(
                                                      width: screenSize.width,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(color: Colors.grey),
                                                      ),
                                                      child: DropdownButtonFormField<String>(
                                                        icon: const Icon(null),
                                                        value: reportController.selectproduct.value,
                                                        onChanged: (value) {
                                                          reportController.selectproduct.value = value!;
                                                        },
                                                        decoration: InputDecoration(
                                                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                          suffixIcon: const Icon(
                                                            Icons.keyboard_arrow_down_outlined,
                                                            color: Color(0xFF000000),
                                                          ),
                                                          fillColor: Colors.white,
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                            borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                          ),
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                            borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                            borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                          ),
                                                        ),
                                                        dropdownColor: Colors.white,
                                                        items: const [
                                                          DropdownMenuItem<String>(
                                                            value: 'cbf',
                                                            child: Text('Chicken Biriyani'),
                                                          ),
                                                          DropdownMenuItem<String>(
                                                            value: 'mandhi',
                                                            child: Text('Mandhi'),
                                                          ),
                                                          DropdownMenuItem<String>(
                                                            value: 'bf',
                                                            child: Text('Beef Fry'),
                                                          ),
                                                          DropdownMenuItem<String>(
                                                            value: 'ch',
                                                            child: Text('Chicken Handi'),
                                                          ),
                                                          DropdownMenuItem<String>(
                                                            value: 'kf',
                                                            child: Text('Kadai Fish'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: screenSize.height * 0.01),
                                                  if (reportController.reporttype.value == 'Product Report') ...[
                                                    if (reportController.productValue.value == 2) ...[
                                                      Text(
                                                        "Product Group",
                                                        style: googleFontStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                      SizedBox(height: screenSize.height * 0.01),
                                                      Center(
                                                        child: Container(
                                                          width: screenSize.width,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(color: Colors.grey),
                                                          ),
                                                          child: DropdownButtonFormField<String>(
                                                            icon: const Icon(null),
                                                            value: reportController.selectproductgroup.value,
                                                            onChanged: (value) {
                                                              reportController.selectproductgroup.value = value!;
                                                            },
                                                            decoration: InputDecoration(
                                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                              suffixIcon: const Icon(
                                                                Icons.keyboard_arrow_down_outlined,
                                                                color: Color(0xFF000000),
                                                              ),
                                                              fillColor: Colors.white,
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(5),
                                                                borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                              ),
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(5),
                                                                borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(5),
                                                                borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                              ),
                                                            ),
                                                            dropdownColor: Colors.white,
                                                            items: const [
                                                              DropdownMenuItem<String>(
                                                                value: 'All',
                                                                child: Text('All'),
                                                              ),
                                                              DropdownMenuItem<String>(
                                                                value: 'Veg',
                                                                child: Text('Veg'),
                                                              ),
                                                              DropdownMenuItem<String>(
                                                                value: 'Nonveg',
                                                                child: Text('Nonveg'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: screenSize.height * 0.02),
                                                    ],
                                                  ],
                                                  Text(
                                                    "Salesman",
                                                    style: googleFontStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(height: screenSize.height * 0.01),
                                                  Center(
                                                    child: Container(
                                                      width: screenSize.width,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(color: Colors.grey),
                                                      ),
                                                      child: DropdownButtonFormField<String>(
                                                        icon: const Icon(null),
                                                        value: 'Salesman',
                                                        onChanged: (value) {},
                                                        decoration: InputDecoration(
                                                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                          suffixIcon: const Icon(
                                                            Icons.keyboard_arrow_down_outlined,
                                                            color: Color(0xFF000000),
                                                          ),
                                                          fillColor: Colors.white,
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                            borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                          ),
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                            borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                            borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                          ),
                                                        ),
                                                        dropdownColor: Colors.white,
                                                        items: const [
                                                          DropdownMenuItem<String>(
                                                            value: 'Salesman',
                                                            child: Text('Salesman'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: screenSize.height * 0.02),
                                                  if (reportController.reportDetailValue.value == 2) ...[
                                                    Text(
                                                      "Employee",
                                                      style: googleFontStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    SizedBox(height: screenSize.height * 0.01),
                                                    Center(
                                                      child: Container(
                                                        width: screenSize.width,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          border: Border.all(color: Colors.grey),
                                                        ),
                                                        child: DropdownButtonFormField<String>(
                                                          icon: const Icon(null),
                                                          value: 'None',
                                                          onChanged: (value) {},
                                                          decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                            suffixIcon: const Icon(
                                                              Icons.keyboard_arrow_down_outlined,
                                                              color: Color(0xFF000000),
                                                            ),
                                                            fillColor: Colors.white,
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                          ),
                                                          dropdownColor: Colors.white,
                                                          items: const [
                                                            DropdownMenuItem<String>(
                                                              value: 'None',
                                                              child: Text('None'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: screenSize.height * 0.02),
                                                    Text(
                                                      "Table",
                                                      style: googleFontStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    SizedBox(height: screenSize.height * 0.01),
                                                    Center(
                                                      child: Container(
                                                        width: screenSize.width,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          border: Border.all(color: Colors.grey),
                                                        ),
                                                        child: DropdownButtonFormField<String>(
                                                          icon: const Icon(null),
                                                          value: '21',
                                                          onChanged: (value) {},
                                                          decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                            suffixIcon: const Icon(
                                                              Icons.keyboard_arrow_down_outlined,
                                                              color: Color(0xFF000000),
                                                            ),
                                                            fillColor: Colors.white,
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                          ),
                                                          dropdownColor: Colors.white,
                                                          items: const [
                                                            DropdownMenuItem<String>(
                                                              value: '21',
                                                              child: Text('21'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: screenSize.height * 0.02),
                                                    if (reportController.productValue.value == 2) ...[
                                                      Text(
                                                        "Product Group",
                                                        style: googleFontStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                      SizedBox(height: screenSize.height * 0.01),
                                                      Center(
                                                        child: Container(
                                                          width: screenSize.width,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(color: Colors.grey),
                                                          ),
                                                          child: DropdownButtonFormField<String>(
                                                            icon: const Icon(null),
                                                            value: 'All',
                                                            onChanged: (value) {},
                                                            decoration: InputDecoration(
                                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                              suffixIcon: const Icon(
                                                                Icons.keyboard_arrow_down_outlined,
                                                                color: Color(0xFF000000),
                                                              ),
                                                              fillColor: Colors.white,
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(5),
                                                                borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                              ),
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(5),
                                                                borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(5),
                                                                borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                              ),
                                                            ),
                                                            dropdownColor: Colors.white,
                                                            items: const [
                                                              DropdownMenuItem<String>(
                                                                value: 'All',
                                                                child: Text('All'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: screenSize.height * 0.02),
                                                    ],
                                                  ],
                                                  Container(
                                                    /// Product (Consolidate and Detailed)
                                                    height: screenSize.height * 0.08,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(color: Colors.grey, width: 1),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Radio(
                                                              activeColor: const Color(0xFF00428E),
                                                              value: 1,
                                                              groupValue: reportController.reportDetailValue.value,
                                                              onChanged: (value) {
                                                                reportController.reportDetailValue.value = value as int;
                                                              },
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                reportController.reportDetailValue.value = 1;
                                                              },
                                                              child: Text(
                                                                "Consolidate",
                                                                style: googleFontStyle(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Radio(
                                                              activeColor: const Color(0xFF00428E),
                                                              value: 2,
                                                              groupValue: reportController.reportDetailValue.value,
                                                              onChanged: (value) {
                                                                reportController.reportDetailValue.value = value as int;
                                                              },
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                reportController.reportDetailValue.value = 2;
                                                              },
                                                              child: Text(
                                                                "Detailed",
                                                                style: googleFontStyle(),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                                if (reportController.reporttype.value == 'Product Report')
                                                  ...[]
                                                else if (reportController.reporttype.value == 'Table Wise Report' ||
                                                    reportController.reporttype.value == 'Sales Order Report' ||
                                                    reportController.reporttype.value == 'Sales Report' ||
                                                    reportController.reporttype.value == 'Invoice Report') ...[
                                                  Text(
                                                    "Employee",
                                                    style: googleFontStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(height: screenSize.height * 0.01),
                                                  Center(
                                                    child: Container(
                                                      width: screenSize.width,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(color: Colors.grey),
                                                      ),
                                                      child: DropdownButtonFormField<String>(
                                                        icon: const Icon(null),
                                                        onChanged: (value) {},
                                                        decoration: InputDecoration(
                                                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                          suffixIcon: const Icon(
                                                            Icons.keyboard_arrow_down_outlined,
                                                            color: Color(0xFF000000),
                                                          ),
                                                          fillColor: Colors.white,
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                            borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                          ),
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                            borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                            borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                          ),
                                                        ),
                                                        dropdownColor: Colors.white,
                                                        items: const [
                                                          DropdownMenuItem<String>(
                                                            value: '',
                                                            child: Text(''),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: screenSize.height * 0.01),
                                                  if (reportController.reporttype.value == "Table Wise Report")
                                                    ...[]
                                                  else ...[
                                                    Text(
                                                      "Service Type",
                                                      style: googleFontStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    SizedBox(height: screenSize.height * 0.01),
                                                    Center(
                                                      child: Container(
                                                        width: screenSize.width,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          border: Border.all(color: Colors.grey),
                                                        ),
                                                        child: DropdownButtonFormField<String>(
                                                          icon: const Icon(null),
                                                          decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                            suffixIcon: const Icon(
                                                              Icons.keyboard_arrow_down_outlined,
                                                              color: Color(0xFF000000),
                                                            ),
                                                            fillColor: Colors.white,
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                          ),
                                                          dropdownColor: Colors.white,
                                                          value: reportController.servicetypevalue.value,
                                                          onChanged: reportController.serviceonChanged,
                                                          items: const [
                                                            DropdownMenuItem<String>(
                                                              value: 'dinein',
                                                              child: Text('Dine In'),
                                                            ),
                                                            DropdownMenuItem<String>(
                                                              value: 'takeaway',
                                                              child: Text('Take Away'),
                                                            ),
                                                            DropdownMenuItem<String>(
                                                              value: 'online',
                                                              child: Text('Online'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: screenSize.height * 0.01),
                                                  ],
                                                  if (reportController.servicetype.value == 'Dine In') ...[
                                                    Text(
                                                      "Table",
                                                      style: googleFontStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    SizedBox(height: screenSize.height * 0.01),
                                                    Center(
                                                      child: Container(
                                                        width: screenSize.width,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          border: Border.all(color: Colors.grey),
                                                        ),
                                                        child: DropdownButtonFormField<String>(
                                                          icon: const Icon(null),
                                                          value: 'All',
                                                          onChanged: (value) {},
                                                          decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                            suffixIcon: const Icon(
                                                              Icons.keyboard_arrow_down_outlined,
                                                              color: Color(0xFF000000),
                                                            ),
                                                            fillColor: Colors.white,
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                          ),
                                                          dropdownColor: Colors.white,
                                                          items: const [
                                                            DropdownMenuItem<String>(
                                                              value: 'All',
                                                              child: Text('All'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: screenSize.height * 0.01),
                                                  ] else if (reportController.servicetype.value == 'Online') ...[
                                                    Text(
                                                      "Platform",
                                                      style: googleFontStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    SizedBox(height: screenSize.height * 0.01),
                                                    Center(
                                                      child: Container(
                                                        width: screenSize.width,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          border: Border.all(color: Colors.grey),
                                                        ),
                                                        child: DropdownButtonFormField<String>(
                                                          icon: const Icon(null),
                                                          value: 'hungerstation',
                                                          onChanged: (value) {},
                                                          decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                            suffixIcon: const Icon(
                                                              Icons.keyboard_arrow_down_outlined,
                                                              color: Color(0xFF000000),
                                                            ),
                                                            fillColor: Colors.white,
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                          ),
                                                          dropdownColor: Colors.white,
                                                          items: const [
                                                            DropdownMenuItem<String>(
                                                              value: 'hungerstation',
                                                              child: Text('Hungerstation'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: screenSize.height * 0.01),
                                                  ],
                                                  Text(
                                                    "Tax Type",
                                                    style: googleFontStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(height: screenSize.height * 0.01),
                                                  Center(
                                                    child: Container(
                                                      width: screenSize.width,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(color: Colors.grey),
                                                      ),
                                                      child: DropdownButtonFormField<String>(
                                                        icon: const Icon(null),
                                                        value: 'None',
                                                        onChanged: (value) {},
                                                        decoration: InputDecoration(
                                                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                          suffixIcon: const Icon(
                                                            Icons.keyboard_arrow_down_outlined,
                                                            color: Color(0xFF000000),
                                                          ),
                                                          fillColor: Colors.white,
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                            borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                          ),
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                            borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                            borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                          ),
                                                        ),
                                                        dropdownColor: Colors.white,
                                                        items: const [
                                                          DropdownMenuItem<String>(
                                                            value: 'None',
                                                            child: Text('None'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: screenSize.height * 0.01),
                                                  if (reportController.servicetype.value == "Take Away") ...[
                                                    /// Status in Service Type
                                                    Text(
                                                      "Status Type",
                                                      style: googleFontStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    SizedBox(height: screenSize.height * 0.01),
                                                    Center(
                                                      child: Container(
                                                        width: screenSize.width,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          border: Border.all(color: Colors.grey),
                                                        ),
                                                        child: DropdownButtonFormField<String>(
                                                          value: 'pending',
                                                          icon: const Icon(null),
                                                          onChanged: (value) {},
                                                          decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                            suffixIcon: const Icon(
                                                              Icons.keyboard_arrow_down_outlined,
                                                              color: Color(0xFF000000),
                                                            ),
                                                            fillColor: Colors.white,
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                          ),
                                                          dropdownColor: Colors.white,
                                                          items: const [
                                                            DropdownMenuItem<String>(
                                                              value: 'pending',
                                                              child: Text('Pending'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: screenSize.height * 0.01),
                                                  ],
                                                  if (reportController.reporttype.value == 'Sales Report' ||
                                                      reportController.reporttype.value == 'Table Wise Report') ...[
                                                    SizedBox(height: screenSize.height * 0.01),
                                                    Text(
                                                      "Payment Mode",
                                                      style: googleFontStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    SizedBox(height: screenSize.height * 0.01),
                                                    Center(
                                                      child: Container(
                                                        width: screenSize.width,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          border: Border.all(color: Colors.grey),
                                                        ),
                                                        child: DropdownButtonFormField<String>(
                                                          icon: const Icon(null),
                                                          value: 'Cash',
                                                          onChanged: (value) {},
                                                          decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                            suffixIcon: const Icon(
                                                              Icons.keyboard_arrow_down_outlined,
                                                              color: Color(0xFF000000),
                                                            ),
                                                            fillColor: Colors.white,
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                          ),
                                                          dropdownColor: Colors.white,
                                                          items: const [
                                                            DropdownMenuItem<String>(
                                                              value: 'Cash',
                                                              child: Text('Cash'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: screenSize.height * 0.01),
                                                    if (reportController.reporttype.value == "Table Wise Report") ...[
                                                      // Status Table wise
                                                      Text(
                                                        "Status",
                                                        style: googleFontStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                      SizedBox(height: screenSize.height * 0.01),
                                                      Center(
                                                        child: Container(
                                                          width: screenSize.width,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(color: Colors.grey),
                                                          ),
                                                          child: DropdownButtonFormField<String>(
                                                            icon: const Icon(null),
                                                            value: 'invoiced',
                                                            onChanged: (value) {},
                                                            decoration: InputDecoration(
                                                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                              suffixIcon: const Icon(
                                                                Icons.keyboard_arrow_down_outlined,
                                                                color: Color(0xFF000000),
                                                              ),
                                                              fillColor: Colors.white,
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(5),
                                                                borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                              ),
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(5),
                                                                borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(5),
                                                                borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                              ),
                                                            ),
                                                            dropdownColor: Colors.white,
                                                            items: const [
                                                              DropdownMenuItem<String>(
                                                                value: 'invoiced',
                                                                child: Text('Invoiced'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: screenSize.height * 0.01),
                                                    ]
                                                  ],
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "From",
                                                              style: googleFontStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: const Color(0xFFD1EFFF),
                                                                minimumSize: const Size(100, 40),
                                                              ),
                                                              onPressed: () {
                                                                _selectDate(context);
                                                              },
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  const Icon(
                                                                    Icons.calendar_today_outlined,
                                                                    color: Color(0xFF2B3F6C),
                                                                    size: 10,
                                                                  ),
                                                                  Text(
                                                                    " DD/MM/YYYY",
                                                                    style: googleFontStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 8,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: screenSize.width * 0.01,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "To",
                                                              style: googleFontStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: const Color(0xFFD1EFFF),
                                                                minimumSize: const Size(100, 40),
                                                              ),
                                                              onPressed: () {
                                                                _selectDate(context);
                                                              },
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  const Icon(
                                                                    Icons.calendar_today_outlined,
                                                                    color: Color(0xFF2B3F6C),
                                                                    size: 10,
                                                                  ),
                                                                  Text(
                                                                    " DD/MM/YYYY",
                                                                    style: googleFontStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 8,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                                if (reportController.reporttype.value == 'Daily Summary') ...[
                                                  Text(
                                                    "Employee",
                                                    style: googleFontStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(height: screenSize.height * 0.01),
                                                  Center(
                                                    child: Container(
                                                      width: screenSize.width,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(color: Colors.grey),
                                                      ),
                                                      child: DropdownButtonFormField<String>(
                                                        icon: const Icon(null),
                                                        onChanged: (value) {},
                                                        decoration: InputDecoration(
                                                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                          suffixIcon: const Icon(
                                                            Icons.keyboard_arrow_down_outlined,
                                                            color: Color(0xFF000000),
                                                          ),
                                                          fillColor: Colors.white,
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                            borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                          ),
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                            borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                            borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                          ),
                                                        ),
                                                        dropdownColor: Colors.white,
                                                        items: const [
                                                          DropdownMenuItem<String>(
                                                            value: '',
                                                            child: Text(''),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: screenSize.height * 0.01),
                                                  Text(
                                                    "Type",
                                                    style: googleFontStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(height: screenSize.height * 0.01),
                                                  Center(
                                                    child: Container(
                                                        width: screenSize.width,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          border: Border.all(color: Colors.grey),
                                                        ),
                                                        child: DropdownButtonFormField<String>(
                                                          icon: const Icon(null),
                                                          decoration: InputDecoration(
                                                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                            suffixIcon: const Icon(
                                                              Icons.keyboard_arrow_down_outlined,
                                                              color: Color(0xFF000000),
                                                            ),
                                                            fillColor: Colors.white,
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(5),
                                                              borderSide: const BorderSide(width: 0.1, color: Colors.grey),
                                                            ),
                                                          ),
                                                          dropdownColor: Colors.white,
                                                          value: reportController.rmstypevalue.value,
                                                          onChanged: reportController.rmstypeonChanged,
                                                          items: const [
                                                            DropdownMenuItem<String>(
                                                              value: 'date',
                                                              child: Text('Date'),
                                                            ),
                                                            DropdownMenuItem<String>(
                                                              value: 'transactiondate',
                                                              child: Text('Transaction Date'),
                                                            ),
                                                            DropdownMenuItem<String>(
                                                              value: 'createddate',
                                                              child: Text('Created Date'),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                  SizedBox(height: screenSize.height * 0.01),
                                                  if (reportController.rmstypevalue.value == "date") ...[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: const Color(0xFFD1EFFF),
                                                                  minimumSize: const Size(100, 40),
                                                                ),
                                                                onPressed: () {
                                                                  _selectDate(context);
                                                                },
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    const Icon(
                                                                      Icons.calendar_today_outlined,
                                                                      color: Color(0xFF2B3F6C),
                                                                      size: 10,
                                                                    ),
                                                                    Text(
                                                                      " DD/MM/YYYY",
                                                                      style: googleFontStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 8,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: screenSize.width * 0.01,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: const Color(0xFFD1EFFF),
                                                                  minimumSize: const Size(100, 40),
                                                                ),
                                                                onPressed: () {
                                                                  _selectDate(context);
                                                                },
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    const Icon(
                                                                      Icons.calendar_today_outlined,
                                                                      color: Color(0xFF2B3F6C),
                                                                      size: 10,
                                                                    ),
                                                                    Text(
                                                                      " DD/MM/YYYY",
                                                                      style: googleFontStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 8,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ] else if (reportController.rmstypevalue == 'transactiondate') ...[
                                                    Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: const Color(0xFFD1EFFF),
                                                                      minimumSize: const Size(100, 40),
                                                                    ),
                                                                    onPressed: () {
                                                                      _selectDate(context);
                                                                    },
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        const Icon(
                                                                          Icons.calendar_today_outlined,
                                                                          color: Color(0xFF2B3F6C),
                                                                          size: 10,
                                                                        ),
                                                                        Text(
                                                                          " DD/MM/YYYY",
                                                                          style: googleFontStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 8,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: screenSize.width * 0.01,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: const Color(0xFFD1EFFF),
                                                                      minimumSize: const Size(100, 40),
                                                                    ),
                                                                    onPressed: () {
                                                                      _selectDate(context);
                                                                    },
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        const Icon(
                                                                          Icons.calendar_today_outlined,
                                                                          color: Color(0xFF2B3F6C),
                                                                          size: 10,
                                                                        ),
                                                                        Text(
                                                                          " DD/MM/YYYY",
                                                                          style: googleFontStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 8,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: const Color(0xFFD1EFFF),
                                                                      minimumSize: const Size(100, 40),
                                                                    ),
                                                                    onPressed: () {
                                                                      _selectTime(context);
                                                                    },
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        const Icon(
                                                                          Icons.timer_sharp,
                                                                          color: Color(0xFF2B3F6C),
                                                                          size: 10,
                                                                        ),
                                                                        Text(
                                                                          " Time",
                                                                          style: googleFontStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 8,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: screenSize.width * 0.01,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: const Color(0xFFD1EFFF),
                                                                      minimumSize: const Size(100, 40),
                                                                    ),
                                                                    onPressed: () {
                                                                      _selectTime(context);
                                                                    },
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        const Icon(
                                                                          Icons.timer_sharp,
                                                                          color: Color(0xFF2B3F6C),
                                                                          size: 10,
                                                                        ),
                                                                        Text(
                                                                          " Time",
                                                                          style: googleFontStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 8,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ]
                                                ],
                                                SizedBox(height: screenSize.height * 0.02),
                                                if (reportController.reporttype.value == "Table Wise Report") ...[
                                                  /// Tablewise (Consolidate and Detailed)
                                                  Container(
                                                    height: screenSize.height * 0.08,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(color: Colors.grey, width: 1),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Radio(
                                                              activeColor: const Color(0xFF00428E),
                                                              value: 1,
                                                              groupValue: reportController.tablewisereportValue.value,
                                                              onChanged: (value) {
                                                                reportController.tablewisereportValue.value = value as int;
                                                              },
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                reportController.tablewisereportValue.value = 1;
                                                              },
                                                              child: Text(
                                                                "Consolidate",
                                                                style: googleFontStyle(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Radio(
                                                              activeColor: const Color(0xFF00428E),
                                                              value: 2,
                                                              groupValue: reportController.tablewisereportValue.value,
                                                              onChanged: (value) {
                                                                reportController.tablewisereportValue.value = value as int;
                                                              },
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                reportController.tablewisereportValue.value = 2;
                                                              },
                                                              child: Text(
                                                                "Detailed",
                                                                style: googleFontStyle(),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: screenSize.height * 0.02),
                                                ],
                                                SizedBox(
                                                  width: screenSize.width,
                                                  child: ElevatedButton(
                                                    onPressed: () {},
                                                    style: ElevatedButton.styleFrom(
                                                      minimumSize: const Size(220, 50),
                                                      backgroundColor: const Color(0xFFE28903),
                                                    ),
                                                    child: Text(
                                                      "Get Report",
                                                      style: googleFontStyle(fontSize: 16, color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
