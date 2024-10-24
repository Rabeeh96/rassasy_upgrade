import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/controller/report_controller.dart';

class ReportList extends StatelessWidget {
  ReportList({
    super.key,
  });

  final ReportController controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Obx(
      () {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  border: Border.all(color: const Color(0xFFCFCFCF)),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.reporttype.value == 'Product Report') ...[
                      if (controller.reportDetailValue.value == 1) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Product",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              controller.selectproduct.value == 'cbf'
                                  ? 'Chicken Biriyani Full'
                                  : controller.selectproduct.value == 'mandhi'
                                      ? 'Kuzhi Mandhi'
                                      : controller.selectproduct.value == 'bf'
                                          ? 'Beef Fry'
                                          : controller.selectproduct.value ==
                                                  'ch'
                                              ? 'Chicken Handi'
                                              : controller.selectproduct
                                                          .value ==
                                                      'kf'
                                                  ? 'Kadai Fish'
                                                  : '',
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Current Stock",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "60",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "No's of Sold",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "50",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        if (controller.productValue.value == 2) ...[
                          /// Product (Consolidate)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Product Group",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                controller.selectproductgroup.value == 'All'
                                    ? 'All'
                                    : controller.selectproductgroup.value ==
                                            'Veg'
                                        ? 'Vegetarian'
                                        : controller.selectproductgroup.value ==
                                                'Nonveg'
                                            ? 'Non-Veg'
                                            : '',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            ],
                          ),
                        ],
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cost",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "5.00",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "<Total Cost>",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ] else if (controller.reportDetailValue.value == 2) ...[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Table 1",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "<Date & Time>",
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Employee",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Employee 01",
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Product",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Chicken Patti Burger",
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "No's Of Sold",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "10",
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenSize.width * 0.01,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Current Stock",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "60",
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            ],
                          ),
                        ),
                        if (controller.productValue.value == 2) ...[
                          /// Product Group (Detailed)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Product Group",
                                  style: googleFontStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Burger",
                                  style: googleFontStyle(
                                      color: const Color(0xFF4B4B4B)),
                                ),
                              ],
                            ),
                          ),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Cost",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "250.00",
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Gross",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "50",
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenSize.width * 0.01,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Tax",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "50",
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "<Total>",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ]
                    ] else if (controller.reporttype.value ==
                            'Invoice Report' ||
                        controller.reporttype.value == 'Sales Report' ||
                        controller.reporttype.value == "Sales Order Report" ||
                        controller.reporttype.value == "Product Report") ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Voucher No",
                            style: googleFontStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "<Date & Time>",
                            style:
                                googleFontStyle(color: const Color(0xFF4B4B4B)),
                          ),
                        ],
                      ),
                      if (controller.reporttype.value == 'Invoice Report') ...[
                        ///Invoice report Order No
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order No",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "SO8001",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                      ] else if (controller.reporttype.value ==
                              'Sales Report' ||
                          controller.reporttype.value ==
                              'Sales Order Report') ...[
                        ///Sales report Created Employee
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Created Employee",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Employee 01",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                      ],
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Token No",
                            style: googleFontStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "1001",
                            style:
                                googleFontStyle(color: const Color(0xFF4B4B4B)),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ledger Name",
                            style: googleFontStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Work in Customer",
                            style:
                                googleFontStyle(color: const Color(0xFF4B4B4B)),
                          ),
                        ],
                      ),
                      if (controller.reporttype.value == 'Sales Report' ||
                          controller.reporttype.value ==
                              'Sales Order Report') ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Gross Amt",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Employee 01",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                      ],
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tax",
                            style: googleFontStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "1001",
                            style:
                                googleFontStyle(color: const Color(0xFF4B4B4B)),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Discount",
                            style: googleFontStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "1001",
                            style:
                                googleFontStyle(color: const Color(0xFF4B4B4B)),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "<Total>",
                            style: googleFontStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ] else if (controller.reporttype.value ==
                        'Table Wise Report') ...[
                      if (controller.tablewisereportValue.value == 1) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Table 1",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Customer",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Order",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "10",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ordered Amt",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "10",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sales Invoices",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "10",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Invoice Amt",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "0",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pending",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "0",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pending Amt",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "0",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cancelled",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "0",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cancelled Amt",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "0",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        )
                      ] else ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Table 1",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "<12:00 PM & 4:00 PM>",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Created Employee",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Employee 01",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Updated Employee",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Employee 01",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Token No",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "1001",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order No",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "S01001",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Invoice No",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "COZ8001",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Status",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Invoiced",
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "<Total>",
                              style:
                                  googleFontStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ] else
                      ...[],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
