import 'package:flutter/material.dart';
import 'package:miniproject/product_detail.dart';
import 'dart:convert';
import 'main.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _UsernameController = TextEditingController();
  var _UseridController = TextEditingController();
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
              top: 0, right: 0, left: 0,
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
                            text: '앱이름',
                            style: TextStyle(
                                letterSpacing: 1,
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            )
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        '지역 공구 커뮤니티로 신선하고 저렴하게 구매해보세요!',
                        style: TextStyle(color: Colors.white) ,)
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
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
                      )
                    ]
                ),
                margin: EdgeInsets.only(top: 120, left: 30, right: 30),
                padding: EdgeInsets.only(top: 10, bottom: 0, left: 24, right: 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(child: Text("아이디, 비밀번호를 입력해주세요.", style: TextStyle(fontWeight: FontWeight.bold),), margin: EdgeInsets.all(20)),
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
                            borderSide: BorderSide(color: Color(0xFF76A9E6),),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      TextField(
                        controller: _UseridController,
                        decoration: InputDecoration(labelText: '비밀번호',
                            labelStyle: TextStyle(
                              color: Colors.grey.shade800, // 기본 라벨 색상
                            ),
                            floatingLabelStyle: TextStyle(
                              color: Colors.grey.shade800, // 포커스 상태의 라벨 색상
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF76A9E6)),)
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
                        child: Text('로그인', style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
    );
  }
}