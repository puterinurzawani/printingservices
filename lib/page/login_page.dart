import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:printingservices/page/forgot_page.dart';
import 'package:printingservices/page/home_page.dart';
import 'package:printingservices/page/sign_up.dart';

import '../core/colors.dart';
import '../core/space.dart';
import '../core/text_style.dart';
import '../provider/rest.dart';
import '../widget/main_button.dart';
import '../widget/text_fild.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userName = TextEditingController();
  TextEditingController userPass = TextEditingController();

  sendApi() {
    var jsons = {
      "username": userName.text,
      "password": userPass.text,
      "authKey": "key123"
    };
    HttpAuth.postApi(jsons: jsons, url: 'login.php').then((value) {
      var jsonResponse = json.decode(value.body);
      if (value.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => Home(
              username: userName.text,
              userId: jsonResponse["userid"],
            ),
          ),
        );
      } else {
        var jsonResponse = json.decode(value.body);
        AwesomeDialog(
          width: double.infinity,
          bodyHeaderDistance: 60,
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          body: Center(
            child: Text(
              jsonResponse["reason"],
              style: headline2,
              textAlign: TextAlign.center,
            ),
          ),
          title: '',
          desc: '',
          btnOkOnPress: () {},
        ).show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: blackBG,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              height: 200,
              width: 200,
              margin: const EdgeInsets.all(20),
              child: Image.asset(
                'assets/image/smalllogo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // const SpaceVH(height: 20.0),

                  const SpaceVH(height: 130.0),
                  const Text(
                    'Welcome Back!',
                    style: headline1,
                  ),
                  const SpaceVH(height: 10.0),
                  const Text(
                    'Please sign in to your account',
                    style: headline3,
                  ),
                  const SpaceVH(height: 60.0),
                  textFild(
                    controller: userName,
                    image: 'user.svg',
                    hintTxt: 'Username',
                  ),
                  textFild(
                    controller: userPass,
                    image: 'hide.svg',
                    isObs: true,
                    hintTxt: 'Password',
                  ),
                  const SpaceVH(height: 10.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => ForgotPage()));
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: headline3,
                        ),
                      ),
                    ),
                  ),
                  const SpaceVH(height: 20.0),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        Mainbutton(
                          onTap: () {
                            sendApi();
                          },
                          text: 'Sign in',
                          btnColor: blueButton,
                        ),
                        const SpaceVH(height: 20.0),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => SignUpPage()));
                          },
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: 'Don\' have an account? ',
                                style: headline3.copyWith(
                                  fontSize: 14.0,
                                ),
                              ),
                              TextSpan(
                                text: ' Sign Up',
                                style: headlineDot.copyWith(
                                  fontSize: 14.0,
                                ),
                              ),
                            ]),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
