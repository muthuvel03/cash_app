import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'ApiService.dart';
import 'Post.dart';
import 'lottie.dart';

class FinalPageWidget extends StatefulWidget {
  final Post data;
  final TextEditingController amountController;
  final ByteData? byteData;
  final int value;
  final GoogleSignInAccount user;

  const FinalPageWidget({
    Key? key,
    required this.data,
    required this.amountController,
    this.byteData,
    required this.value,
    required this.user,
  }) : super(key: key);

  @override
  State<FinalPageWidget> createState() => _FinalPageState(user: user);
}

class _FinalPageState extends State<FinalPageWidget> {
  List<Post> postList = [];
  final DateTime dateTimeNow = DateTime.now();
  late double totalAmount;
  late double partialAmount;
  late double dueAmount;
  late GoogleSignInAccount user;
  late ApiService apiService;

  _FinalPageState({required this.user}) {
    apiService = ApiService();
  }

  @override
  void initState() {
    super.initState();
    totalAmount = widget.data.amount;
    partialAmount = 0.0;
    dueAmount = 0.0;
    if (widget.value == 2) {
      partialAmount = double.parse(widget.amountController.text);
      dueAmount = totalAmount - partialAmount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFFF9B44),
                  Color(0xFFFC6075),
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'images/ddspllogo.png',
              width: 32,
              height: 32,
            ),
          ),
          title: Text(
            'Overview',
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.08),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                  0.04), // Responsive padding
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width *
                        0.04), // Responsive rounded corners
                color: Colors.orange[500],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invoice',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width *
                          0.08, // Responsive font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'Clinic Name: ',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width *
                              0.05, // Responsive font size
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: '${widget.data.clinicName}',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'Client Name: ',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: '${widget.data.clientName}',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'Address       : ',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width *
                              0.05, // Responsive font size
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: '${widget.data.address}',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            Divider(
              color: Colors.black,
              thickness: MediaQuery.of(context).size.width * 0.0005,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            Expanded(
              child: Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              'Payment Type: ',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: widget.value == 2 ? 'Partial' : 'Full',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (widget.value == 1)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                'Amount           :',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: ' \u{20B9} ${totalAmount}',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (widget.value == 2)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Paid Amount  :',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        text: ' \u{20B9} ${partialAmount}',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Due Amount   :',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        text: ' \u{20B9} ${dueAmount}',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              'Date                 :',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text:
                                      ' ${DateFormat('dd-MM-yyyy - hh:mm a').format(DateTime.now())}',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.03),
                    Divider(
                      // Adding a thin horizontal line
                      color: Colors.black,
                      thickness: MediaQuery.of(context).size.width * 0.0005,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.03),
                    Container(
                      // Responsive padding
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width *
                                0.04), // Responsive rounded corners
                      ),
                      child: Text(
                        'Client Signature',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width *
                              0.05, // Responsive font size
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.03),
                    Container(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.03),
                      decoration: BoxDecoration(
                        color: Colors.grey[100], // Light gray color
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.04,
                        ),
                      ),
                      child: Image.memory(
                        widget.byteData!.buffer.asUint8List(),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.3,
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          final amount = widget.amountController.text.isNotEmpty
                              ? int.parse(widget.amountController.text)
                              : widget.data.amount;
                          final client_id = widget.data.clientId.toString();
                          final invoice_id = widget.data.invoiceId.toString();
                          final in_balance = widget.data.inBalance.toString();
                          final Map<String, dynamic> requestBody = {
                            'amount': amount.toString(),
                            'client_id': client_id,
                            'invoice_id': invoice_id,
                            'in_balance': in_balance,
                            'payment_method_id': '1',
                            'invoice_discount': '0'
                          };

                          final response = await http.post(
                            Uri.parse(
                                'https://dakshindspl.com/devddspl/public/api/pay_payment'),
                            body: requestBody,
                          );

                          if (response.statusCode == 200) {
                            print('Cash detail request successful');
                            print(response.body);
                          } else {
                            print('Error during cash detail request');
                            print('Status code: ${response.statusCode}');
                            print('Response body: ${response.body}');
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Animation1(
                                data: widget.data,
                                user: user,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFF9B44),
                                Color(0xFFFC6075),
                              ],
                              stops: [0.0, 1.0],
                            ),
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width,
                              minHeight:
                                  MediaQuery.of(context).size.height * 0.07,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Pay',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
