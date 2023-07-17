import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_apk/final_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import 'ApiService.dart';
import 'Post.dart';

class signature1 extends StatefulWidget {
  final GoogleSignInAccount user;
  final Post data;
  const signature1({Key? key, required this.data, required this.user})
      : super(key: key);

  @override
  State<signature1> createState() => _signature1State(user: user);
}

class _signature1State extends State<signature1> {
  String? selectedPaymentMode = 'Cash';
  List<String> paymentModes = ['Cash', 'Check', 'Card', 'Online payment'];
  final TextEditingController _amountController = TextEditingController();
  late GoogleSignInAccount user;
  late ApiService apiService;
  int _value = 1;
  GlobalKey<SfSignaturePadState> _signaturePadKey =
      GlobalKey<SfSignaturePadState>();
  ByteData? _byteData;
  _signature1State({required this.user}) {
    apiService = ApiService();
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }

  void _showToastInfo(String info) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(info),
      ),
    );
  }

  void _handleSaveButtonPressed() async {
    // Check if radio button is selected
    if (_value == 0) {
      _showToastInfo('Please Select an option (Full/Partial).');
      return;
    }

    // Check if amount is entered
    if (_value == 2 && _amountController.text.isEmpty) {
      _showToastInfo('Please Enter The Amount');
      return;
    }

    if (_value == 2 && int.tryParse(_amountController.text)! < 1) {
      _showToastInfo('The Minimum Amount is Rs1');
      return;
    }

    RenderSignaturePad? boundary = _signaturePadKey.currentContext!
        .findRenderObject() as RenderSignaturePad;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      _byteData = byteData; // Store the byteData in the class-level variable
      final time = DateTime.now().millisecond;
      final name = "signature_$time.png";
      final result = await ImageGallerySaver.saveImage(
        byteData.buffer.asUint8List(),
        quality: 100,
        name: name,
      );
      if (kDebugMode) {
        print(result);
      }

      final isSuccess = result['isSuccess'];
      _signaturePadKey.currentState!.clear();

      if (isSuccess) {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FinalPageWidget(
                data: widget.data,
                amountController: _amountController,
                byteData: _byteData,
                value: _value,
                user: user,
              ),
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).textScaleFactor;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
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
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          child: Image.asset(
            'images/ddspllogo.png',
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.width * 0.1,
          ),
        ),
        title: Text(
          'Payment',
          style: TextStyle(fontSize: width * 0.08),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width,
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.04),
                      ),
                      child: Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: height * 0.03,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.02,
                        vertical: MediaQuery.of(context).size.height * 0.00009,
                      ),
                      child: DropdownButton<String>(
                        value: selectedPaymentMode,
                        onChanged: (newValue) {
                          setState(() {
                            selectedPaymentMode = newValue;
                          });
                        },
                        items: paymentModes.map<DropdownMenuItem<String>>(
                          (String mode) {
                            return DropdownMenuItem<String>(
                              value: mode,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.withOpacity(0.2),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.width * 0.025,
                                ),
                                child: Text(
                                  mode,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                        underline: Container(
                          height: 0,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _value == 1
                                  ? Colors.orange[800]
                                  : Colors.orange[300],
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.3,
                                  MediaQuery.of(context).size.width *
                                      0.12), // Adjust the size based on your requirements
                            ),
                            onPressed: () {
                              setState(() {
                                _value = 1;
                              });
                            },
                            child: Text(
                              'Full',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width *
                                    0.04, // Adjust the font size based on your requirements
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _value == 2
                                  ? Colors.orange[800]
                                  : Colors.orange[300],
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.3,
                                  MediaQuery.of(context).size.width *
                                      0.12), // Adjust the size based on your requirements
                            ),
                            onPressed: () {
                              setState(() {
                                _value = 2;
                              });
                            },
                            child: Text(
                              'Partial',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width *
                                    0.04, // Adjust the font size based on your requirements
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.03),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.04),
                      ),
                      child: Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: height * 0.03,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                    if (_value == 2) ...[
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Padding(
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.45,
                          left: MediaQuery.of(context).size.width * 0.03,
                        ),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(4),
                            child: TextFormField(
                              controller: _amountController,
                              style: TextStyle(fontSize: height * 0.02),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: InputBorder.none,
                                hintText:
                                    'Enter the amount', // Placeholder text
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                    if (newValue.text.isEmpty) {
                                      // Allow clearing or deleting all digits
                                      return newValue;
                                    }

                                    final int? value =
                                        int.tryParse(newValue.text);
                                    if (value != null &&
                                        value < widget.data.amount) {
                                      return newValue;
                                    }
                                    return oldValue;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (_value == 1) ...[
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.1),
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFF9B44),
                                Color(0xFFFC6075),
                              ],
                              stops: [0.0, 1.0],
                            ).createShader(bounds);
                          },
                          child: Text(
                            "\u{20B9} ${widget.data.amount}",
                            style: TextStyle(
                              fontSize: height * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Row(
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy').format(DateTime.now()),
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            DateFormat('hh:mm a').format(DateTime.now()),
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                // Adding a thin horizontal line
                color: Colors.black,
                thickness: MediaQuery.of(context).size.width * 0.0005,
              ),
              Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width *
                          0.04), // Responsive rounded corners
                ),
                child: Text(
                  'Client Signature',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height *
                        0.03, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                height: MediaQuery.of(context).size.height * 0.24,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: SfSignaturePad(
                    key: _signaturePadKey,
                    maximumStrokeWidth: 6,
                    minimumStrokeWidth: 5,
                    backgroundColor: Colors.grey[100],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _signaturePadKey.currentState!.clear();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * 0.015,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.08),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        "Clear",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(dialogContext)
                                          .size
                                          .width *
                                      0.8, // Adjust the width based on your requirements
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(dialogContext)
                                                  .size
                                                  .width *
                                              0.05),
                                      child: Text(
                                        'Confirmation',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(dialogContext)
                                                  .size
                                                  .width *
                                              0.05, // Adjust the font size based on your requirements
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              MediaQuery.of(dialogContext)
                                                      .size
                                                      .width *
                                                  0.05),
                                      child: Text(
                                        'Are you sure you want to proceed?',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(dialogContext)
                                                  .size
                                                  .width *
                                              0.04, // Adjust the font size based on your requirements
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height: MediaQuery.of(dialogContext)
                                                .size
                                                .width *
                                            0.05),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            // Close the dialog
                                            Navigator.of(dialogContext).pop();
                                          },
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(
                                                          dialogContext)
                                                      .size
                                                      .width *
                                                  0.045, // Adjust the font size based on your requirements
                                              color: Colors.red[400],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(dialogContext)
                                                    .size
                                                    .width *
                                                0.05),
                                        TextButton(
                                          onPressed: () {
                                            // Close the dialog and set the confirmation flag
                                            Navigator.of(dialogContext).pop();
                                            _handleSaveButtonPressed(); // Navigate to the next page when confirmed
                                          },
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(
                                                          dialogContext)
                                                      .size
                                                      .width *
                                                  0.045, // Adjust the font size based on your requirements
                                              color: Colors.orange[600],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[600],
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * 0.015,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
