import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:uniitech_test/HomeView.dart';

class OTPVerification extends StatefulWidget {
  const OTPVerification({Key? key, required this.phoneController})
      : super(key: key);

  final String phoneController;

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _OTPController = TextEditingController();
  late String phoneController;
  late String api_key;
  int _counter = 120;

  Future<void> sendOTP() async {
    try {
      var payload = {"phone_number": phoneController, "country_code": "+66"};
      print("payload ==> $payload");

      var response = await http.post(
        Uri.parse('https://api.bnc-core.com/otp/resend?time=12312'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Content-Language': 'en_US'
        },
        body: json.encode(payload),
      );

      var jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        print("OTP Pass");
      }
    } catch (e) {
      print("error ==> $e");
    }
  }

  verifyOTP(String OTP) async {
    try {
      print(OTP);
      var payload = {
        "phone_number": phoneController,
        "country_code": "+66",
        "otp": OTP
      };
      print("payload ==> $payload");

      var response = await http.post(
        Uri.parse('https://api.bnc-core.com/otp/verify'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(payload),
      );

      var jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          api_key = jsonResponse['api_key'];
        });
        return api_key;
      }
    } catch (e) {
      print("error ==> $e");
    }
  }

  void _startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else if (_counter == 0) {
          timer.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    phoneController = widget.phoneController;
    sendOTP();
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Login / Sign Up'),
        centerTitle: true,
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
                  "Phone number verification",
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
                            Text("Enter OTP password sent to $phoneController"),
                            TextField(
                              controller: _OTPController,
                              keyboardType: TextInputType.phone,
                            ),
                            SizedBox(height: 16.0),
                            TextButton(
                              onPressed: () {
                                _counter = 120;
                                sendOTP();
                                _startCountdown();
                              },
                              child: Text(
                                'Did not receive OTP?',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await verifyOTP(_OTPController.text);
                                print(api_key);
                                if (api_key != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Home(api_key: api_key)));
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(90, 0, 90, 0),
                                child: Text('Login'),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF22A0A7),
                              ),
                            ),
                            Text('Retry in $_counter sec')
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
