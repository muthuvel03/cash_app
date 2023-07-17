import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fresh_apk/google_signin_api.dart';
import 'package:fresh_apk/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future signIn() async {
    final user = await GoogleSignInApi.login();

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sign in failed")),
      );
    } else {
      setState(() {
        GoogleSignInApi.isSignedIn = true;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Homepage(user: user)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF9B44),
              Color(0xFFFC6075),
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: FadeTransition(
          opacity: _animation,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the content vertically
              children: [
                SizedBox(height: screenSize.height * 0.1),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'images/ddspllogo.png',
                    width: screenSize.width * 0.4,
                    height: screenSize.height * 0.2,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.03),
                Text(
                  'DDSPL Receipts',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.09,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.1),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: screenSize.width * 0.09,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      "Welcome back! Login with Google",
                      style: TextStyle(
                        fontSize: screenSize.width * 0.04,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    SizedBox(
                      width: screenSize.width * 0.7,
                      height: screenSize.height * 0.1,
                      child: MaterialButton(
                        onPressed: signIn,
                        child: Image.asset(
                          'images/google.png',
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
