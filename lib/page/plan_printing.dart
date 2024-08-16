import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../core/colors.dart';
import '../core/text_style.dart';
import '../data/size_model.dart';
import '../provider/rest.dart';
import '../widget/main_button.dart';

class PlanPrinting extends StatefulWidget {
  final String userId;
  PlanPrinting({required this.userId});

  @override
  _PlanPrintingState createState() => _PlanPrintingState();
}

class _PlanPrintingState extends State<PlanPrinting> {
  int activeStep = 0;
  var sizeValue;

  final quantityForm = TextEditingController();
  final dateinput = TextEditingController();
  final timeinput = TextEditingController();
  final pagesinput = TextEditingController();
  final paymentinput = TextEditingController();

  DateTime? _selectedDate;

  List<File> showImageFile = [];
  List<String> imageWithBase64 = [];
  List<String> typeOfExtension = [];
  List<String> fileName = [];

  List<File> showImageFilePayment = [];
  List<String> imageWithBase64Payment = [];
  List<String> typeOfExtensionPayment = [];
  List<String> fileNamePayment = [];

  List<SizeDisplay> sizeDisplay = [];

  String timeApi = "";

  bool isLoading = true;

  double price = 0.00;

  int payment = 1;

  var selectBank;

  String displayOrderID = "";

  @override
  void initState() {
    callApiSize();
    super.initState();
  }

  callApiSize() {
    var jsons = {
      "authKey": "key123",
    };
    HttpAuth.postApi(jsons: jsons, url: 'display_size.php').then((value) {
      print(value);
      if (value.statusCode == 200) {
        final sizedisplay = sizedisplayFromJson(value.body);

        sizeDisplay = sizedisplay.sizeDisplay
            .where((element) => element.typeId.toString() == "1")
            .toList();
        isLoading = false;
        setState(() {});
      }
    });
  }

  callApiPayment() {
    isLoading = true;
    setState(() {});
    var rndnumber = "";
    var rnd = Random();
    for (var i = 0; i < 10; i++) {
      rndnumber = rndnumber + rnd.nextInt(9).toString();
    }
    displayOrderID = rndnumber;
    var jsons = {
      "userId": widget.userId,
      "sizeId": sizeValue.id,
      "pages": pagesinput.text,
      "quantity": quantityForm.text,
      "bookedDate": timeApi,
      "typeId": "1",
      "invoiceId": rndnumber,
      "statusPayment": "success",
      "price": price.toStringAsFixed(2),
      "authKey": "key123",
      "fileName": fileName[0],
      "fileBase64": imageWithBase64[0],
      "filePaymentName": fileNamePayment[0],
      "fileBase64Payment": imageWithBase64Payment[0],
    };
    HttpAuth.postApi(jsons: jsons, url: 'insert_plan.php').then((value) {
      isLoading = false;
      setState(() {});
    });
  }

