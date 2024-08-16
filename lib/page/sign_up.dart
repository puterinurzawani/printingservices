import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:printingservices/core/space.dart';
import 'package:printingservices/widget/main_button.dart';

import '../core/colors.dart';
import '../core/text_style.dart';
import '../provider/rest.dart';
import '../widget/text_fild.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController userName = TextEditingController();
  TextEditingController userPass = TextEditingController();
  TextEditingController userConfirmPass = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPh = TextEditingController();
  bool isLoading = false;

  sendApi() {
    if (userConfirmPass.text != userPass.text) {
      AwesomeDialog(
        width: double.infinity,
        bodyHeaderDistance: 60,
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: const Center(
          child: Text(
            'Your password and confirm password has not matched, please try again.',
            style: headline2,
            textAlign: TextAlign.center,
          ),
        ),
        title: '',
        desc: '',
        btnOkOnPress: () {},
      ).show();
      return;
    }
    var jsons = {
      "username": userName.text,
      "email": userEmail.text,
      "phoneNumber": userPh.text,
      "password": userPass.text,
      "authKey": "key123"
    };
    isLoading = true;
    setState(() {});
    HttpAuth.postApi(jsons: jsons, url: 'signup.php').then((value) {
      isLoading = false;
      setState(() {});
      if (value.statusCode == 200) {
        AwesomeDialog(
          width: double.infinity,
          bodyHeaderDistance: 60,
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.SUCCES,
          body: const Center(
            child: Text(
              'Successfully registered! Please login again.',
              style: headline2,
              textAlign: TextAlign.center,
            ),
          ),
          title: '',
          desc: '',
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
        ).show();
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
      backgroundColor: blackBG,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SpaceVH(height: 50.0),
                    const Text(
                      'Create new account',
                      style: headline1,
                    ),
                    const SpaceVH(height: 10.0),
                    const Text(
                      'Please fill in the form to continue',
                      style: headline3,
                    ),
                    const SpaceVH(height: 60.0),
                    textFild(
                      controller: userName,
                      image: 'user.svg',
                      keyBordType: TextInputType.name,
                      hintTxt: 'Username',
                    ),
                    textFild(
                      controller: userEmail,
                      keyBordType: TextInputType.emailAddress,
                      image: 'user.svg',
                      hintTxt: 'Email Address',
                    ),
                    textFild(
                      controller: userPh,
                      image: 'user.svg',
                      keyBordType: TextInputType.phone,
                      hintTxt: 'Phone Number',
                    ),
                    textFild(
                      controller: userPass,
                      isObs: true,
                      image: 'hide.svg',
                      hintTxt: 'Password',
                    ),
                    textFild(
                      controller: userConfirmPass,
                      isObs: true,
                      image: 'hide.svg',
                      hintTxt: 'Confirm Password',
                    ),
                    const SpaceVH(height: 80.0),
                    Mainbutton(
                      onTap: () {
                        sendApi();
                      },
                      text: 'Sign Up',
                      btnColor: blueButton,
                    ),
                    const SpaceVH(height: 20.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Have an account? ',
                            style: headline3.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: ' Sign In',
                            style: headlineDot.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
