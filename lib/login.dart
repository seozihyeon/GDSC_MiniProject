import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _UsernameController = TextEditingController();
  var _PasswordController = TextEditingController();
  dynamic userInfo = '';

  @override
  void initState() {
    super.initState();
    _resetLoginStatus();
  }

  Future<void> _resetLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> login() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'ID': _UsernameController.text,
          'password': _PasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          userInfo = jsonDecode(response.body);
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        prefs.setString('userInfo', jsonEncode(userInfo));

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
              (route) => false,
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('로그인 실패'),
              content: Text('올바른 아이디와 비밀번호를 입력해주세요'),
              actions: <Widget>[
                TextButton(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("Error: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('오류'),
            content: Text('로그인 요청 중 오류가 발생했습니다.'),
            actions: <Widget>[
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
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
                        text: '게더위시',
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
                      '지역 공구 커뮤니티로 신선하고 저렴하게 구매해보세요!',
                      style: TextStyle(color: Colors.white),
                    )
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
                        "아이디, 비밀번호를 입력해주세요.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      margin: EdgeInsets.all(20),
                    ),
                    TextField(
                      controller: _UsernameController,
                      decoration: InputDecoration(
                        labelText: '아이디',
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
                          borderSide: BorderSide(color: Color(0xFF76A9E6)),
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '계정이 아직 없으신가요?',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => SignupPage()),
                                  (route) => false,
                            );
                          },
                          child: Text(
                            '회원가입',
                            style: TextStyle(
                              color: Color(0xFF76A9E6),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: login,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.black54),
                      ),
                      child: Text('로그인', style: TextStyle(color: Colors.white)),
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
