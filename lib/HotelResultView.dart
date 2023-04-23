import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uniitech_test/HotelDetailView.dart';

class HotelResultView extends StatefulWidget {
  HotelResultView(
      {Key? key,
      required this.location,
      required this.checkInDate,
      required this.checkOutDate})
      : super(key: key);

  final Map<String, dynamic> location;
  final String checkInDate;
  final String checkOutDate;
  @override
  _HotelResultViewState createState() => _HotelResultViewState();
}

class _HotelResultViewState extends State<HotelResultView> {
  List<dynamic> _HotelList = [];
  late var location;
  late String checkInDate;
  late String checkOutDate;
  late Future<void> _initStateFuture;
  bool isFavourite = false;

  Future<void> getHotelResult(location, checkInDate, checkOutDate) async {
    try {
      checkInDate = checkInDate.toString().split(" ")[0];
      checkOutDate = checkOutDate.toString().split(" ")[0];
      var response = await http.get(
        Uri.parse(
            'https://api.bnc-core.com/hotel/searching?latitude=${location['latitude']}&longitude=${location['longitude']}&provinces_id=${location['id']}&channel=mobile&check_in_date=$checkInDate&check_out_date=$checkOutDate&sdfsdf=sdf'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Language': 'en_US',
        },
      );
      final json = jsonDecode(response.body);
      final results = json['data'];
      setState(() {
        _HotelList = results;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    location = widget.location;
    checkInDate = widget.checkInDate;
    checkOutDate = widget.checkOutDate;
    print("HotelResultView_location >> $location");
    print("HotelResultView_checkInDate >> $checkInDate");
    print("HotelResultView_checkOutDate >> $checkOutDate");
    _initStateFuture = getHotelResult(location, checkInDate, checkOutDate);
  }

  String formatDateString(String dateString) {
    final DateTime date = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat('d/MMM');
    final String formattedDate = formatter.format(date);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initStateFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  backgroundColor: Color(0xFF1B6C7F),
                  title: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 15,
                      ),
                      Text(
                        location['name'],
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  centerTitle: true,
                  actions: [
                    Container(
                        height: double.infinity,
                        padding: EdgeInsets.fromLTRB(0, 20, 16, 0),
                        child: Text(
                            '${formatDateString(checkInDate)} - ${formatDateString(checkOutDate)}',
                            textAlign: TextAlign.end))
                  ],
                ),
                body: Container(
                    color: Color.fromRGBO(237, 246, 245, 1),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text("${_HotelList.length} properties",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
                              ),
                              Spacer(),
                              Container(child: Icon(Icons.filter_list, size: 30))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                          child: ListView.builder(
                            itemCount: _HotelList.length,
                            itemBuilder: (context, index) {
                              final hotel = _HotelList[index];
                              return Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HotelDetail(
                                                          hotel: hotel,
                                                          checkInDate:
                                                              checkInDate,
                                                          checkOutDate:
                                                              checkOutDate)));
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                    width: double.infinity,
                                                    child: Column(children: [
                                                      Text(hotel['hotel_name'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20)),
                                                      Text(
                                                          "${hotel['province']}-${hotel['city_center_distance']}"),
                                                    ])),
                                                Row(
                                                  children: [
                                                    Container(
                                                      alignment: Alignment.centerLeft,
                                                      child:Row(children: [
                                                        Container(
                                                          width: 40,
                                                            decoration:
                                                              BoxDecoration(
                                                                color:const Color.fromARGB(255, 221,211,211),
                                                                borderRadius:BorderRadius.circular(16.0),
                                                            ),
                                                            child: InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  isFavourite =
                                                                      !isFavourite;
                                                                });
                                                              },
                                                              child: Icon(
                                                                isFavourite
                                                                    ? Icons.favorite
                                                                    : Icons.favorite_border,
                                                                color: isFavourite
                                                                    ? Colors.red
                                                                    : null,
                                                              ),
                                                            )),
                                                        Container(
                                                          width: 70,
                                                          decoration:
                                                            BoxDecoration(
                                                              color: const Color.fromARGB(255,221,211, 211),
                                                              borderRadius:BorderRadius.circular(16.0),
                                                            ),
                                                          child: InkWell(
                                                            onTap: () {},
                                                            child: Row(
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                                                  child:Row(children: [    
                                                                    Icon(Icons.message_outlined,color: Color(0xFF22A0A7),),
                                                                    Text('${hotel['reviews']}'),
                                                                  ])
                                                                )
                                                              ],
                                                            )
                                                          )
                                                    ),
                                                      ],)
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      alignment: Alignment.centerRight,
                                                      child:Text(hotel['default_price_range'],textAlign: TextAlign.right),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )),
                                      )));
                            },
                          ),
                        ))
                      ],
                    )));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

class HotelResultPage extends StatefulWidget {
  const HotelResultPage({Key? key, required this.location}) : super(key: key);
  final Map<String, dynamic> location;

  @override
  State<HotelResultPage> createState() => _HotelResultPageState();
}

class _HotelResultPageState extends State<HotelResultPage> {
  var location;

  void initState() {
    super.initState();
    location = widget.location;
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final checkInDate = arguments[0];
    final checkOutDate = arguments[1];
    String checkInDateNew =
        DateFormat('yyyy-MM-dd').format(checkInDate).toString();
    String checkOutDateNew =
        DateFormat('yyyy-MM-dd').format(checkOutDate).toString();
    return HotelResultView(
        location: widget.location,
        checkInDate: checkInDateNew,
        checkOutDate: checkOutDateNew);
  }
}
