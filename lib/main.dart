import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fresh_apk/google_signin_api.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'Post.dart';
import 'DataApi.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: LoginPage(),
));

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Future signIn() async {
      final user = await GoogleSignInApi.login();

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sign in failed")));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Homepage(user:user)));
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AutoSizeText(
          'Dental Receipts',
          style: TextStyle(
              fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Column(
                children: [
                  const AutoSizeText(
                    "Login",
                    style: TextStyle(
                      fontSize: 43,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AutoSizeText(
                    "Welcome back ! Login with your email",
                    style: TextStyle(
                      fontSize: 19.7,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
              const SizedBox(
                height: 225,
              ),
              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: signIn,
                child: const Image(
                  image: AssetImage('images/google.png'),
                  width: 200,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {},
                child: const AutoSizeText(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  final GoogleSignInAccount user;
  const Homepage({Key? key, required this.user}) : super(key: key);

  static const url =
      "https://jsonplaceholder.typicode.com/users";

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List<DataApi> postList = [];
  static const url =
      "https://dakshindspl.com/dbills/public/api/cash-detail-req";

  Future<List<DataApi>> getPostApi() async {
    final response = await http.get(
        Uri.parse("https://jsonplaceholder.typicode.com/users"));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map i in data) {
        postList.add(DataApi.fromJson(i as Map<String, dynamic>));
      }
      return postList;
    } else {
      return postList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const AutoSizeText(
          'Dental Payment',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        actions: [
          TextButton(
            child: const Text(
              "LOGOUT",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              await GoogleSignInApi.logout();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          )
        ],
      ),
      body : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Hi ' + widget.user.displayName!,
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black.withOpacity(.7), width: 3), // Add border line
                          ),
                          child: Center(
                            child: Text(
                              'Collection Request: ${postList.length}', // Update to display the length of the data
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 1,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.black12,
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                    child: const AutoSizeText(
                      "Customer List",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight - 430, // Subtract height of top app bar, status bar, bottom navigation bar, and additional padding
                    child: FutureBuilder(
                      future: getPostApi(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          );
                        } else {
                          if (snapshot.data == null || snapshot.data!.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(30.0),
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 600), // set maximum width
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: AnimationLimiter(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: AnimationConfiguration.toStaggeredList(
                                              duration: const Duration(milliseconds: 200),
                                              childAnimationBuilder: (widget) => SlideAnimation(
                                                horizontalOffset: 150.0,
                                                child: FadeInAnimation(
                                                  child: widget,
                                                ),
                                              ),
                                              children: [
                                                Icon(
                                                  Icons.warning,
                                                  color: Colors.yellow[800],
                                                  size: 48,
                                                ),
                                                SizedBox(height: 16.0),
                                                const Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    'Today cash request yet not created!',
                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(height: 8.0),
                                                const Text(
                                                  'Please check back later for updates.',
                                                  style: TextStyle(fontSize: 16),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: postList.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ID: ${postList[index].id}',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Name: ${postList[index].name}',
                                          style: TextStyle(fontSize: 16),
                                        ),

                                        Text(
                                          'Address: ${postList[index].address}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {

                                                },
                                                child: Row(
                                                  children: const [
                                                    Text(
                                                      'View Details',
                                                      style: TextStyle(fontSize: 16),
                                                    ),
                                                    Icon(Icons.arrow_forward_ios), // Right arrow icon
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Saving',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.repeat),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
    // ListView.builder(
    //   itemCount: postList.length,
    //   itemBuilder: (context, index) {
    //     return Card(
    //       margin: const EdgeInsets.symmetric(
    //         horizontal: 15.0,
    //         vertical: 10.0,
    //       ),
    //       child: Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Row(
    //           children: [
    //             Image.network(postList[index].imageUrl.toString()),
    //             Column(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(postList[index].id.toString()),
    //                 Text(postList[index].username.toString()),
    //                 Text(postList[index].address.toString()),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // ),
    // );
  }
}


class Firstpage extends StatelessWidget {
  Firstpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const AutoSizeText(
          'Dental Payment',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.savings),
              label: 'Saving',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.repeat),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ]),
      body: Center(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.27,
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: ListTile(
                    title: const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: AutoSizeText(
                        'Senthil Poly Clinic',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Container(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "21,3rd Street",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("TVS Nagar",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 20, color: Colors.black)),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Madurai",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 20, color: Colors.black)),
                        ],
                      ),
                    )),
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.275,
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: ListTile(
                    title: const Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: AutoSizeText('Invoice Details',
                          style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    ),
                    subtitle: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              const Text(
                                '''Due Date
30-Sep-22''',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              const SizedBox(
                                width: 100,
                              ),
                              const Text(
                                '''Invoice#
DDSPL21/22/423''',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: const AutoSizeText(
                            '\u{20B9}${336.0}',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        )
                      ],
                    )),
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: const ListTile(
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: AutoSizeText('Payment',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        ),
                        subtitle: AutoSizeText("Mode",
                            style: TextStyle(fontSize: 20, color: Colors.black)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 100, left: 35),
                      child: Container(
                        width: 350,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300]),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => signature1()),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Cash',
                                style:
                                TextStyle(color: Colors.black54, fontSize: 20),
                              ),
                              const SizedBox(
                                width: 150,
                              ),
                              Icon(
                                Icons.arrow_downward,
                                size: 40,
                                color: Colors.grey[500],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class Secondpage extends StatelessWidget {
  Secondpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const AutoSizeText(
          'Dental Payment',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.savings),
              label: 'Saving',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.repeat),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ]),
      body: Center(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.27,
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: ListTile(
                    title: const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: AutoSizeText(
                        'Pearl Dental',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "21,3rd Street",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text("SS Colony",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 20, color: Colors.black)),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text("Madurai",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 20, color: Colors.black)),
                        ],
                      ),
                    )),
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.275,
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: ListTile(
                    title: const Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: AutoSizeText('Invoice Details',
                          style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    ),
                    subtitle: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              const Text(
                                '''Due Date
30-Sep-22''',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              const SizedBox(
                                width: 100,
                              ),
                              const Text(
                                '''Invoice#
DDSPL21/22/423''',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: const AutoSizeText(
                            '\u{20B9}${336.0}',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        )
                      ],
                    )),
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: const ListTile(
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: AutoSizeText('Payment',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        ),
                        subtitle: AutoSizeText("Mode",
                            style: TextStyle(fontSize: 20, color: Colors.black)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 100, left: 35),
                      child: Container(
                        width: 350,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300]),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => signature2()),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Cash',
                                style:
                                TextStyle(color: Colors.black54, fontSize: 20),
                              ),
                              const SizedBox(
                                width: 150,
                              ),
                              Icon(
                                Icons.arrow_downward,
                                size: 40,
                                color: Colors.grey[500],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class Thirdpage extends StatelessWidget {
  Thirdpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const AutoSizeText(
          'Dental Payment',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.savings),
              label: 'Saving',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.repeat),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ]),
      body: Center(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.27,
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: ListTile(
                    title: const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: AutoSizeText(
                        'Puew White Dental Lab',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "21,3rd Street",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text("SS Colony",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 20, color: Colors.black)),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text("Madurai",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 20, color: Colors.black)),
                        ],
                      ),
                    )),
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.275,
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: ListTile(
                    title: const Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: AutoSizeText('Invoice Details',
                          style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    ),
                    subtitle: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              const Text(
                                '''Due Date
30-Sep-22''',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              const SizedBox(
                                width: 100,
                              ),
                              const Text(
                                '''Invoice#
DDSPL21/22/423''',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: const AutoSizeText(
                            '\u{20B9}${336.0}',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        )
                      ],
                    )),
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: const ListTile(
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: AutoSizeText('Payment',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        ),
                        subtitle: AutoSizeText("Mode",
                            style: TextStyle(fontSize: 20, color: Colors.black)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 100, left: 35),
                      child: Container(
                        width: 350,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300]),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => signature3()),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Cash',
                                style:
                                TextStyle(color: Colors.black54, fontSize: 20),
                              ),
                              const SizedBox(
                                width: 150,
                              ),
                              Icon(
                                Icons.arrow_downward,
                                size: 40,
                                color: Colors.grey[500],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class signature1 extends StatefulWidget {
  signature1({Key? key}) : super(key: key);

  @override
  State<signature1> createState() => _signature1State();
}

class _signature1State extends State<signature1> {
  int _value = 0;
  GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    final info = statuses[Permission.storage].toString();
    print(info);
    _toastInfo(info);
  }

  _toastInfo(String info) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: AutoSizeText(info),
    ));
  }

  void _handleSaveButtonPressed() async {
    Timer(const Duration(seconds: 5), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => confirmpage1()),
      );
    });
    RenderSignaturePad boundary = signatureGlobalKey.currentContext!
        .findRenderObject() as RenderSignaturePad;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      final time = DateTime.now().millisecond;
      final name = "signature_$time.png";
      final result = await ImageGallerySaver.saveImage(
          byteData.buffer.asUint8List(),
          quality: 100,
          name: name);
      print(result);
      _toastInfo(result.toString());

      final isSuccess = result['isSuccess'];
      signatureGlobalKey.currentState!.clear();
      if (isSuccess) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Scaffold(
                backgroundColor: Colors.grey[300],
                appBar: AppBar(
                  title: const AutoSizeText(
                    "Dental Payment",
                    style: TextStyle(fontSize: 25),
                  ),
                  centerTitle: true,
                ),
                bottomNavigationBar: BottomNavigationBar(
                    showUnselectedLabels: true,
                    selectedItemColor: Colors.blue,
                    unselectedItemColor: Colors.grey,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.savings),
                        label: 'Saving',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.account_balance_wallet),
                        label: 'Wallet',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.repeat),
                        label: 'Transactions',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                      ),
                    ]),
                body: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 270,
                              width: 450,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.all(10),
                                    child: const ListTile(
                                      title: AutoSizeText(
                                          "Payment for                                                                 "
                                              "Senthil Poly Clinic",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      subtitle: AutoSizeText(
                                        "                                                                                                                    Amount  \u{20B9}${336.00}/- received as                                 Cash by Viswakumar in full                                Amount for the invoice                                         on 22-Sep-2022",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 21),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(
                                        left: 250, right: 20, top: 0),
                                    color: Colors.white,
                                    child: Image.memory(
                                        byteData.buffer.asUint8List()),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            height: 250,
                            width: 450,
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(1, 140, 50, 1),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                            alignment: Alignment.center,
                            child: Container(
                              height: 90,
                              width: 300,
                              color: const Color.fromRGBO(1, 190, 100, 1),
                              alignment: Alignment.center,
                              child: const AutoSizeText(
                                '\u{20B9}${336.00}',
                                style: TextStyle(
                                  fontSize: 80,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: Color.fromRGBO(1, 190, 70, 1),
                            size: 80,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const AutoSizeText(
          "Dental Payment",
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.savings),
              label: 'Saving',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.repeat),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ]),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 40, left: 30),
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    const AutoSizeText(
                      "Payments for                               "
                          "Senthil Poly Clinic",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: 2,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 17, left: 20),
                      alignment: Alignment.centerLeft,
                      child: const AutoSizeText(
                        "Amount",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(right: 145),
                        child: SizedBox(
                            height: 45,
                            width: 200,
                            child: TextField(
                              style: const TextStyle(fontSize: 20),
                              obscureText: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ))),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  Radio(
                                      value: 1,
                                      groupValue: _value,
                                      onChanged: (value) {
                                        setState(() {
                                          _value = 1;
                                        });
                                      }),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  const AutoSizeText('Full')
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                      value: 2,
                                      groupValue: _value,
                                      onChanged: (value) {
                                        setState(() {
                                          _value = 2;
                                        });
                                      }),
                                  const AutoSizeText('Partial')
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 260),
                      child: const AutoSizeText("22-Sep-2022"),
                    )
                  ],
                ),
                color: Colors.white,
                height: 257,
                width: 500,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: const AutoSizeText(
                  "Sign by Client",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                color: Colors.white,
                height: 70,
                width: 500,
              ),
              Container(
                margin: const EdgeInsets.only(top: 30, bottom: 80),
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: SfSignaturePad(
                  key: signatureGlobalKey,
                  maximumStrokeWidth: 6,
                  minimumStrokeWidth: 5,
                  backgroundColor: Colors.white,
                ),
                height: 140,
                width: 600,
              ),
              Container(
                alignment: FractionalOffset.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          signatureGlobalKey.currentState!.clear();
                        },
                        child: const AutoSizeText(
                          "clear",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 33,
                            color: Colors.white,
                          ),
                        )),
                    ElevatedButton(
                        onPressed: _handleSaveButtonPressed,
                        child: const AutoSizeText(
                          "CONFIRM",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        )),
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

