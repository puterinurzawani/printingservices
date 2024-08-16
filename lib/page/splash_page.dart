import 'package:flutter/material.dart';
import 'package:printingservices/core/colors.dart';
import 'package:printingservices/page/login_page.dart';
import 'package:printingservices/widget/main_button.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSplashShow = true;
  @override
  void initState() {
    initialization();
    super.initState();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    isSplashShow = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Visibility(
            visible: isSplashShow,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Center(
                child: Image.asset(
                  'assets/image/splash.jpg',
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isSplashShow,
            child: Container(
              height: height,
              color: blackBG,
              child: Image.asset(
                'assets/image/wallpaper.jpg',
                height: height,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Positioned(
          //   left: 100,
          //   right: 100,
          //   top: 200,
          //   child: Visibility(
          //     visible: !isSplashShow,
          //     child: Container(
          //       height: 150,
          //       width: 150,
          //       color: blackBG,
          //       child: Image.asset(
          //         'assets/image/splash.jpg',
          //         height: height,
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   ),
          // ),
          Visibility(
            visible: !isSplashShow,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: height / 3,
                width: double.infinity,
                // decoration: const BoxDecoration(
                //   gradient: LinearGradient(
                //     colors: gradient,
                //     begin: Alignment.bottomCenter,
                //     end: Alignment.topCenter,
                //   ),
                // ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // RichText(
                    //   text: const TextSpan(children: [
                    //     TextSpan(
                    //       text: 'Printing Services',
                    //       style: headline,
                    //     ),
                    //     TextSpan(
                    //       text: '.',
                    //       style: headlineDot,
                    //     ),
                    //   ]),
                    // ),
                    // const SpaceVH(height: 20.0),
                    // const Text(
                    //   splashText,
                    //   textAlign: TextAlign.center,
                    //   style: headline2,
                    // ),
                    Mainbutton(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const LoginPage()));
                      },
                      btnColor: blueButton,
                      text: 'Get Started',
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
