import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HotelDetail extends StatefulWidget {
  HotelDetail(
      {Key? key,
      required this.hotel,
      required this.checkInDate,
      required this.checkOutDate})
      : super(key: key);

  final Map<String, dynamic> hotel;
  final String checkInDate;
  final String checkOutDate;
  @override
  State<HotelDetail> createState() => _HotelDetailState();
}

class _HotelDetailState extends State<HotelDetail> {
  late var hotel;
  late String checkInDate;
  late String checkOutDate;
  dynamic _HotelDetail;
  bool isLiked = false;
  late Future<void> _initStateFuture;

  Future<void> getHotelDetail(hotel, checkInDate, checkOutDate) async {
    try {
      var response = await http.get(
        Uri.parse(
            'https://api.bnc-core.com/hotel/show/detail?hotels_id=${hotel['hotels_id']}&channel=mobile&check_in_date=$checkInDate&check_out_date=$checkOutDate'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Language': 'en_US',
        },
      );
      final json = jsonDecode(response.body);
      final results = json;
      setState(() {
        _HotelDetail = results;
      });
      print("_HotelDetail===> $_HotelDetail");
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    hotel = widget.hotel;
    checkInDate = widget.checkInDate;
    checkOutDate = widget.checkOutDate;
    _initStateFuture = getHotelDetail(hotel, checkInDate, checkOutDate);
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
                  backgroundColor: Color(0xFF1B6C7F),
                  leading: IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(hotel['hotel_name']),
                  centerTitle: true,
                ),
                body: Container(
                  color: Color.fromRGBO(237, 246, 245, 1),
                  child: Column(children: [
                    Image.network('https://img-booknea.sgp1.cdn.digitaloceanspaces.com/hotels/79ba9a3b-a8e9-47f5-b2eb-7e8dc84721c5.jpg'),
                    Row(
                      children: [
                        Expanded(
                          child: Image.network(
                              'https://img-booknea.sgp1.cdn.digitaloceanspaces.com/hotels/c32fe0d1-1f4b-4e83-aa15-b5537c08bce3.jpg'),
                        ),
                        Expanded(
                          child: Image.network(
                              'https://img-booknea.sgp1.cdn.digitaloceanspaces.com/hotels/5a2c56f2-bae1-4094-8fb9-349d5153b1f0.jpg'),
                        ),
                        Expanded(
                          child: Image.network(
                              'https://img-booknea.sgp1.cdn.digitaloceanspaces.com/hotels/45902f47-f8a4-4b11-9050-04f57d076727.jpg'),
                        ),
                        Expanded(
                          child: Image.network(
                              'https://img-booknea.sgp1.cdn.digitaloceanspaces.com/hotels/24e4fdf9-47aa-481c-9ea3-0f80723aa1d3.jpg'),
                        )
                      ],
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child:Column(children: [
                          Row(children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                              alignment: Alignment.centerLeft,
                              child: Text(_HotelDetail['hotel_name'],style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold ),), 
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                              alignment: Alignment.centerRight,
                              child: Text('${_HotelDetail['star_hotel']} Star'),  
                            )
                          ],
                        ),
                          Row(children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(16, 16, 3, 16),
                              alignment: Alignment.centerLeft,
                              child:Text(hotel['province']),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.fromLTRB(16, 16, 3, 16),
                              alignment: Alignment.centerRight,
                              child: showStarRating(double.parse(_HotelDetail['star_hotel']).toInt())   
                            )
                          ],
                        )
                        ],)                       
                    ),
                   
                   
                    Container(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                              alignment: Alignment.centerLeft,
                                child: Column(
                              children: [Text('Price Range'),
                              Text(_HotelDetail['default_price_range'],style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black))],
                              )
                            ),
                            Spacer(),
                            Container(
                              alignment: Alignment.centerRight,
                              child: IconButton(icon: isLiked
                                  ? Icon(Icons.favorite, color: Colors.pink)
                                  : Icon(Icons.favorite_border),
                              onPressed: () {
                                  setState(() {
                                    isLiked = !isLiked;
                                  });
                              },
                             )
                            ),
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Column(
                                children: [Text('Check-in'), Text(formatDateString(checkInDate),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Color(0xFF22A0A7),))],
                              )),
                              Icon(Icons.arrow_forward),
                              Expanded(
                                  child: Column(
                                children: [
                                  Text('Check-out'),
                                  Text(formatDateString(checkOutDate),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Color(0xFF22A0A7),),)
                                ],
                              )),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: ElevatedButton(
                                  onPressed: () {},
                                  child: Padding(padding:EdgeInsets.fromLTRB(16, 0, 0, 0), 
                                  child:Text('Select Rooms'),),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF22A0A7),
                                  ),
                                ),
                                )
                              )
                            ],
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                      color: Colors.white,
                      child: Column(children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [ 
                            Container(
                              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                              alignment: Alignment.centerLeft,
                              child:Row(children: [
                                Icon(Icons.stars,color:Colors.grey),
                                Text("Score/Top Facilities",style: TextStyle(fontSize: 15),)
                              ])
                            ),
                            Spacer(),
                            Container(padding: EdgeInsets.fromLTRB(0, 0, 16, 0),alignment: Alignment.centerRight,child:Icon(Icons.chevron_right))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text('popularity_score'),
                                  Text(_HotelDetail['popularity_score'],style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold),)
                                ],
                              )
                            ),
                            Expanded(
                              child: Container(
                                height: 100,
                                child: ListView.builder(
                                  itemCount: _HotelDetail['popular_facilities'].length,
                                  itemBuilder: (context, index) {
                                    final facilities =_HotelDetail['popular_facilities'][index];
                                    return Container(
                                        child: Row(children: [
                                      Icon(Icons.check),
                                      Text(facilities['caption'].replaceFirst("hotel_facility_list.", ""))
                                    ]));
                                  }
                                )
                              )
                            )
                          ],
                        ),
                      ]),
                    )
                  ]),
                ));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

Widget showStarRating(int rating) {
  return Row(
    children: List.generate(5, (index) {
      IconData iconData =
          index < rating ? Icons.star : Icons.star_border_outlined;
      return Icon(iconData, color: Colors.yellow);
    }),
  );
}