class signature2 extends StatefulWidget {
  signature2({Key? key}) : super(key: key);

  @override
  State<signature2> createState() => _signature2State();
}

class _signature2State extends State<signature2> {

  GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    final info = statuses[Permission.storage].toString();
    print(info);
    _toastInfo(info);
  }

  _toastInfo(String info) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: AutoSizeText(info),
    ));
  }

  void _handleSaveButtonPressed() async {
    Timer(const Duration(seconds: 5), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => confirmpage2()),
      );
    });
    RenderSignaturePad boundary = signatureGlobalKey.currentContext!
        .findRenderObject() as RenderSignaturePad;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      final time = DateTime.now().millisecond;
      final name = "signature_$time.png";
      final result = await ImageGallerySaver.saveImage(
          byteData.buffer.asUint8List(),
          quality: 100,
          name: name);
      print(result);
      _toastInfo(result.toString());

      final isSuccess = result['isSuccess'];
      signatureGlobalKey.currentState!.clear();
      if (isSuccess) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Scaffold(
                backgroundColor: Colors.grey[300],
                appBar: AppBar(
                  title: const AutoSizeText(
                    "Dental Payment",
                    style: TextStyle(fontSize: 25),
                  ),
                  centerTitle: true,
                ),
                bottomNavigationBar: BottomNavigationBar(
                    showUnselectedLabels: true,
                    selectedItemColor: Colors.blue,
                    unselectedItemColor: Colors.grey,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.savings),
                        label: 'Saving',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.account_balance_wallet),
                        label: 'Wallet',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.repeat),
                        label: 'Transactions',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                      ),
                    ]),
                body: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 270,
                              width: 450,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.all(10),
                                    child: const ListTile(
                                      title: AutoSizeText(
                                          "Payment for                                                                 "
                                              "Pearl Dental",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      subtitle: AutoSizeText(
                                        "                                                                                                                    Amount  \u{20B9}${336.00}/- received as                                 Cash by Viswakumar in full                                Amount for the invoice                                         on 22-Sep-2022",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 21),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(
                                        left: 250, right: 20, top: 0),
                                    color: Colors.white,
                                    child: Image.memory(
                                        byteData.buffer.asUint8List()),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            height: 250,
                            width: 450,
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(1, 140, 50, 1),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                            alignment: Alignment.center,
                            child: Container(
                              height: 90,
                              width: 300,
                              color: const Color.fromRGBO(1, 190, 100, 1),
                              alignment: Alignment.center,
                              child: const AutoSizeText(
                                '\u{20B9}${336.00}',
                                style: TextStyle(
                                  fontSize: 80,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: Color.fromRGBO(1, 190, 70, 1),
                            size: 80,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String _radioValue;
    var radioValue;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const AutoSizeText(
          "Dental Payment",
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.savings),
              label: 'Saving',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.repeat),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ]),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 40, left: 30),
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    const AutoSizeText(
                      "Payments for                               "
                          "Pearl Dental",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: 2,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 17, left: 20),
                      alignment: Alignment.centerLeft,
                      child: const AutoSizeText(
                        "Amount",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(right: 145),
                        child: SizedBox(
                            height: 45,
                            width: 200,
                            child: TextField(
                              style: const TextStyle(fontSize: 20),
                              obscureText: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ))),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  Radio(
                                      value: 'Full',
                                      groupValue: radioValue,
                                      onChanged: (value) {
                                        setState(() {
                                          var radioValue = value!;
                                        });
                                      }),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                      value: 'Partial',
                                      groupValue: radioValue,
                                      onChanged: (value) {
                                        setState(() {
                                          radioValue = value!;
                                        });
                                      }),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 260),
                      child: const AutoSizeText("22-Sep-2022"),
                    )
                  ],
                ),
                color: Colors.white,
                height: 257,
                width: 500,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(15),
                alignment: Alignment.centerLeft,
                child: const AutoSizeText(
                  "Sign by Client",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                color: Colors.white,
                height: 60,
                width: 500,
              ),
              Container(
                margin: const EdgeInsets.only(top: 30, bottom: 80),
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: SfSignaturePad(
                  key: signatureGlobalKey,
                  maximumStrokeWidth: 6,
                  minimumStrokeWidth: 5,
                  backgroundColor: Colors.white,
                ),
                height: 160,
                width: 400,
              ),
              Container(
                alignment: FractionalOffset.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          signatureGlobalKey.currentState!.clear();
                        },
                        child: const AutoSizeText(
                          "clear",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 33,
                            color: Colors.white,
                          ),
                        )),
                    ElevatedButton(
                        onPressed: _handleSaveButtonPressed,
                        child: const AutoSizeText(
                          "CONFIRM",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        )),
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

