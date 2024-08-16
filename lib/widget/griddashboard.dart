import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printingservices/page/document_printing.dart';
import 'package:printingservices/page/image_printing.dart';
import 'package:printingservices/page/plan_printing.dart';
import 'package:printingservices/page/setting_page.dart';
import 'package:printingservices/page/view_order.dart';
import 'package:url_launcher/url_launcher.dart';

class GridDashboard extends StatefulWidget {
  final String username;
  final String userId;
  GridDashboard({required this.username, required this.userId});

  @override
  State<GridDashboard> createState() => _GridDashboardState();
}

class _GridDashboardState extends State<GridDashboard> {
  final Uri _url = Uri.parse(
      'https://www.google.com.my/search?q=kolej+melati+uitm+shah+alam&ie=UTF-8&oe=UTF-8&hl=en-my&client=safari#');
  @override
  Widget build(BuildContext context) {
    Items item1 = Items(
        title: "Plan Printing",
        subtitle: "Business, Design",
        event: "",
        img: "assets/plotter.png",
        ontap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => PlanPrinting(
                        userId: widget.userId,
                      )));
        });

    Items item2 = Items(
        title: "Document Printing",
        subtitle: "Homework, Assignment",
        event: "",
        img: "assets/printer.png",
        ontap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => DocumentPrinting(
                        userId: widget.userId,
                      )));
        });

    Items item3 = Items(
        title: "Image Printing",
        subtitle: "Homework, Design",
        event: "",
        img: "assets/imageprinting.png",
        ontap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => ImagePrinting(
                        userId: widget.userId,
                      )));
        });

    Items item4 = Items(
        title: "View Order",
        subtitle: "View your order here",
        event: "",
        img: "assets/history.png",
        ontap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => ViewOrder(
                        userId: widget.userId,
                      )));
        });

    Items item5 = Items(
        title: "Location",
        subtitle: "Our location",
        event: "",
        img: "assets/map.png",
        ontap: () async {
          if (!await launchUrl(_url)) {
            throw Exception('Could not launch $_url');
          }
        });

    Items item6 = Items(
        title: "Settings",
        subtitle: "",
        event: "3 Items", //logout, request delete, edit profile.
        img: "assets/setting.png",
        ontap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => SettingPage(
                        userId: widget.userId,
                        username: widget.username,
                      )));
        });

    List<Items> myList = [item1, item2, item3, item4, item5, item6];
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
