import 'package:flutter/material.dart';
import 'package:miniproject/product_detail.dart';
import 'dart:convert';
import 'main.dart';

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
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 270,
              decoration: BoxDecoration(
                color: Color(0xFF76A9E6),
              ),
              child: Container(
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
          ),
          Positioned(
            top: 120,
            left: 30,
            right: 30,
            child: Container(
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
              padding: EdgeInsets.only(top: 10, bottom: 0, left: 24, right: 24),
              child: SingleChildScrollView(
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
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                              (route) => false,
                        );
                      },
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
            ),
          ),
        ],
      ),
    );
  }
}