  void _openFileUpload(isFromPayment) async {
    try {
      if (showImageFile.length < 1 || showImageFilePayment.length < 1) {
        FilePickerResult? result = Platform.isAndroid
            ? await FilePicker.platform.pickFiles(
                type: FileType.any,
                allowMultiple: false,
                allowCompression: false,
                // allowedExtensions: ['jpg', 'pdf', 'png', 'mp4'],
              )
            : await FilePicker.platform.pickFiles(
                type: FileType.any,
                allowMultiple: false,
                allowCompression: false,
              );

        if (result == null) return;
        PlatformFile file = result.files.first;
        File? convertToFile = File(file.path!);
        if (isFromPayment == false) {
          fileName.add(file.name);
        } else {
          fileNamePayment.add(file.name);
        }

        getStatusFile(file, convertToFile, isFromPayment);
        setState(() {});
      } else {
        toastToUser(msg: "You already uploaded the file");
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
  }

  getStatusFile(
      PlatformFile file, File convertToFile, bool isFromPayment) async {
    String getFileSize = getFileSizeString(bytes: convertToFile.lengthSync());
    var fileSizeSplit = getFileSize.split(".");
    bool getStatusType = isEnabledFileSize(typeSize: fileSizeSplit[1]);
    if (getStatusType) {
      insertFileInArray(file: file, isFromPayment: isFromPayment);
    } else {
      toastToUser(msg: "Size too large please try again");
      return;
    }
  }

  void insertFileInArray(
      {required PlatformFile file,
      String? additionalPath,
      required bool isFromPayment}) {
    List<int> imageBytes = File(file.path!).readAsBytesSync();
    String base64String = base64Encode(imageBytes);
    String header = "data:application/pdf;base64,";
    String? base64ImageUploadSizePhoto = header + base64String;
    if (isFromPayment == false) {
      showImageFile
          .add(File(additionalPath != null ? additionalPath : file.path!));
      imageWithBase64.add(base64ImageUploadSizePhoto);
      typeOfExtension.add(file.extension!);
    } else {
      showImageFilePayment
          .add(File(additionalPath != null ? additionalPath : file.path!));
      imageWithBase64Payment.add(base64ImageUploadSizePhoto);
      typeOfExtensionPayment.add(file.extension!);
    }
  }

  static bool isEnabledFileSize({required String typeSize}) {
    if (typeSize == "gb" || typeSize == "tb") {
      return false;
    } else {
      return true;
    }
  }

  static void toastToUser({required String msg}) {
    Fluttertoast.showToast(
        timeInSecForIosWeb: 3,
        msg: "$msg",
        backgroundColor: Colors.black,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER);
  }

  // Format File Size
  static String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        "." +
        suffixes[i];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
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
                      padding: const EdgeInsets.only(top: 4, left: 10),
                      child: Text(
                        "Plan Printing",
                        style: headline1,
                      ),
                    )
                  ],
                ),
                EasyStepper(
                  enableStepTapping: true,
                  activeStep: activeStep,
                  lineLength: 70,
                  stepShape: StepShape.rRectangle,
                  stepBorderRadius: 15,
                  borderThickness: 2,
                  padding: 20,
                  stepRadius: 28,
                  finishedStepBorderColor: Colors.deepOrange,
                  finishedStepTextColor: Colors.deepOrange,
                  finishedStepBackgroundColor: Colors.deepOrange,
                  activeStepIconColor: Colors.deepOrange,
                  loadingAnimation: 'assets/loading_circle.json',
                  steps: const [
                    EasyStep(
                      icon: Icon(Icons.add_task_rounded),
                      title: 'Form Placed',
                    ),
                    EasyStep(
                      icon: Icon(Icons.category_rounded),
                      title: 'Payment',
                    ),
                    EasyStep(
                      finishIcon: Icon(Icons.done),
                      activeIcon: Icon(Icons.done),
                      icon: Icon(Icons.local_shipping_rounded),
                      title: 'Completed',
                    ),
                  ],
                  onStepReached: (index) => setState(() => activeStep = index),
                ),
                checkConditionApi(),
              ],
            ),
    );
  }

  checkConditionApi() {
    switch (activeStep) {
      case 0:
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputDecorator(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    border: OutlineInputBorder(gapPadding: 2.0)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField(
                    validator: (value) {
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      labelText: "Plan Size",
                    ),
                    value: sizeValue,
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.arrow_drop_down_rounded),
                    ),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (newValue) {
                      sizeValue = newValue;

                      quantityForm.clear();
                      pagesinput.clear();
                      setState(() {});
                    },
                    items: sizeDisplay.map((value) {
                      return DropdownMenuItem<SizeDisplay>(
                        value: value,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "${value.sizeName} , RM ${value.price.toStringAsFixed(2)}",
                              maxLines: 1,
                              // minFontSize: txtsize - 5,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textCapitalization: TextCapitalization.characters,
                controller: pagesinput,
                style: const TextStyle(color: Colors.black),
                onSaved: (val) => {},
                onChanged: (value) {
                  quantityForm.clear();
                },
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  label: Text("Pages", style: TextStyle(fontSize: 16)),
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
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textCapitalization: TextCapitalization.characters,
                controller: quantityForm,
                style: const TextStyle(color: Colors.black),
                onSaved: (val) => {},
                onChanged: (value) {
                  try {
                    price =
                        (sizeValue.price * double.parse(quantityForm.text)) *
                            double.parse(pagesinput.text);
                  } catch (e) {
                    price = 0.00;
                  }
                },
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  label: Text("Quantity", style: TextStyle(fontSize: 16)),
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
              TextFormField(
                focusNode: AlwaysDisabledFocusNode(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textCapitalization: TextCapitalization.characters,
                controller: dateinput,
                style: const TextStyle(color: Colors.black),
                onTap: () {
                  _selectDate(context);
                },
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  label: Text("Date", style: TextStyle(fontSize: 16)),
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
              TextFormField(
                focusNode: AlwaysDisabledFocusNode(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textCapitalization: TextCapitalization.characters,
                controller: timeinput,
                style: const TextStyle(color: Colors.black),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  );

                  if (pickedTime != null) {
                    print(pickedTime.format(context)); //output 10:51 PM
                    final now = DateTime.now();
                    DateTime parsedTime = DateTime(now.year, now.month, now.day,
                        pickedTime.hour, pickedTime.minute);
                    //converting to DateTime so that we can further format on different pattern.
                    print(parsedTime); //output 1970-01-01 22:53:00.000
                    String formattedTime =
                        DateFormat('HH:mm:ss').format(parsedTime);
                    print(formattedTime); //output 14:59:00
                    //DateFormat() is from intl package, you can format the time on any pattern you need.

                    setState(() {
                      timeinput.text =
                          formattedTime; //set the value of text field.
                      timeApi = DateFormat('yyyy-MM-dd HH:mm:ss').format(
                          DateTime(
                              _selectedDate!.year,
                              _selectedDate!.month,
                              _selectedDate!.day,
                              pickedTime.hour,
                              pickedTime.minute));
                    });
                  } else {
                    print("Time is not selected");
                  }
                },
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  label: Text("Time", style: TextStyle(fontSize: 16)),
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 12, top: 10),
                          child: Text(
                            "File",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 12, top: 10),
                          child: InkWell(
                            onTap: () {
                              _openFileUpload(false);
                            },
                            child: Icon(Icons.add_box_rounded),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    showImageFile.isEmpty
                        ? SizedBox()
                        : Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 0, left: 5),
                            height: 150,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: showImageFile
                                    .asMap()
                                    .entries
                                    .map((element) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        // switch (typeOfExtension[element.key]) {
                                        //   case "docx":
                                        //     OpenFilex.open(element.value.path);
                                        //     break;
                                        //   case "doc":
                                        //     OpenFilex.open(element.value.path);
                                        //     break;
                                        //   case "xls":
                                        //     OpenFilex.open(element.value.path);
                                        //     break;
                                        //   case "xlsx":
                                        //     OpenFilex.open(element.value.path);
                                        //     break;
                                        //   case "csv":
                                        //     OpenFilex.open(element.value.path);
                                        //     break;
                                        //   default:
                                        //     PersistentNavBarNavigator
                                        //         .pushDynamicScreen(context,
                                        //             screen: PreviewImage(
                                        //                 dataView: element.value,
                                        //                 typeOfImage:
                                        //                     typeOfExtension[
                                        //                         element.key]),
                                        //             withNavBar: false);
                                        // }
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(1),
                                            ),
                                            width: 100,
                                            height: 100,
                                            child: Center(
                                                child: Text(
                                                    "File ${fileName[element.key]}")),
                                          ),
                                          Positioned(
                                            right: 5,
                                            top: 0,
                                            child: InkWell(
                                                onTap: () {
                                                  showImageFile
                                                      .removeAt(element.key);
                                                  imageWithBase64
                                                      .removeAt(element.key);
                                                  typeOfExtension
                                                      .removeAt(element.key);
                                                  fileName
                                                      .removeAt(element.key);
                                                  setState(() {});
                                                },
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList()),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    const Text(
                      "Price : ",
                      style: headlineDot,
                    ),
                    Text(
                      " RM${price.toStringAsFixed(2)}",
                      style: headlineDotRed,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: Mainbutton(
                      onTap: () {
                        if (sizeValue == null) {
                          toastToUser(msg: "Please choose plan size");
                          return;
                        }
                        if (pagesinput.text == "") {
                          toastToUser(msg: "Please fill pages field");
                          return;
                        }
                        if (quantityForm.text == "") {
                          toastToUser(msg: "Please fill quantity field");
                          return;
                        }
                        if (dateinput.text == "") {
                          toastToUser(msg: "Please fill date field");
                          return;
                        }
                        if (timeinput.text == "") {
                          toastToUser(msg: "Please fill time field");
                          return;
                        }
                        if (fileName.isEmpty) {
                          toastToUser(msg: "Please upload the pdf");
                          return;
                        }
                        activeStep = 1;
                        paymentinput.text = "RM ${price.toStringAsFixed(2)}";
                        setState(() {});
                      },
                      text: 'Proceed',
                      btnColor: blueButton,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case 1:
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // InputDecorator(
              //   decoration: const InputDecoration(
              //       contentPadding: EdgeInsets.only(left: 10),
              //       border: OutlineInputBorder(gapPadding: 2.0)),
              //   child: DropdownButtonHideUnderline(
              //     child: DropdownButtonFormField<String>(
              //       validator: (value) {
              //         return null;
              //       },
              //       value: selectBank,
              //       decoration: const InputDecoration(
              //         labelStyle: TextStyle(
              //           color: Colors.black,
              //           fontSize: 16,
              //         ),
              //         enabledBorder: UnderlineInputBorder(
              //             borderSide: BorderSide(color: Colors.white)),
              //         labelText: "Select Bank",
              //       ),
              //       icon: const Padding(
              //         padding: EdgeInsets.only(right: 10),
              //         child: Icon(Icons.arrow_drop_down_rounded),
              //       ),
              //       iconSize: 24,
              //       elevation: 16,
              //       onChanged: (newValue) {},
              //       items: <String>[
              //         'Maybank',
              //         'CIMB',
              //         'Hong Leong',
              //         'RHB Bank',
              //         'Affin Bank'
              //       ].map<DropdownMenuItem<String>>((String value) {
              //         return DropdownMenuItem<String>(
              //           value: value,
              //           child: SizedBox(
              //             width: MediaQuery.of(context).size.width * 0.6,
              //             child: Padding(
              //               padding: const EdgeInsets.only(left: 10),
              //               child: Text(
              //                 value,
              //                 maxLines: 1,
              //                 // minFontSize: txtsize - 5,
              //                 style: const TextStyle(fontSize: 16),
              //               ),
              //             ),
              //           ),
              //         );
              //       }).toList(),
              //     ),
              //   ),
              // ),
              //  const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textCapitalization: TextCapitalization.characters,
                controller: paymentinput,
                readOnly: true,
                style: const TextStyle(color: Colors.black),
                onSaved: (val) => {},
                onChanged: (value) {},
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  label: Text("Payment (RM)", style: TextStyle(fontSize: 16)),
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 12, top: 10),
                          child: Text(
                            "Receipt of payment",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 12, top: 10),
                          child: InkWell(
                            onTap: () {
                              _openFileUpload(true);
                            },
                            child: Icon(Icons.add_box_rounded),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    showImageFilePayment.isEmpty
                        ? SizedBox()
                        : Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 0, left: 5),
                            height: 150,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: showImageFilePayment
                                    .asMap()
                                    .entries
                                    .map((element) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        // switch (typeOfExtension[element.key]) {
                                        //   case "docx":
                                        //     OpenFilex.open(element.value.path);
                                        //     break;
                                        //   case "doc":
                                        //     OpenFilex.open(element.value.path);
                                        //     break;
                                        //   case "xls":
                                        //     OpenFilex.open(element.value.path);
                                        //     break;
                                        //   case "xlsx":
                                        //     OpenFilex.open(element.value.path);
                                        //     break;
                                        //   case "csv":
                                        //     OpenFilex.open(element.value.path);
                                        //     break;
                                        //   default:
                                        //     PersistentNavBarNavigator
                                        //         .pushDynamicScreen(context,
                                        //             screen: PreviewImage(
                                        //                 dataView: element.value,
                                        //                 typeOfImage:
                                        //                     typeOfExtension[
                                        //                         element.key]),
                                        //             withNavBar: false);
                                        // }
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(1),
                                            ),
                                            width: 100,
                                            height: 100,
                                            child: Center(
                                                child: Text(
                                                    "File ${fileNamePayment[element.key]}")),
                                          ),
                                          Positioned(
                                            right: 5,
                                            top: 0,
                                            child: InkWell(
                                                onTap: () {
                                                  showImageFilePayment
                                                      .removeAt(element.key);
                                                  imageWithBase64Payment
                                                      .removeAt(element.key);
                                                  typeOfExtensionPayment
                                                      .removeAt(element.key);
                                                  fileNamePayment
                                                      .removeAt(element.key);
                                                  setState(() {});
                                                },
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList()),
                          ),
                  ],
                ),
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       flex: 5,
              //       child: InkWell(
              //         onTap: () {
              //           payment = 1;
              //           setState(() {});
              //         },
              //         child: Container(
              //           width: double.infinity,
              //           decoration: BoxDecoration(
              //             color: payment == 1 ? Colors.grey : Colors.white,
              //             border: Border.all(width: 0.5),
              //             borderRadius:
              //                 const BorderRadius.all(Radius.circular(5.0)),
              //           ),
              //           height: 100,
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             children: [
              //               Image.asset(
              //                 "assets/check.png",
              //                 height: 50,
              //               ),
              //               const Text(
              //                 "Success Payment",
              //                 style: headline2,
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 30),
              //     Expanded(
              //       flex: 5,
              //       child: InkWell(
              //         onTap: () {
              //           payment = 2;
              //           setState(() {});
              //         },
              //         child: Container(
              //           decoration: BoxDecoration(
              //             color: payment == 2 ? Colors.grey : Colors.white,
              //             border: Border.all(width: 0.5),
              //             borderRadius:
              //                 const BorderRadius.all(Radius.circular(5.0)),
              //           ),
              //           width: double.infinity,
              //           height: 100,
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             children: [
              //               Image.asset(
              //                 "assets/cancel.png",
              //                 height: 50,
              //               ),
              //               const Text("Fail Payment", style: headline2),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: Mainbutton(
                      onTap: () {
                        if (fileNamePayment.isEmpty) {
                          toastToUser(
                              msg: "Please upload the receipt of payment");
                          return;
                        }
                        // if (payment == 0) {
                        //   toastToUser(msg: "Please choose payment status");
                        //   return;
                        // }
                        activeStep = 2;
                        setState(() {});
                        callApiPayment();
                      },
                      text: 'Submit',
                      btnColor: blueButton,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      default:
        return Column(
          children: [
            payment == 1
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text("Your Order ID : $displayOrderID", style: headline2),
                      Image.asset(
                        "assets/check.png",
                        height: 100,
                      ),
                      const SizedBox(height: 10),
                      const Text("Payment Succeed. Thank you",
                          style: headline2),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/cancel.png",
                        height: 100,
                      ),
                      const SizedBox(height: 10),
                      const Text("Failed to made payment. Please try again",
                          style: headline2),
                    ],
                  ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 50,
                  width: 150,
                  child: Mainbutton(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    text: 'Back',
                    btnColor: blueButton,
                  ),
                ),
              ],
            ),
          ],
        );
    }
  }

  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext? context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      dateinput
        ..text = DateFormat.yMMMd().format(_selectedDate!)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateinput.text.length, affinity: TextAffinity.upstream));
      timeinput.clear();
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
