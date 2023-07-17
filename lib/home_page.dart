import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fresh_apk/Post.dart';
import 'package:fresh_apk/first_page.dart';
import 'package:fresh_apk/google_signin_api.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'ApiService.dart';
import 'login_page.dart';
import 'notification_services.dart';

class Homepage extends StatefulWidget {
  final GoogleSignInAccount user;
  const Homepage({Key? key, required this.user}) : super(key: key);

  static const url =
      "https://dakshindspl.com/devddspl/public/api/cash-detail-req";

  @override
  State<Homepage> createState() => _HomepageState(user: user);
}

class _HomepageState extends State<Homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  NotificationServices notificationServices = NotificationServices();

  late ApiService apiService;
  late GoogleSignInAccount user;
  List<Post> postList = [];
  bool isLoading = false;

  _HomepageState({required this.user}) {
    apiService = ApiService();
  }

  @override
  void initState() {
    super.initState();
    refreshData();

    if (GoogleSignInApi.isSignedIn == true) {
      notificationServices = NotificationServices();
      notificationServices.requestNotificationPermission();
      notificationServices.firebaseInit(context);
      notificationServices.setupInteractMessage(context);
      notificationServices.isTokenRefresh();
      notificationServices.getDeviceToken();
    }
  }

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });

    List<Post> newData = await apiService.getPostApi(updateState);

    setState(() {
      if (newData.isNotEmpty && newData[0].status != "No Data Found") {
        postList = newData;
      } else {
        postList.clear();
      }
      isLoading = false;
    });
  }

  void updateState(List<Post> newData) {
    setState(() {
      postList = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[10],
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFFF9B44),
                      Color(0xFFFC6075),
                    ],
                  ),
                ),
                child: Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Payment History'),
                onTap: () {
                  // Handle drawer item tap
                },
              ),
            ],
          ),
        ),
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'images/ddspllogo.png',
                width: MediaQuery.of(context).size.width * 0.09,
                height: MediaQuery.of(context).size.width * 0.09,
              ),
            ),
          ),
          title: Text(
            'DDSPL',
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.08),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              child: GestureDetector(
                onTap: () async {
                  try {
                    await GoogleSignInApi.logout();
                    setState(() {
                      GoogleSignInApi.isSignedIn = false;
                    });
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  } catch (e) {
                    print("Error during logout: $e");
                    // Handle the error or display a message to the user
                  }
                },
                child: Icon(
                  Icons.logout,
                  size: MediaQuery.of(context).size.width * 0.07,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.05,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFF9B44),
                            Color(0xFFFC6075),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.3,
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
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: MediaQuery.of(context).size.width * 0.1,
                              backgroundColor: Colors.blue,
                              backgroundImage: (widget.user.photoUrl != null &&
                                      widget.user.photoUrl!.isNotEmpty)
                                  ? NetworkImage(widget.user.photoUrl!)
                                  : null,
                              child: (widget.user.photoUrl == null ||
                                      widget.user.photoUrl!.isEmpty)
                                  ? Text(
                                      widget.user.displayName![0],
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.width * 0.05),
                          Text(
                            'Hi ${widget.user.displayName}',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.width * 0.05),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.width * 0.05,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.1,
                            ),
                            child: Text(
                              'Collection Request: ${postList.length}',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.04),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: RefreshIndicator(
                        onRefresh: refreshData,
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : postList.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.1),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: AnimationLimiter(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children:
                                                      AnimationConfiguration
                                                          .toStaggeredList(
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    childAnimationBuilder:
                                                        (widget) =>
                                                            SlideAnimation(
                                                      horizontalOffset:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                      child: FadeInAnimation(
                                                        child: widget,
                                                      ),
                                                    ),
                                                    children: [
                                                      Icon(
                                                        Icons.warning,
                                                        color:
                                                            Colors.yellow[800],
                                                        size: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.12,
                                                      ),
                                                      SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.04),
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.05),
                                                        child: Text(
                                                          'There is no Collection Request Now!',
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.04,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.02),
                                                      Text(
                                                        'Please check back later for updates.',
                                                        style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.035,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.05),
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.05),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient:
                                                                const LinearGradient(
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight,
                                                              colors: [
                                                                Color(
                                                                    0xFFFF9B44),
                                                                Color(
                                                                    0xFFFC6075),
                                                              ],
                                                              stops: [0.0, 1.0],
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          child: ElevatedButton
                                                              .icon(
                                                            onPressed:
                                                                refreshData,
                                                            icon: const Icon(
                                                                Icons.refresh),
                                                            label: const Text(
                                                                'Refresh'),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  Colors.white,
                                                              shadowColor: Colors
                                                                  .transparent,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                            ),
                                                          ),
                                                        ),
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
                                  )
                                : Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Customer List",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: postList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                margin: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.025),
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.025),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 1,
                                                      blurRadius: 3,
                                                      offset:
                                                          const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: ListTile(
                                                  title: Text(postList[index]
                                                      .clinicName),
                                                  subtitle: Text(
                                                      postList[index].city),
                                                  trailing: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      gradient:
                                                          const LinearGradient(
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                        colors: [
                                                          Color(0xFFFC6075),
                                                          Color(0xFFFF9B44),
                                                        ],
                                                      ),
                                                    ),
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    FirstPage(
                                                              data: postList[
                                                                  index],
                                                              user: user,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor:
                                                            Colors.white,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          vertical: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                          horizontal:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.075,
                                                        ),
                                                        elevation: 0,
                                                        shadowColor:
                                                            Colors.transparent,
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'View Details',
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.037),
                                                          ),
                                                          SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.01),
                                                          Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            size: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.035,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
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
            ),
          ],
        ),
      ),
    );
  }
}
