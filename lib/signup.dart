import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var _UsernameController = TextEditingController();
  var _UseridController = TextEditingController();
  var _PasswordController = TextEditingController();
  var _NeighborhoodController = TextEditingController();
  var _AddressController = TextEditingController();
  var _PhoneNumberController = TextEditingController();
  dynamic userInfo = '';

  Future<void> signup() async {
    try {
      print("Sending request to server...");
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': _UsernameController.text,
          'identification': _UseridController.text,
          'password': _PasswordController.text,
          'dong_name': _NeighborhoodController.text,
          'address': _AddressController.text,
          'phone': _PhoneNumberController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          userInfo = jsonDecode(response.body);
        });
        _showSignupSuccessDialog();
      } else {
        print('Failed to create user: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to create user');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void _showSignupSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('회원가입 완료'),
          content: Text('환영합니다!'),
          actions: <Widget>[
            TextButton(
              child: Text('로그인하러가기'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF76A9E6),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
                  (route) => false,
            );
          },
          child: Icon(Icons.close),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Color(0xFF76A9E6),
            height: 200,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(top: 40, left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '회원가입',
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '회원이 되어 게더위시의 다양한 서비스를 경험해보세요!',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 150, bottom: 20),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 15,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            "회원 정보를 입력해주세요.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          margin: EdgeInsets.all(20),
                        ),
                        TextField(
                          controller: _UsernameController,
                          decoration: InputDecoration(
                            labelText: '성명',
                            labelStyle: TextStyle(
                              color: Colors.grey.shade800, // 기본 라벨 색상
                            ),
                            floatingLabelStyle: TextStyle(
                              color: Colors.grey.shade800, // 포커스 상태의 라벨 색상
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF76A9E6),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        TextField(
                          controller: _UseridController,
                          decoration: InputDecoration(
                            labelText: '아이디',
                            labelStyle: TextStyle(
                              color: Colors.grey.shade800, // 기본 라벨 색상
                            ),
                            floatingLabelStyle: TextStyle(
                              color: Colors.grey.shade800, // 포커스 상태의 라벨 색상
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF76A9E6)),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        TextField(
                          controller: _PasswordController,
                          decoration: InputDecoration(
                            labelText: '비밀번호',
                            labelStyle: TextStyle(
                              color: Colors.grey.shade800, // 기본 라벨 색상
                            ),
                            floatingLabelStyle: TextStyle(
                              color: Colors.grey.shade800, // 포커스 상태의 라벨 색상
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF76A9E6),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        TextField(
                          controller: _NeighborhoodController,
                          decoration: InputDecoration(
                            labelText: '우리 동네',
                            labelStyle: TextStyle(
                              color: Colors.grey.shade800, // 기본 라벨 색상
                            ),
                            floatingLabelStyle: TextStyle(
                              color: Colors.grey.shade800, // 포커스 상태의 라벨 색상
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF76A9E6),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        TextField(
                          controller: _AddressController,
                          decoration: InputDecoration(
                            labelText: '주소',
                            labelStyle: TextStyle(
                              color: Colors.grey.shade800, // 기본 라벨 색상
                            ),
                            floatingLabelStyle: TextStyle(
                              color: Colors.grey.shade800, // 포커스 상태의 라벨 색상
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF76A9E6),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        TextField(
                          controller: _PhoneNumberController,
                          decoration: InputDecoration(
                            labelText: '휴대폰 번호',
                            labelStyle: TextStyle(
                              color: Colors.grey.shade800, // 기본 라벨 색상
                            ),
                            floatingLabelStyle: TextStyle(
                              color: Colors.grey.shade800, // 포커스 상태의 라벨 색상
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF76A9E6),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: signup,
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black54),
                          ),
                          child: Text('회원가입', style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
