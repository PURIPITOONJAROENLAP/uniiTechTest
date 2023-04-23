import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uniitech_test/HotelSearchView.dart';

class LocationSelection extends StatefulWidget {
  const LocationSelection({super.key, required this.api_key});
  final String api_key;

  @override
  _LocationSelectionState createState() => _LocationSelectionState();
}

class _LocationSelectionState extends State<LocationSelection> {
  List<dynamic> _locations = [];
  late String api_key;
  TextEditingController _searchController = TextEditingController();
  late String keySearch = "";
  @override
  void initState() {
    super.initState();
    api_key = widget.api_key;
    _getLocation();
    _searchController.addListener(_searchControllerListener);
  }

  void _searchControllerListener() {
    setState(() {
      _searchController.text != null
          ? keySearch = _searchController.text
          : keySearch = "";
    });
    print('keySearch ==> $keySearch');
  }

  Future<void> _getLocation() async {
    try {
      var response = await http.get(
        Uri.parse(
            'https://api.bnc-core.com/hotel/location?longitude=12345&latitude=12345'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Language': 'en_US',
          'Authorization': 'Bearer $api_key'
        },
      );
      final json = jsonDecode(response.body);
      final results = json['data'];
      setState(() {
        _locations = results;
        print("_locations ==> $_locations");
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xFF1B6C7F),
            title: const Center(child: Text('Stays'))),
        body: Container(
            color: Color.fromRGBO(237, 246, 245, 1),
            child: Column(
              children: [
                Container(
                    height: 60,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 25, 0, 0),
                      child: Text(
                        "Select stay location",
                        textAlign: TextAlign.start,
                      ),
                    )),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.1,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search...',
                      ),
                    )),
                Expanded(
                  child: ListView.builder(
                    itemCount: _locations.length,
                    itemBuilder: (context, index) {
                      final location = _locations[index];
                      print('location keySearch ==> $keySearch');
                      if (location['name'].toLowerCase().contains(keySearch.toLowerCase())) {
                        return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.1,
                              ),
                            ),
                            child: ListTile(
                              onTap: () {
                                var payload = {
                                  'id': location['id'],
                                  'name': location['name'],
                                  'active_hotels': location['active_hotels'],
                                  'latitude': location['latitude'],
                                  'longitude': location['longitude'],
                                  'country': location['country'],
                                };
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HotelSearch(
                                        result: payload,
                                        api_key: api_key,
                                      ),
                                    ));
                              },
                              leading: location['name'] == "Near by"
                                  ? Icon(Icons.loupe_rounded)
                                  : location['name'] == "Favorite Property"
                                      ? Icon(Icons.favorite, color: Colors.red)
                                      : Icon(Icons.location_on),
                              title: Text(location['name']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(location['country']),
                                ],
                              ),
                            ));
                      } else {
                        return Container();
                      }
                    },
                  ),
                )
              ],
            )));
  }
}
