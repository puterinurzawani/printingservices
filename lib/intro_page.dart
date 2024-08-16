import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:printingservices/page/login_page.dart';
import 'package:printingservices/page/splash_page.dart';

class IntroSliderPage extends StatefulWidget {
  @override
  _IntroSliderPageState createState() => _IntroSliderPageState();
}

class _IntroSliderPageState extends State<IntroSliderPage> {
  List<IntroSlide> slides = [];
  bool isSplashShow = true;

  @override
  void initState() {
    initialization();
    super.initState();
    slides.add(
      IntroSlide(
        title: "Printing",
        description: "Printing have 3 printing, Plan, Document, Image",
        pathImage: "assets/icon/printing.png",
      ),
    );
    slides.add(
      IntroSlide(
        title: "Quick & Easy Payment",
        description: "Payment need to be screenshot",
        pathImage: "assets/icon/tuition-payment-processing-icon-3.png",
      ),
    );
    slides.add(
      IntroSlide(
        title: "Instant Notification",
        description:
            "Student will get notification after processing and pick up",
        pathImage: "assets/icon/icone-cloche-notification-violet.png",
      ),
    );
    slides.add(
      IntroSlide(
        title: "Instant Notification",
        description:
            "Student will get notification after processing and pick up",
        pathImage: "assets/icon/self-pickup.png",
      ),
    );
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

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = [];
    for (int i = 0; i < slides.length; i++) {
      IntroSlide currentSlide = slides[i];
      tabs.add(
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            margin: const EdgeInsets.only(bottom: 160, top: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    currentSlide.pathImage,
                    matchTextDirection: true,
                    height: 250,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      currentSlide.title,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 35),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  margin: const EdgeInsets.only(
                    top: 15,
                    left: 20,
                    right: 20,
                  ),
                  child: Text(
                    currentSlide.description,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            child: IntroSlider(
              backgroundColorAllTabs: Color.fromARGB(255, 255, 255, 255),
              renderSkipBtn: Text(
                "Skip",
                style: TextStyle(color: Colors.white),
              ),
              renderNextBtn: Text(
                "Next",
                style: TextStyle(color: Colors.white),
              ),
              renderDoneBtn: Text(
                "Done",
                style: TextStyle(color: Colors.white),
              ),
              doneButtonStyle: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple)),
              skipButtonStyle: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple)),
              nextButtonStyle: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple)),
              listCustomTabs: renderListCustomTabs(),
              scrollPhysics: const BouncingScrollPhysics(),
              indicatorConfig: const IndicatorConfig(
                sizeIndicator: 8,
                colorActiveIndicator: Colors.grey,
                colorIndicator: Colors.white,
                typeIndicatorAnimation: TypeIndicatorAnimation.sizeTransition,
              ),
              onDonePress: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginPage(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IntroSlide {
  final String title;
  final String description;
  final String pathImage;

  IntroSlide(
      {required this.title,
      required this.description,
      required this.pathImage});
}