class signature3 extends StatefulWidget {
  signature3({Key? key}) : super(key: key);

  @override
  State<signature3> createState() => _signature3State();
}

class _signature3State extends State<signature3> {
  int _value = 0;
  GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    final info = statuses[Permission.storage].toString();
    print(info);
    _toastInfo(info);
  }

  _toastInfo(String info) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: AutoSizeText(info),
    ));
  }

  void _handleSaveButtonPressed() async {
    Timer(const Duration(seconds: 5), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => confirmpage3()),
      );
    });
    RenderSignaturePad boundary = signatureGlobalKey.currentContext!
        .findRenderObject() as RenderSignaturePad;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      final time = DateTime.now().millisecond;
      final name = "signature_$time.png";
      final result = await ImageGallerySaver.saveImage(
          byteData.buffer.asUint8List(),
          quality: 100,
          name: name);
      print(result);
      _toastInfo(result.toString());

      final isSuccess = result['isSuccess'];
      signatureGlobalKey.currentState!.clear();
      if (isSuccess) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Scaffold(
                backgroundColor: Colors.grey[300],
                appBar: AppBar(
                  title: const AutoSizeText(
                    "Dental Payment",
                    style: TextStyle(fontSize: 25),
                  ),
                  centerTitle: true,
                ),
                bottomNavigationBar: BottomNavigationBar(
                    showUnselectedLabels: true,
                    selectedItemColor: Colors.blue,
                    unselectedItemColor: Colors.grey,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.savings),
                        label: 'Saving',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.account_balance_wallet),
                        label: 'Wallet',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.repeat),
                        label: 'Transactions',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                      ),
                    ]),
                body: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 270,
                              width: 450,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.all(10),
                                    child: const ListTile(
                                      title: AutoSizeText(
                                          "Payment for                                                                 "
                                              "Pure White Dental Lab",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      subtitle: AutoSizeText(
                                        "                                                                                                                    Amount  \u{20B9}${336.00}/- received as                                 Cash by Viswakumar in full                                Amount for the invoice                                         on 22-Sep-2022",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 21),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(
                                        left: 250, right: 20, top: 0),
                                    color: Colors.white,
                                    child: Image.memory(
                                        byteData.buffer.asUint8List()),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            height: 250,
                            width: 450,
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(1, 140, 50, 1),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                            alignment: Alignment.center,
                            child: Container(
                              height: 90,
                              width: 300,
                              color: const Color.fromRGBO(1, 190, 100, 1),
                              alignment: Alignment.center,
                              child: const AutoSizeText(
                                '\u{20B9}${336.00}',
                                style: TextStyle(
                                  fontSize: 80,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: Color.fromRGBO(1, 190, 70, 1),
                            size: 80,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const AutoSizeText(
          "Dental Payment",
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.savings),
              label: 'Saving',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.repeat),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ]),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 40, left: 30),
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    const AutoSizeText(
                      "Payments for                               "
                          "Pure White Dental Lab",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: 2,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 17, left: 20),
                      alignment: Alignment.centerLeft,
                      child: const AutoSizeText(
                        "Amount",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(right: 145),
                        child: SizedBox(
                            height: 45,
                            width: 200,
                            child: TextField(
                              style: const TextStyle(fontSize: 20),
                              obscureText: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ))),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  Radio(
                                      value: 1,
                                      groupValue: _value,
                                      onChanged: (value) {
                                        setState(() {
                                          _value = 1;
                                        });
                                      }),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  const AutoSizeText('Full')
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                      value: 2,
                                      groupValue: _value,
                                      onChanged: (value) {
                                        setState(() {
                                          _value = 2;
                                        });
                                      }),
                                  const AutoSizeText('Partial')
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 260),
                      child: const AutoSizeText("22-Sep-2022"),
                    )
                  ],
                ),
                color: Colors.white,
                height: 257,
                width: 500,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(15),
                alignment: Alignment.centerLeft,
                child: const AutoSizeText(
                  "Sign by Client",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                color: Colors.white,
                height: 60,
                width: 500,
              ),
              Container(
                margin: const EdgeInsets.only(top: 30, bottom: 80),
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: SfSignaturePad(
                  key: signatureGlobalKey,
                  maximumStrokeWidth: 6,
                  minimumStrokeWidth: 5,
                  backgroundColor: Colors.white,
                ),
                height: 160,
                width: 400,
              ),
              Container(
                alignment: FractionalOffset.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          signatureGlobalKey.currentState!.clear();
                        },
                        child: const AutoSizeText(
                          "clear",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 33,
                            color: Colors.white,
                          ),
                        )),
                    ElevatedButton(
                        onPressed: _handleSaveButtonPressed,
                        child: const AutoSizeText(
                          "CONFIRM",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        )),
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

