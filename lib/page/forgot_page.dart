import 'dart:convert';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:printingservices/page/email_code.dart';

import '../core/colors.dart';
import '../core/text_style.dart';
import '../provider/rest.dart';
import '../widget/main_button.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({Key? key}) : super(key: key);

  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final email = TextEditingController();

  sendEmail(rndnumber) {
    var jsons = {
      "email": email.text,
      "generated": rndnumber,
      "authKey": "key123"
    };
    HttpAuth.postApi(jsons: jsons, url: 'email/index.php').then((value) {});
  }

  sendApi() {
    var rndnumber = "";
    var rnd = Random();
    for (var i = 0; i < 6; i++) {
      rndnumber = rndnumber + rnd.nextInt(9).toString();
    }
    var jsons = {
      "email": email.text,
      "generated": rndnumber,
      "authKey": "key123",
    };
    HttpAuth.postApi(jsons: jsons, url: 'forgot.php').then((value) {
      if (value.statusCode == 200) {
        var jsonResponse = json.decode(value.body);
        AwesomeDialog(
          width: double.infinity,
          bodyHeaderDistance: 60,
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.SUCCES,
          body: Center(
            child: Text(
              jsonResponse["reason"],
              style: headline2,
              textAlign: TextAlign.center,
            ),
          ),
          title: '',
          desc: '',
          btnOkOnPress: () {
            sendEmail(rndnumber);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => EmailCode(
                          emailUser: email.text,
                        )));
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
                  child: const Text('Reset',
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
                  child: const Text('?',
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
                  'Enter the email address associated with your account.',
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
                TextField(
                  controller: email,
                  decoration: const InputDecoration(
                      labelText: 'EMAIL',
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
