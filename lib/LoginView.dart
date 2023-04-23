import 'dart:convert';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:uniitech_test/OTPVerification.dart';
import 'package:uniitech_test/RegisterView.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _phoneController = TextEditingController();
  bool _isPhoneValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_phoneControllerListener);
  }

  @override

  void _phoneControllerListener() {
    setState(() {
      _isPhoneValid = _phoneController.text.isNotEmpty &&
          _phoneController.text.length == 10 &&
          int.tryParse(_phoneController.text) != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login / Sign Up'),
        centerTitle: true,
        leading: Container(),
        backgroundColor: Color(0xFF1B6C7F),
      ),
      body: Container(
        color: Color.fromRGBO(237, 246, 245, 1),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter your phone number",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              SizedBox(
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
                        offset: Offset(0, 3), 
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 40,
                                  child:Flag.fromCode(width:40,FlagsCode.TH),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child:Text('+66',style: TextStyle(color: Colors.blue),),
                                ),
                                SizedBox(
                                  width: 200,
                                  child:TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: 'Phone number',
                                    errorText: _isPhoneValid
                                        ? null
                                        : 'Please enter a valid phone number',
                                  ),
                                ),
                                )
                              ]
                            ),
                            SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: _isPhoneValid
                                  ? () async {
                                      var payload = {
                                        "phone_number": _phoneController.text,
                                        "country_code": "+66",
                                        "locale": "TH"
                                      };
                                      print("payload ==> $payload");
                                      var response = await http.post(
                                          Uri.parse(
                                              'https://api.bnc-core.com/mobile/check'),
                                          headers: <String, String>{
                                            'Accept': 'application/json',
                                            'Content-Type':
                                                'application/json; charset=UTF-8',
                                          },
                                          body: json.encode(payload));
                                      var jsonResponse =
                                          json.decode(response.body);
                                      if (response.statusCode == 200) {
                                        print(jsonResponse['route']);
                                        jsonResponse['route'] == "/signup"
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RegisterView()))
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OTPVerification(
                                                          phoneController:
                                                              _phoneController
                                                                  .text),
                                                ));
                                      }
                                    }
                                  : null,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(90, 0, 90, 0),
                                child: Text('Login'),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF22A0A7),
                              ),
                            ),
                          ])
                        )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