class confirmpage1 extends StatefulWidget {
  confirmpage1({Key? key}) : super(key: key);

  @override
  State<confirmpage1> createState() => _confirmpage1();
}

class _confirmpage1 extends State<confirmpage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const AutoSizeText(
          'Dental Payment',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.savings),
              label: 'Saving',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.repeat),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ]),
      body: Center(
          child: Column(
            children: [
              Container(
                height: 100,
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                child: const ListTile(
                  title: AutoSizeText(
                    'Hi vishwanath',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Colors.white, spreadRadius: 30),
                    BoxShadow(color: Colors.grey, spreadRadius: 2),
                  ],
                ),
                child: const Center(
                  child: AutoSizeText(
                    'Collection Request 3',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                height: 219.1,
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child: const AutoSizeText(
                  "Customer List",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black, // Background color
                ),
                child: const ListTile(
                  title: AutoSizeText(
                    'Senthil Poly Clinic',
                    style: TextStyle(fontSize: 25),
                  ),
                  subtitle:
                  AutoSizeText('TVS Nagar', style: TextStyle(fontSize: 15)),
                  trailing: Icon(
                    // <-- Icon
                    Icons.check_circle,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Secondpage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black, // Background color
                ),
                child: const ListTile(
                  title: AutoSizeText(
                    'Pearl Dental',
                    style: TextStyle(fontSize: 25),
                  ),
                  subtitle:
                  AutoSizeText('SS Colony ', style: TextStyle(fontSize: 15)),
                  trailing: Icon(
                    // <-- Icon
                    Icons.arrow_forward_ios,
                    size: 25,
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Thirdpage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black, // Background color
                ),
                child: const ListTile(
                  title: AutoSizeText(
                    'Pure White Dental Lab',
                    style: TextStyle(fontSize: 25),
                  ),
                  subtitle:
                  AutoSizeText('SS Colony ', style: TextStyle(fontSize: 15)),
                  trailing: Icon(
                    // <-- Icon
                    Icons.arrow_forward_ios,
                    size: 25,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class confirmpage2 extends StatefulWidget {
  confirmpage2({Key? key}) : super(key: key);

  @override
  State<confirmpage2> createState() => _confirmpage2();
}

class _confirmpage2 extends State<confirmpage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const AutoSizeText(
          'Dental Payment',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.savings),
              label: 'Saving',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.repeat),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ]),
      body: Center(
          child: Column(
            children: [
              Container(
                height: 100,
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                child: const ListTile(
                  title: AutoSizeText(
                    'Hi vishwanath',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Colors.white, spreadRadius: 30),
                    BoxShadow(color: Colors.grey, spreadRadius: 2),
                  ],
                ),
                child: const Center(
                  child: AutoSizeText(
                    'Collection Request 3',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                height: 219.1,
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child: const AutoSizeText(
                  "Customer List",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Firstpage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black, // Background color
                ),
                child: const ListTile(
                  title: AutoSizeText(
                    'Senthil Poly Clinic',
                    style: TextStyle(fontSize: 25),
                  ),
                  subtitle:
                  AutoSizeText('TVS Nagar', style: TextStyle(fontSize: 15)),
                  trailing: Icon(
                    // <-- Icon
                    Icons.arrow_forward_ios,
                    size: 25,
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black, // Background color
                ),
                child: const ListTile(
                  title: AutoSizeText(
                    'Pearl Dental',
                    style: TextStyle(fontSize: 25),
                  ),
                  subtitle:
                  AutoSizeText('SS Colony ', style: TextStyle(fontSize: 15)),
                  trailing: Icon(
                    // <-- Icon
                    Icons.check_circle,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Thirdpage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black, // Background color
                ),
                child: const ListTile(
                  title: AutoSizeText(
                    'Pure White Dental Lab',
                    style: TextStyle(fontSize: 25),
                  ),
                  subtitle:
                  AutoSizeText('SS Colony ', style: TextStyle(fontSize: 15)),
                  trailing: Icon(
                    // <-- Icon
                    Icons.arrow_forward_ios,
                    size: 25,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class confirmpage3 extends StatefulWidget {
  confirmpage3({Key? key}) : super(key: key);

  @override
  State<confirmpage3> createState() => _confirmpage3();
}

class _confirmpage3 extends State<confirmpage3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const AutoSizeText(
          'Dental Payment',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.savings),
              label: 'Saving',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.repeat),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ]),
      body: Center(
          child: Column(
            children: [
              Container(
                height: 100,
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                child: const ListTile(
                  title: AutoSizeText(
                    'Hi vishwanath',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Colors.white, spreadRadius: 30),
                    BoxShadow(color: Colors.grey, spreadRadius: 2),
                  ],
                ),
                child: const Center(
                  child: AutoSizeText(
                    'Collection Request 3',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                height: 219.1,
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child: const AutoSizeText(
                  "Customer List",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Firstpage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black, // Background color
                ),
                child: const ListTile(
                  title: AutoSizeText(
                    'Senthil Poly Clinic',
                    style: TextStyle(fontSize: 25),
                  ),
                  subtitle:
                  AutoSizeText('TVS Nagar', style: TextStyle(fontSize: 15)),
                  trailing: Icon(
                    // <-- Icon
                    Icons.arrow_forward_ios,
                    size: 25,
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Secondpage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black, // Background color
                ),
                child: const ListTile(
                  title: AutoSizeText(
                    'Pearl Dental',
                    style: TextStyle(fontSize: 25),
                  ),
                  subtitle:
                  AutoSizeText('SS Colony ', style: TextStyle(fontSize: 15)),
                  trailing: Icon(
                    // <-- Icon
                    Icons.arrow_forward_ios,
                    size: 25,
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black, // Background color
                ),
                child: const ListTile(
                  title: AutoSizeText(
                    'Pure White Dental Lab',
                    style: TextStyle(fontSize: 25),
                  ),
                  subtitle:
                  AutoSizeText('SS Colony ', style: TextStyle(fontSize: 15)),
                  trailing: Icon(
                    // <-- Icon
                    Icons.check_circle,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}