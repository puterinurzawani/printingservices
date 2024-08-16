import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../core/text_style.dart';
import '../data/profile_model.dart';
import '../provider/rest.dart';

class EditProfile extends StatefulWidget {
  final String userId;
  EditProfile({required this.userId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isLoading = true;
  final username = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();

  final formGlobalKey = GlobalKey<FormState>();

  @override
  void initState() {
    callProfile();
    super.initState();
  }

  callProfile() {
    var jsons = {
      "userId": widget.userId,
      "authKey": "key123",
    };
    HttpAuth.postApi(jsons: jsons, url: 'display_profile.php').then((value) {
      if (value.statusCode == 200) {
        final displayProfile = displayProfileFromJson(value.body);
        username.text = displayProfile.username;
        email.text = displayProfile.email;
        phoneNumber.text = displayProfile.phoneNumber;

        isLoading = false;
        setState(() {});
      }
    });
  }

  updateProfileApi() {
    var jsons = {
      "userId": widget.userId,
      "email": email.text,
      "phoneNumber": phoneNumber.text,
      "authKey": "key123",
    };

    HttpAuth.postApi(jsons: jsons, url: 'update_profile.php').then((value) {
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
              'Successfully Updated',
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
        AwesomeDialog(
          width: double.infinity,
          bodyHeaderDistance: 60,
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          body: const Center(
            child: Text(
              'Failed to Updated',
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
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: formGlobalKey,
              child: ListView(
                children: [
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
                      const Padding(
                        padding: EdgeInsets.only(top: 4, left: 10),
                        child: Text(
                          "Edit Profile",
                          style: headline1,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.characters,
                          controller: username,
                          readOnly: true,
                          style: const TextStyle(color: Colors.grey),
                          onSaved: (val) => {},
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(158, 158, 158, 1)),
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                            label: Text("Username",
                                style: TextStyle(fontSize: 16)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.characters,
                          controller: email,
                          readOnly: false,
                          style: const TextStyle(color: Colors.black),
                          onSaved: (val) => {},
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelStyle: TextStyle(color: Colors.black),
                            label:
                                Text("Email", style: TextStyle(fontSize: 16)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                          ),
                          validator: (value) {
                            final bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value!);

                            if (emailValid) {
                              return null;
                            } else {
                              return 'Enter a valid email address';
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.characters,
                          controller: phoneNumber,
                          readOnly: false,
                          style: const TextStyle(color: Colors.black),
                          onSaved: (val) => {},
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelStyle: TextStyle(color: Colors.black),
                            label: Text("Phone Number",
                                style: TextStyle(fontSize: 16)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                              if (formGlobalKey.currentState!.validate()) {
                                updateProfileApi();
                              }
                            },
                            child: Text(
                              "Submit",
                              style: headline2.copyWith(color: Colors.white),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
