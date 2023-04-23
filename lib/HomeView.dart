import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uniitech_test/HotelSearchView.dart';
import 'package:uniitech_test/LoginView.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.api_key});

  final String api_key;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String api_key;

  Future<void> logout() async {
    try {
      var response = await http.post(
        Uri.parse('https://api.bnc-core.com/logout'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $api_key'
        },
      );

      var jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        print("logout success");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } catch (e) {
      print("error ==> $e");
    }
  }

  @override
  void initState() {
    super.initState();
    api_key = widget.api_key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.chevron_left),
          onPressed: () {Navigator.pop(context);},
        ),
        backgroundColor: Color(0xFF1B6C7F),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Logout'),
                        onPressed: () async {
                          await logout();             
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body:Container(
        color: Color.fromRGBO(237, 246, 245, 1),
        child:Center(
          child:ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HotelSearch(result: {}, api_key: api_key,),
              ));
        },
        child: Text('HotelSearch'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF22A0A7),
        ),
      ),
        )
      )
    );
  }
}
