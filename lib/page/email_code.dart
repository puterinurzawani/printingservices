import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:printingservices/widget/main_button.dart';

import '../core/colors.dart';
import '../core/text_style.dart';
import '../provider/rest.dart';
import 'change_password.dart';

class EmailCode extends StatefulWidget {
  final String emailUser;
  const EmailCode({Key? key, required this.emailUser}) : super(key: key);

  @override
  _EmailCodeState createState() => _EmailCodeState();
}

class _EmailCodeState extends State<EmailCode> {
  final emailCode = TextEditingController();

  sendApi() {
    var jsons = {
      "email": widget.emailUser,
      "emailCode": emailCode.text,
      "authKey": "key123",
    };
    HttpAuth.postApi(jsons: jsons, url: 'email_code.php').then((value) {
      if (value.statusCode == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => ChangePassword(
                      emailUser: widget.emailUser,
                    )));
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
                  child: const Text('Email',
                      style: TextStyle(
                          fontSize: 60.0, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                  child: const Text('Code',
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
                  'Check in your gmail account for new code to change the password.',
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
                TextField(
                  controller: emailCode,
                  decoration: const InputDecoration(
                      labelText: 'CODE',
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
