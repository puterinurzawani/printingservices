import 'package:flutter/material.dart';

import '../core/text_style.dart';
import '../data/order_model.dart';
import '../provider/rest.dart';

class ViewOrder extends StatefulWidget {
  final String userId;
  ViewOrder({required this.userId});
  @override
  _ViewOrderState createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  bool isLoading = true;
  List<OrderDisplayElement> orderDisplayList = [];

  @override
  void initState() {
    getMyOrder();
    super.initState();
  }

  getMyOrder() {
    var jsons = {
      "userId": widget.userId,
      "authKey": "key123",
    };
    HttpAuth.postApi(jsons: jsons, url: 'view_order.php').then((value) {
      if (value.statusCode == 200) {
        final orderDisplay = orderDisplayFromJson(value.body);
        orderDisplayList = orderDisplay.orderDisplay;
        isLoading = false;
        setState(() {});
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
                        "View Order",
                        style: headline1,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                orderDisplayList.isEmpty
                    ? const Text("No order view")
                    : SizedBox(),
                ...orderDisplayList.map((OrderDisplayElement element) {
                  return Center(
                    child: Card(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: const BoxDecoration(
                              border: Border(
                                right:
                                    BorderSide(color: Colors.black, width: 1),
                              ),
                            ),
                            child: const Icon(Icons.inbox),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Order ID: ${element.orderId}',
                                        style: headline3,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      const Text(
                                        'Status:',
                                        style: headline3,
                                      ),
                                      conditionStatus(element.statusPrepare),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Name : ${element.username}',
                                        style: headline3,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Date: ${element.createdDate}',
                                        style: headline3,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Quantity: ${element.quantity}',
                                        style: headline3,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Total Amount',
                                        style: headline3,
                                      ),
                                      Text(
                                        'RM ${element.price.toStringAsFixed(2)}',
                                        style: headline3,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList()
              ],
            ),
    );
  }

  conditionStatus(element) {
    switch (element) {
      case 'Pending':
        return Badge(
          label: Text(
            '${element}',
            style: headline3.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        );
      case 'Preparation':
        return Badge(
          label: Text(
            '${element}',
            style: headline3.copyWith(color: Colors.black),
          ),
          backgroundColor: Colors.yellow,
        );
      default:
        return Badge(
          label: Text(
            '$element',
            style: headline3.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        );
    }
  }
}
