import 'package:flutter/material.dart';
import 'package:rassasy_new/global/global.dart';

class Rms extends StatefulWidget {
  const Rms({
    super.key,
  });

  @override
  State<Rms> createState() => _RmsState();
}

class _RmsState extends State<Rms> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        //!Section 1
        SizedBox(height: screenSize.height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: screenSize.width * 0.2,
              height: screenSize.height * 0.23,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: const Color(0xFFD9D9D9)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 14.0, top: 6.0, bottom: 6.0),
                          child: Text(
                            "Opening Balance",
                            style: googleFontStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        const Divider(
                          color: Color(0xFFE8E8E8),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 12.0, right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // SvgPicture.asset('./assets/cash.svg'),
                                      // Image.asset(
                                      //   './assets/cash.jpg',
                                      // ),
                                      Text(
                                        "Img1",
                                        style: googleFontStyle(),
                                      ),
                                      Text(" Cash",
                                          style: googleFontStyle(
                                              fontSize: 20,
                                              color: const Color(0xFF4B4B4B))),
                                    ],
                                  ),
                                  Text(
                                    "SR 193843",
                                    style: googleFontStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                              Container(
                                width: 1,
                                height: screenSize.height * 0.1,
                                color: Colors.grey,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // SvgPicture.asset('./assets/cash.svg'),
                                      // Image.asset(
                                      //   './assets/cash.jpg',
                                      // ),
                                      Text(
                                        "Img2",
                                        style: googleFontStyle(),
                                      ),
                                      Text(" Bank",
                                          style: googleFontStyle(
                                              fontSize: 20,
                                              color: const Color(0xFF4B4B4B))),
                                    ],
                                  ),
                                  Text(
                                    "SR 193843",
                                    style: googleFontStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: screenSize.width * 0.2,
              height: screenSize.height * 0.23,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: const Color(0xFFD9D9D9)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 14.0, top: 6.0, bottom: 6.0),
                          child: Text(
                            "Opening Balance",
                            style: googleFontStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        const Divider(
                          color: Color(0xFFE8E8E8),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 12.0, right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // SvgPicture.asset('./assets/cash.svg'),
                                      // Image.asset(
                                      //   './assets/cash.jpg',
                                      // ),
                                      Text(
                                        "Img2",
                                        style: googleFontStyle(),
                                      ),
                                      Text(" Cash",
                                          style: googleFontStyle(
                                              fontSize: 20,
                                              color: const Color(0xFF4B4B4B))),
                                    ],
                                  ),
                                  Text(
                                    "SR 193843",
                                    style: googleFontStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                              Container(
                                width: 1,
                                height: screenSize.height * 0.1,
                                color: Colors.grey,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // SvgPicture.asset('./assets/cash.svg'),
                                      // Image.asset(
                                      //   './assets/cash.jpg',
                                      // ),
                                      Text(
                                        "Img2",
                                        style: googleFontStyle(),
                                      ),
                                      Text(" Bank",
                                          style: googleFontStyle(
                                              fontSize: 20,
                                              color: const Color(0xFF4B4B4B))),
                                    ],
                                  ),
                                  Text(
                                    "SR 193843",
                                    style: googleFontStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: screenSize.width * 0.2,
              height: screenSize.height * 0.23,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: const Color(0xFFD9D9D9)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 14.0, top: 6.0, bottom: 6.0),
                          child: Text(
                            "Opening Balance",
                            style: googleFontStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        const Divider(
                          color: Color(0xFFE8E8E8),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 12.0, right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // SvgPicture.asset('./assets/cash.svg'),
                                      // Image.asset(
                                      //   './assets/cash.jpg',
                                      // ),
                                      Text(
                                        "Img2",
                                        style: googleFontStyle(),
                                      ),
                                      Text(" Cash",
                                          style: googleFontStyle(
                                              fontSize: 20,
                                              color: const Color(0xFF4B4B4B))),
                                    ],
                                  ),
                                  Text(
                                    "SR 193843",
                                    style: googleFontStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                              Container(
                                width: 1,
                                height: screenSize.height * 0.1,
                                color: Colors.grey,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // SvgPicture.asset('./assets/cash.svg'),
                                      // Image.asset(
                                      //   './assets/cash.jpg',
                                      // ),
                                      Text(
                                        "Img2",
                                        style: googleFontStyle(),
                                      ),
                                      Text(" Bank",
                                          style: googleFontStyle(
                                              fontSize: 20,
                                              color: const Color(0xFF4B4B4B))),
                                    ],
                                  ),
                                  Text(
                                    "SR 193843",
                                    style: googleFontStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: screenSize.height * 0.01),
        //!Section 2
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: screenSize.width * 0.15,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                      child: Row(
                        children: [
                          Container(
                            color: const Color(0xFFE28903),
                            height: screenSize.height * 0.03,
                            width: screenSize.width * 0.005,
                          ),
                          SizedBox(width: screenSize.width * 0.01),
                          Text(
                            "Sales Overview",
                            style: googleFontStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color(0xFFE8E8E8),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("PARTICILARS"),
                          Text("Total"),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color(0xFFE8E8E8),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Effective Sales"),
                          Text("0.00"),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color(0xFFE8E8E8),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("No of sales Invoice"),
                          Text("0.00"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.01,
              ),
              Container(
                width: screenSize.width * 0.18,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                      child: Row(
                        children: [
                          Container(
                            color: const Color(0xFFE28903),
                            height: screenSize.height * 0.03,
                            width: screenSize.width * 0.005,
                          ),
                          SizedBox(width: screenSize.width * 0.01),
                          Text(
                            "Payment Overview",
                            style: googleFontStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color(0xFFE8E8E8),
                    ),
                    const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Cash"),
                              Text("0.00"),
                            ],
                          ),
                        ),
                        Divider(
                          color: Color(0xFFE8E8E8),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Bank"),
                              Text("0.00"),
                            ],
                          ),
                        ),
                        Divider(
                          color: Color(0xFFE8E8E8),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Credit"),
                              Text("0.00"),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.01,
              ),
              Expanded(
                child: Container(
                  // width: screenSize.width * 0.2,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                        child: Row(
                          children: [
                            Container(
                              color: const Color(0xFFE28903),
                              height: screenSize.height * 0.03,
                              width: screenSize.width * 0.005,
                            ),
                            SizedBox(width: screenSize.width * 0.01),
                            Text(
                              "Sales Invoice",
                              style: googleFontStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFE8E8E8),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Gross Amount"),
                            Text("Discount"),
                            Text("Total Tax"),
                            Text("Total"),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFE8E8E8),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("SR 0.00"),
                            Text("SR 0.00"),
                            Text("SR 0.00"),
                            Text("SR 0.00"),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFE8E8E8),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tax Details:"),
                            Text("General(VAT)"),
                            Text("Exicise SR 0.00"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        //!Section 3  (Sales order summary)

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: const Color(0xFFD9D9D9)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        color: const Color(0xFFE28903),
                        height: screenSize.height * 0.03,
                        width: screenSize.width * 0.005,
                      ),
                      SizedBox(width: screenSize.width * 0.01),
                      Text(
                        "Sales Invoice",
                        style: googleFontStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Color(0xFFE8E8E8),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          color: const Color(0xFFFFFFFF),
                          width: screenSize.width / 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Total Orders",
                                      style: googleFontStyle(
                                          color: const Color(0xFF4B4B4B),
                                          fontSize: 14),
                                    ),
                                    Text(
                                      "10",
                                      style: googleFontStyle(
                                          color: const Color(0xFF3E423F),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Amount",
                                      style: googleFontStyle(
                                          color: const Color(0xFF4B4B4B),
                                          fontSize: 14),
                                    ),
                                    Text(
                                      "2000",
                                      style: googleFontStyle(
                                          color: const Color(0xFF3D924F),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: screenSize.width / 4,
                          decoration: const BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              border: Border(
                                  left: BorderSide(color: Color(0xFFD9D9D9)),
                                  right: BorderSide(color: Color(0xFFD9D9D9)))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Cancelled Orders",
                                      style: googleFontStyle(
                                          color: const Color(0xFF4B4B4B),
                                          fontSize: 14),
                                    ),
                                    Text(
                                      "10",
                                      style: googleFontStyle(
                                          color: const Color(0xFFB84040),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Amount",
                                      style: googleFontStyle(
                                          color: const Color(0xFF4B4B4B),
                                          fontSize: 14),
                                    ),
                                    Text(
                                      "2000",
                                      style: googleFontStyle(
                                          color: const Color(0xFFB84040),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: const Color(0xFFFFFFFF),
                          width: screenSize.width / 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Pending Orders",
                                      style: googleFontStyle(
                                          color: const Color(0xFF4B4B4B),
                                          fontSize: 14),
                                    ),
                                    Text(
                                      "05",
                                      style: googleFontStyle(
                                          color: const Color(0xFFB44800),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Amount",
                                      style: googleFontStyle(
                                          color: const Color(0xFF4B4B4B),
                                          fontSize: 14),
                                    ),
                                    Text(
                                      "2000",
                                      style: googleFontStyle(
                                          color: const Color(0xFFB44800),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        //!Section 4 (Service Type Report)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: const Color(0xFFD9D9D9)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        color: const Color(0xFFE28903),
                        height: screenSize.height * 0.03,
                        width: screenSize.width * 0.005,
                      ),
                      SizedBox(width: screenSize.width * 0.01),
                      Text(
                        "Service Type Report",
                        style: googleFontStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Color(0xFFE8E8E8),
                ),
                DataTable(
                  columns: [
                    DataColumn(
                        label: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Service',
                              style: googleFontStyle(
                                  color: const Color(0xFF4B4B4B),
                                  fontSize: 14)),
                        ],
                      ),
                    )),
                    DataColumn(
                        label: SizedBox(
                      width: screenSize.width * 0.1,
                      // color: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Orders',
                            style: googleFontStyle(
                              color: const Color(0xFF4B4B4B),
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Count',
                                  style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B),
                                    fontSize: 12,
                                  )),
                              Text('Amount',
                                  style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B),
                                    fontSize: 12,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    )),
                    DataColumn(
                        label: SizedBox(
                      width: screenSize.width * 0.1,
                      // color: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Orders',
                            style: googleFontStyle(
                              color: const Color(0xFF4B4B4B),
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Count',
                                  style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B),
                                    fontSize: 12,
                                  )),
                              Text('Amount',
                                  style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B),
                                    fontSize: 12,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    )),
                    DataColumn(
                        label: SizedBox(
                      width: screenSize.width * 0.1,
                      // color: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Orders',
                            style: googleFontStyle(
                              color: const Color(0xFF4B4B4B),
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Count',
                                  style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B),
                                    fontSize: 12,
                                  )),
                              Text('Amount',
                                  style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B),
                                    fontSize: 12,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    )),
                    DataColumn(
                        label: SizedBox(
                      width: screenSize.width * 0.1,
                      // color: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Orders',
                            style: googleFontStyle(
                              color: const Color(0xFF4B4B4B),
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Count',
                                  style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B),
                                    fontSize: 12,
                                  )),
                              Text('Amount',
                                  style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B),
                                    fontSize: 12,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    )),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text(
                          'Dining',
                          style: googleFontStyle(fontWeight: FontWeight.bold),
                        )),
                        const DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('10'),
                                Text('300'),
                              ],
                            ),
                          ],
                        )),
                        const DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('10'),
                                Text('300'),
                              ],
                            ),
                          ],
                        )),
                        const DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('10'),
                                Text('300'),
                              ],
                            ),
                          ],
                        )),
                        const DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('10'),
                                Text('300'),
                              ],
                            ),
                          ],
                        )),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(
                          'Take Away',
                          style: googleFontStyle(fontWeight: FontWeight.bold),
                        )),
                        const DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('10'),
                                Text('300'),
                              ],
                            ),
                          ],
                        )),
                        const DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('10'),
                                Text('300'),
                              ],
                            ),
                          ],
                        )),
                        const DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('10'),
                                Text('300'),
                              ],
                            ),
                          ],
                        )),
                        const DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('10'),
                                Text('300'),
                              ],
                            ),
                          ],
                        )),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(
                          'Online',
                          style: googleFontStyle(fontWeight: FontWeight.bold),
                        )),
                        const DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('10'),
                                Text('300'),
                              ],
                            ),
                          ],
                        )),
                        const DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('10'),
                                Text('300'),
                              ],
                            ),
                          ],
                        )),
                        const DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('10'),
                                Text('300'),
                              ],
                            ),
                          ],
                        )),
                        const DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('10'),
                                Text('300'),
                              ],
                            ),
                          ],
                        )),
                      ],
                    ),
                    DataRow(
                      color: WidgetStateProperty.all(const Color(0xFFFAFAFA)),
                      cells: [
                        DataCell(Text(
                          'Total',
                          style: googleFontStyle(fontWeight: FontWeight.bold),
                        )),
                        const DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('10'),
                                Text('300'),
                              ],
                            ),
                          ],
                        )),
                        const DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('10'),
                                Text('300'),
                              ],
                            ),
                          ],
                        )),
                        const DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('10'),
                                Text('300'),
                              ],
                            ),
                          ],
                        )),
                        const DataCell(Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('10'),
                                Text('300'),
                              ],
                            ),
                          ],
                        )),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),

        //!Section5 (Revenue By Service)

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: const Color(0xFFD9D9D9)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        color: const Color(0xFFE28903),
                        height: screenSize.height * 0.03,
                        width: screenSize.width * 0.005,
                      ),
                      SizedBox(width: screenSize.width * 0.01),
                      Text(
                        "Revenue By Service",
                        style: googleFontStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Color(0xFFE8E8E8),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Image.asset('assets/jpeg/diningreport.jpg'),
                              Text(
                                "SR 48785",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                "10",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: screenSize.height * 0.1,
                            color: Colors.grey,
                          ),
                          Column(
                            children: [
                              Image.asset('assets/jpeg/diningreport.jpg'),
                              Text(
                                "SR 48785",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                "10",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: screenSize.height * 0.1,
                            color: Colors.grey,
                          ),
                          Column(
                            children: [
                              Image.asset('assets/jpeg/diningreport.jpg'),
                              Text(
                                "SR 48785",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                "10",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        //!Section6 (Employee Based Report)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: const Color(0xFFD9D9D9)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        color: const Color(0xFFE28903),
                        height: screenSize.height * 0.03,
                        width: screenSize.width * 0.005,
                      ),
                      SizedBox(width: screenSize.width * 0.01),
                      Text(
                        "Employee Based Report",
                        style: googleFontStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Color(0xFFE8E8E8),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      child: DataTable(
                        columnSpacing: 16.0,
                        columns: [
                          DataColumn(
                              label: Text('Name',
                                  style: googleFontStyle(
                                      color: const Color(0xFF4B4B4B)))),
                          DataColumn(
                              label: Text('Total Orders',
                                  style: googleFontStyle(
                                      color: const Color(0xFF4B4B4B)))),
                          DataColumn(
                              label: Text('Amount',
                                  style: googleFontStyle(
                                      color: const Color(0xFF4B4B4B)))),
                          DataColumn(
                              label: Text('TotalSales',
                                  style: googleFontStyle(
                                      color: const Color(0xFF4B4B4B)))),
                          DataColumn(
                              label: Text('Amount',
                                  style: googleFontStyle(
                                      color: const Color(0xFF4B4B4B)))),
                          DataColumn(
                              label: Text('Cancel Orders',
                                  style: googleFontStyle(
                                      color: const Color(0xFF4B4B4B)))),
                          DataColumn(
                              label: Text('Pending Orders',
                                  style: googleFontStyle(
                                      color: const Color(0xFF4B4B4B)))),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(Text('Employee 1',
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF4B4B4B)))),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Employee 2',
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF4B4B4B)))),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                          ]),
                          DataRow(
                            color: WidgetStateProperty.all(
                                const Color(0xFFFAFAFA)),
                            cells: [
                              DataCell(Text('Total',
                                  style: googleFontStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4B4B4B)))),
                              DataCell(Center(
                                child: Text(
                                  '10',
                                  style: googleFontStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4B4B4B)),
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  '10',
                                  style: googleFontStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4B4B4B)),
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  '10',
                                  style: googleFontStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4B4B4B)),
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  '10',
                                  style: googleFontStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4B4B4B)),
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  '10',
                                  style: googleFontStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4B4B4B)),
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  '10',
                                  style: googleFontStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4B4B4B)),
                                ),
                              )),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        //!Section7 (Delivery Based Report)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: const Color(0xFFD9D9D9)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            color: const Color(0xFFE28903),
                            height: screenSize.height * 0.03,
                            width: screenSize.width * 0.005,
                          ),
                          SizedBox(width: screenSize.width * 0.01),
                          Text(
                            "Delivery Based Report",
                            style: googleFontStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: const Color(0xFFD9D9D9)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            items: const [
                              DropdownMenuItem(
                                value: 'Option 1',
                                child: Text('Option 1'),
                              ),
                              DropdownMenuItem(
                                value: 'Option 2',
                                child: Text('Option 2'),
                              ),
                              DropdownMenuItem(
                                value: 'Option 3',
                                child: Text('Option 3'),
                              ),
                            ],
                            onChanged: (String? newValue) {},
                            hint: const Text('All'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(
                  color: Color(0xFFE8E8E8),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      child: DataTable(
                        columnSpacing: 16.0,
                        columns: [
                          DataColumn(
                              label: Text('Name',
                                  style: googleFontStyle(
                                      color: const Color(0xFF4B4B4B)))),
                          DataColumn(
                              label: Text('Total Orders',
                                  style: googleFontStyle(
                                      color: const Color(0xFF4B4B4B)))),
                          DataColumn(
                              label: Text('Amount',
                                  style: googleFontStyle(
                                      color: const Color(0xFF4B4B4B)))),
                          DataColumn(
                              label: Text('TotalSales',
                                  style: googleFontStyle(
                                      color: const Color(0xFF4B4B4B)))),
                          DataColumn(
                              label: Text('Amount',
                                  style: googleFontStyle(
                                      color: const Color(0xFF4B4B4B)))),
                          DataColumn(
                              label: Text('Cancel Orders',
                                  style: googleFontStyle(
                                      color: const Color(0xFF4B4B4B)))),
                          DataColumn(
                              label: Text('Pending Orders',
                                  style: googleFontStyle(
                                      color: const Color(0xFF4B4B4B)))),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(Text('Delivery Boy 1',
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF4B4B4B)))),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Delivery Boy 2',
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF4B4B4B)))),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                            DataCell(Center(
                              child: Text(
                                '10',
                                style: googleFontStyle(
                                    color: const Color(0xFF4B4B4B)),
                              ),
                            )),
                          ]),
                          DataRow(
                            color: WidgetStateProperty.all(
                                const Color(0xFFFAFAFA)),
                            cells: [
                              DataCell(Text('Total',
                                  style: googleFontStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4B4B4B)))),
                              DataCell(Center(
                                child: Text(
                                  '10',
                                  style: googleFontStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4B4B4B)),
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  '10',
                                  style: googleFontStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4B4B4B)),
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  '10',
                                  style: googleFontStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4B4B4B)),
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  '10',
                                  style: googleFontStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4B4B4B)),
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  '10',
                                  style: googleFontStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4B4B4B)),
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  '10',
                                  style: googleFontStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4B4B4B)),
                                ),
                              )),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        //!Section8 (Wait Time Report and Peakhour)

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //!Wait Time Report
              Container(
                width: screenSize.width / 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                      child: Row(
                        children: [
                          Container(
                            color: const Color(0xFFE28903),
                            height: screenSize.height * 0.03,
                            width: screenSize.width * 0.005,
                          ),
                          SizedBox(width: screenSize.width * 0.01),
                          Text(
                            "Wait Time Report",
                            style: googleFontStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color(0xFFE8E8E8),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Services",
                            style: googleFontStyle(),
                          ),
                          Text(
                            "Average Wait Time",
                            style: googleFontStyle(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color(0xFFE8E8E8),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Dining",
                            style: googleFontStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "20",
                            style: googleFontStyle(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color(0xFFE8E8E8),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Takeaway",
                            style: googleFontStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "13",
                            style: googleFontStyle(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color(0xFFE8E8E8),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Online",
                            style: googleFontStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "18",
                            style: googleFontStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenSize.width * 0.02),
              //! Peak Hour Report
              Expanded(
                child: Container(
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                        child: Row(
                          children: [
                            Container(
                              color: const Color(0xFFE28903),
                              height: screenSize.height * 0.03,
                              width: screenSize.width * 0.005,
                            ),
                            SizedBox(width: screenSize.width * 0.01),
                            Text(
                              "Peak Hours Report",
                              style: googleFontStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFE8E8E8),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Time Period",
                              style: googleFontStyle(),
                            ),
                            Text(
                              "Orders",
                              style: googleFontStyle(),
                            ),
                            Text(
                              "Total Sales",
                              style: googleFontStyle(),
                            ),
                            Text(
                              "Total Amount",
                              style: googleFontStyle(),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFE8E8E8),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                            minHeight: 0, maxHeight: 10000),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "17:00-18-00",
                                        style: googleFontStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "20",
                                        style: googleFontStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "20",
                                        style: googleFontStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "20",
                                        style: googleFontStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Color(0xFFE8E8E8),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        //!Section9 (Discount Report and Customer Testimonials)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //!Discount Report
              Container(
                width: screenSize.width / 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: const Color(0xFFD9D9D9)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                      child: Row(
                        children: [
                          Container(
                            color: const Color(0xFFE28903),
                            height: screenSize.height * 0.03,
                            width: screenSize.width * 0.005,
                          ),
                          SizedBox(width: screenSize.width * 0.01),
                          Text(
                            "Discount Report",
                            style: googleFontStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color(0xFFE8E8E8),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Coupon Code",
                            style: googleFontStyle(),
                          ),
                          Text(
                            "No Of Uses",
                            style: googleFontStyle(),
                          ),
                          Text(
                            "Total Discount",
                            style: googleFontStyle(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color(0xFFE8E8E8),
                    ),
                    ConstrainedBox(
                        constraints: const BoxConstraints(
                            minHeight: 0, maxHeight: 10000),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Summer 10",
                                          style: googleFontStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "15",
                                          style: googleFontStyle(),
                                        ),
                                        Text(
                                          "SR 150.0",
                                          style: googleFontStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    color: Color(0xFFE8E8E8),
                                  ),
                                ],
                              );
                            }))
                  ],
                ),
              ),
              SizedBox(width: screenSize.width * 0.02),
              //! Customer Testimonials
              Expanded(
                child: Container(
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                        child: Row(
                          children: [
                            Container(
                              color: const Color(0xFFE28903),
                              height: screenSize.height * 0.03,
                              width: screenSize.width * 0.005,
                            ),
                            SizedBox(width: screenSize.width * 0.01),
                            Text(
                              "Customer Testimonials",
                              style: googleFontStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFE8E8E8),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Older Number",
                              style: googleFontStyle(),
                            ),
                            Text(
                              "Invoice Number",
                              style: googleFontStyle(),
                            ),
                            Text(
                              "Feedback Rating",
                              style: googleFontStyle(),
                            ),
                            Text(
                              "Comments",
                              style: googleFontStyle(),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFE8E8E8),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                            minHeight: 0, maxHeight: 10000),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "ORD001",
                                        style: googleFontStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "COZ8004",
                                        style: googleFontStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.star,
                                              color: Color(0xFFFAC817)),
                                          Text(
                                            "3",
                                            style: googleFontStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Great Food!",
                                        style: googleFontStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Color(0xFFE8E8E8),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        //!Section10 (Inventory Report and Online Report)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //!Inventory Report
              Expanded(
                child: Container(
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  color: const Color(0xFFE28903),
                                  height: screenSize.height * 0.03,
                                  width: screenSize.width * 0.005,
                                ),
                                SizedBox(width: screenSize.width * 0.01),
                                Text(
                                  "Inventory Report",
                                  style: googleFontStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border:
                                    Border.all(color: const Color(0xFFD9D9D9)),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Option 1',
                                      child: Text('Option 1'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Option 2',
                                      child: Text('Option 2'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Option 3',
                                      child: Text('Option 3'),
                                    ),
                                  ],
                                  onChanged: (String? newValue) {},
                                  hint: const Text('Top 5'),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFE8E8E8),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Product Name",
                              style: googleFontStyle(),
                            ),
                            Text(
                              "Quantity Used",
                              style: googleFontStyle(),
                            ),
                            Text(
                              "Stock",
                              style: googleFontStyle(),
                            ),
                            Text(
                              "Cost",
                              style: googleFontStyle(),
                            ),
                            Text(
                              "Total Cost",
                              style: googleFontStyle(),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFE8E8E8),
                      ),
                      ConstrainedBox(
                          constraints: const BoxConstraints(
                              minHeight: 0, maxHeight: 10000),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Pizza",
                                            style: googleFontStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "15",
                                            style: googleFontStyle(),
                                          ),
                                          Text(
                                            "15",
                                            style: googleFontStyle(),
                                          ),
                                          Text(
                                            "15",
                                            style: googleFontStyle(),
                                          ),
                                          Text(
                                            "150",
                                            style: googleFontStyle(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      color: Color(0xFFE8E8E8),
                                    ),
                                  ],
                                );
                              })),
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "12",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "15",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "15",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "150",
                                style: googleFontStyle(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: screenSize.width * 0.02),
              //! Online Report
              Expanded(
                child: Container(
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: const Color(0xFFD9D9D9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  color: const Color(0xFFE28903),
                                  height: screenSize.height * 0.03,
                                  width: screenSize.width * 0.005,
                                ),
                                SizedBox(width: screenSize.width * 0.01),
                                Text(
                                  "Online Report",
                                  style: googleFontStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border:
                                    Border.all(color: const Color(0xFFD9D9D9)),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Option 1',
                                      child: Text('Option 1'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Option 2',
                                      child: Text('Option 2'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Option 3',
                                      child: Text('Option 3'),
                                    ),
                                  ],
                                  onChanged: (String? newValue) {},
                                  hint: const Text('Select Delivery Boy'),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFE8E8E8),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Platform",
                              style: googleFontStyle(),
                            ),
                            Text(
                              "Total Invoice",
                              style: googleFontStyle(),
                            ),
                            Text(
                              "Total Amount",
                              style: googleFontStyle(),
                            ),
                            Text(
                              "Cancel",
                              style: googleFontStyle(),
                            ),
                            Text(
                              "Pending",
                              style: googleFontStyle(),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color(0xFFE8E8E8),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                            minHeight: 0, maxHeight: 10000),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Jahez",
                                        style: googleFontStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "12",
                                        style: googleFontStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "15",
                                        style: googleFontStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "15",
                                        style: googleFontStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Great Food!",
                                        style: googleFontStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Color(0xFFE8E8E8),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "12",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "15",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "15",
                                style: googleFontStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "150",
                                style: googleFontStyle(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
