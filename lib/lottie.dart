import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import 'Post.dart';
import 'home_page.dart';

class Animation1 extends StatefulWidget {
  final GoogleSignInAccount user;
  final Post? data;
  const Animation1({Key? key, required this.user, this.data}) : super(key: key);

  @override
  State<Animation1> createState() => _AnimationState();
}

class _AnimationState extends State<Animation1>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
    // Start a timer to navigate to the homepage after 10 seconds
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Homepage(user: widget.user),
        ),
        ModalRoute.withName('/homepage'),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: 5.0,
                child: Lottie.network(
                  'https://assets4.lottiefiles.com/packages/lf20_MknfyU.json',
                  repeat: false,
                  height: MediaQuery.of(context).size.width * 0.9,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
              ),
              SizedBox(
                  height:
                      20), // Add some spacing between the animation and text
              AnimatedBuilder(
                animation: _animationController,
                builder: (BuildContext context, Widget? child) {
                  return Opacity(
                    opacity: _animation.value,
                    child: Transform.translate(
                      offset: Offset(
                          0.0,
                          20.0 *
                              (1 -
                                  _animation
                                      .value)), // Move the text upwards during the animation
                      child: Text(
                        'Payment successful',
                        textAlign:
                            TextAlign.center, // Align the text in the center
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
