import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:uniitech_test/LocationSelectionView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'HotelResultView.dart';

class HotelSearch extends StatefulWidget {
  const HotelSearch({Key? key, required this.result, required this.api_key})
      : super(key: key);

  final Map<String, dynamic> result;
  final String api_key;

  @override
  State<HotelSearch> createState() => _HotelSearchState();
}

class _HotelSearchState extends State<HotelSearch> {
  String location = 'Near by';
  late String api_key;
  var result;
  int totalDay = 0;
  DateTime? checkInDate = DateTime.now();
  DateTime? checkOutDate = DateTime.now().add(const Duration(days: 1));
  bool CheckedLocation = true;
  bool CheckedProperty = false;
  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? pickedIn = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (pickedIn != null &&
        pickedIn != checkInDate &&
        pickedIn.isBefore(checkOutDate!)) {
      setState(() {
        checkInDate = pickedIn;
      });
    }
    totalDay = checkOutDate!.difference(checkInDate!).inDays;
    print("checkInDate==> $checkInDate");
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime(2101));
    if (picked != null &&
        picked != checkOutDate &&
        picked.isAfter(checkInDate!)) {
      setState(() {
        checkOutDate = picked;
      });
    }
    totalDay = checkOutDate!.difference(checkInDate!).inDays;
    print("checkOutDate==> $checkOutDate");
  }

  @override
  void initState() {
    super.initState();
    api_key = widget.api_key;
    result = widget.result;
    totalDay = checkOutDate!.difference(checkInDate!).inDays;
  }

  void Location() {
    setState(() {
      CheckedLocation = true;
      CheckedProperty = false;
    });
  }

  void Property() {
    setState(() {
      CheckedLocation = false;
      CheckedProperty = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stays'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFF1B6C7F),
      ),
      body: Container(
        color: Color.fromRGBO(237, 246, 245, 1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Select find option and date",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), 
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(children: [
                            Container(
                                width: double.infinity,
                                child: Text(
                                  "Find place to stay by:",
                                  textAlign: TextAlign.left,
                                )),
                            const SizedBox(height: 16.0),
                            Row(children: [
                              Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: CheckedLocation
                                        ? Color(0xFF22A0A7)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: InkWell(
                                      onTap: Location,
                                      child: Row(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Row(
                                                children: [
                                                  CheckedLocation
                                                      ? Icon(Icons.check,
                                                          color: Colors.white)
                                                      : Icon(Icons.check,
                                                          color: Colors.white),
                                                  Text('Location'),
                                                ],
                                              ))
                                        ],
                                      ))),
                              const SizedBox(
                                width: 30,
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                    color: CheckedProperty
                                        ? Color(0xFF22A0A7)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: InkWell(
                                      onTap: Property,
                                      child: Row(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Row(
                                                children: [
                                                  CheckedProperty
                                                      ? Icon(Icons.check,
                                                          color: Colors.white)
                                                      : Icon(Icons.check,
                                                          color: Colors.white),
                                                  Text('Property Name'),
                                                ],
                                              ))
                                        ],
                                      ))),
                            ]),
                            const SizedBox(height: 16.0),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LocationSelection(
                                                      api_key: api_key)));
                                    },
                                    child: Row(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Container(
                                                width: 290,
                                                child: Row(children: [
                                                  Expanded(
                                                      child: Text(
                                                    result["name"] ?? location,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    textAlign: TextAlign.left,
                                                  )),
                                                  Expanded(
                                                      child: Center(
                                                          child: Icon(
                                                              Icons.location_on,
                                                              color: Color(
                                                                  0xFF22A0A7))))
                                                ])))
                                      ],
                                    ),
                                  )),
                            ),
                            const SizedBox(height: 16.0),
                            Center(
                              child: Row(
                                children: [
                                  const Expanded(child: Text("Check-in Date")),
                                  Expanded(
                                      child: Text(
                                    "($totalDay night)",
                                    textAlign: TextAlign.center,
                                  )),
                                  const Expanded(child: Text("Check-out Date"))
                                ],
                              ),
                            ),
                            Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                            onTap: () async {
                                              _selectCheckInDate(context);
                                            },
                                            child: Container(
                                              child: Text(
                                                checkInDate == null
                                                    ? 'Check In Date'
                                                    : '${checkInDate!.day}-${checkInDate!.month}-${checkInDate!.year}',
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            )),
                                      ),
                                      const Expanded(
                                          child: Icon(
                                        Icons.calendar_month_rounded,
                                        color: Color(0xFF22A0A7),
                                      )),
                                      Expanded(
                                        child: InkWell(
                                            onTap: () async {
                                              _selectCheckOutDate(context);
                                            },
                                            child: Container(
                                              child: Text(
                                                checkOutDate == null
                                                    ? 'Check Out Date'
                                                    : '${checkOutDate!.day}-${checkOutDate!.month}-${checkOutDate!.year}',
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                )),
                            const SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                print('result==>${result['name']}');
                                result['name'] == "Near by" ||
                                        result['name'] == "Favorite Property"
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Error'),
                                            content:
                                                Text('Select New location'),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HotelResultPage(location: result),
                                          settings: RouteSettings(
                                            arguments: [
                                              checkInDate,
                                              checkOutDate
                                            ],
                                          ),
                                        ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF22A0A7),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              child: const Text('Search'),
                            ),
                          ]))
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
