import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uniitech_test/OTPVerification.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _isPhoneValid = false;

  Future<void> _showMyDialog(BuildContext context,String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('กรุณากรอกข้อมูลใหม่'),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _phoneControllerListener() {
    setState(() {
      _isPhoneValid = _phoneController.text.isNotEmpty &&
          _phoneController.text.length == 10 &&
          int.tryParse(_phoneController.text) != null;
    });
  }
  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_phoneControllerListener);
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
        backgroundColor: Color(0xFF1B6C7F),
        title: Text('Login / Sign Up'),
        centerTitle: true,
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
                  "Creating new account",
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
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Phone number',
                              ),
                            ),
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name ',
                                hintText: 'กรุณากรอกชื่อเเละนามสกุล "สมหมาย ปลายฟ้า"',
                              ),
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                            ), //ใส่ชื่อและนามสกุล โดยใช้เว้นวรรค
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.words,
                            ),
                            SizedBox(height: 16.0),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          'By clicking Sign Up button you accept to following ',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: 'Terms of Use',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed:  _isPhoneValid ? () async {
                                var payload = {
                                  "phone_number": _phoneController.text,
                                  "country_code": "+66",
                                  "name": (_nameController.text
                                      .split(' '))[0], //ไม่น้อยกว่า3อักษร
                                  "lastname":
                                      (_nameController.text.split(' '))[1],
                                  "email": _emailController.text
                                };
                                print("payload ==> $payload");
                                var response = await http.post(
                                    Uri.parse(
                                        'https://api.bnc-core.com/signup'),
                                    headers: <String, String>{
                                      'Accept': 'application/json',
                                      'Content-Type':
                                          'application/json; charset=UTF-8',
                                      'Content-Language': 'en_US'
                                    },
                                    body: json.encode(payload));
                                var jsonResponse = json.decode(response.body);
                                if (jsonResponse['message'] == "success") {
                                  Navigator.push(context,MaterialPageRoute(builder: (context) => OTPVerification(phoneController:_phoneController.text)));
                                } 
                                else {
                                  _showMyDialog(context,jsonResponse['name'] !=null ? jsonResponse['name'].toString() : jsonResponse['phone_number'] !=null ? jsonResponse['phone_number'].toString() : jsonResponse['email'].toString());
                                }
                              }: null,
                              child: Text('Accept and Sign Up'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF22A0A7),
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
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
