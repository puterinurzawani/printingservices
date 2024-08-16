import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printingservices/page/edit_profile.dart';
import 'package:printingservices/page/login_page.dart';

import '../core/text_style.dart';
import '../provider/rest.dart';

class GridSettings extends StatefulWidget {
  final String username;
  final String userId;
  GridSettings({required this.username, required this.userId});

  @override
  _GridSettingsState createState() => _GridSettingsState();
}

class _GridSettingsState extends State<GridSettings> {
  requestDelete() {
    var jsons = {
      "userId": widget.userId,
      "authKey": "key123",
    };
    HttpAuth.postApi(jsons: jsons, url: 'request_delete.php').then((value) {
      if (value.statusCode == 200) {
        AwesomeDialog(
          width: double.infinity,
          bodyHeaderDistance: 60,
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.SUCCES,
          body: const Center(
            child: Text(
              'Your Account Successfully Deleted',
              style: headline2,
              textAlign: TextAlign.center,
            ),
          ),
          title: '',
          desc: '',
          btnOkOnPress: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ).show();
      } else {
        AwesomeDialog(
          width: double.infinity,
          bodyHeaderDistance: 60,
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          body: const Center(
            child: Text(
              'Failed to deleted',
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Items item1 = Items(
        title: "Edit Profile",
        subtitle: "",
        event: "",
        img: "assets/user.png",
        ontap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => EditProfile(
                userId: widget.userId,
              ),
            ),
          );
        });

    Items item2 = Items(
        title: "Request Delete\nAccount",
        subtitle: "",
        event: "",
        img: "assets/accdelete.png",
        ontap: () {
          AwesomeDialog(
            width: double.infinity,
            bodyHeaderDistance: 60,
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.WARNING,
            body: const Center(
              child: Text(
                'Are you sure want to delete account?',
                style: headline2,
                textAlign: TextAlign.center,
              ),
            ),
            title: '',
            desc: '',
            btnOkText: "Yes",
            btnCancelText: 'Cancel',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              requestDelete();
            },
          ).show();
        });

    Items item3 = Items(
        title: "Logout",
        subtitle: "",
        event: "",
        img: "assets/logout.png",
        ontap: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false);
        });

    List<Items> myList = [item1, item2, item3];
    var color = 0xff453658;
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: const EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return InkWell(
              onTap: data.ontap,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(color),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      data.img,
                      width: 42,
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Text(
                      data.title,
                      style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      data.subtitle,
                      style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Text(
                      data.event,
                      style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
    );
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  Function()? ontap;
  Items({
    required this.title,
    required this.subtitle,
    required this.event,
    required this.img,
    required this.ontap,
  });
}
