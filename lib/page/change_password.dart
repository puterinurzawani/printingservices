import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:printingservices/page/login_page.dart';

import '../core/colors.dart';
import '../core/text_style.dart';
import '../provider/rest.dart';
import '../widget/main_button.dart';

class ChangePassword extends StatefulWidget {
  final String emailUser;
  const ChangePassword({Key? key, required this.emailUser}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  sendApi() {
    if (password.text != confirmPassword.text) {
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
      "email": widget.emailUser,
      "password": password.text,
      "authKey": "key123"
    };
    HttpAuth.postApi(jsons: jsons, url: 'change_password.php').then((value) {
      if (value.statusCode == 200) {
        var jsonResponse = json.decode(value.body);
        AwesomeDialog(
          width: double.infinity,
          bodyHeaderDistance: 60,
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.SUCCES,
          body: const Center(
            child: Text(
              'Successfully to changed password. Please login again.',
              style: headline2,
              textAlign: TextAlign.center,
            ),
          ),
          title: '',
          desc: '',
          btnOkOnPress: () {
            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const LoginPage(),
              ),
              (route) =>
                  false, //if you want to disable back feature set to false
            );
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
      resizeToAvoidBottomInset: true,
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back_outlined,
                  size: 40,
                ),
              ),
            ],
          ),
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                  child: const Text('Change',
                      style: TextStyle(
                          fontSize: 60.0, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                  child: const Text('Password',
                      style: TextStyle(
                          fontSize: 60.0, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(285.0, 175.0, 0.0, 0.0),
                  child: const Text('.',
                      style: TextStyle(
                          fontSize: 60.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                const Text(
                  'Enter your correct password make sure it\'s matched with confirm password.',
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
                TextField(
                  obscureText: true,
                  controller: password,
                  decoration: const InputDecoration(
                      labelText: 'PASSWORD',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red))),
                ),
                TextField(
                  obscureText: true,
                  controller: confirmPassword,
                  decoration: const InputDecoration(
                      labelText: 'CONFIRM PASSWORD',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red))),
                ),
                const SizedBox(height: 40.0),
                Mainbutton(
                  onTap: () {
                    sendApi();
                  },
                  text: 'Reset Password',
                  btnColor: blueButton,
                ),
              ],
            ),
          ),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
