import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoriteMarketPage extends StatefulWidget {
  @override
  _FavoriteMarketPageState createState() => _FavoriteMarketPageState();
}

class _FavoriteMarketPageState extends State<FavoriteMarketPage> {
  List<Map<String, dynamic>> favoriteMarkets = [];
  String? cookie;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
    if (isLoggedIn) {
      fetchFavoriteMarkets();
    }
  }

  Future<void> fetchFavoriteMarkets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cookie = prefs.getString('cookie');

    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/api/favorite-markets'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': cookie ?? '',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        favoriteMarkets = data.map((item) => {
          'id': item['id'],
          'name': item['name'],
        }).toList();
      });
    } else {
      throw Exception('Failed to load favorite markets');
    }
  }

  Future<void> toggleFavorite(int marketId) async {
    final url = 'http://10.0.2.2:5000/api/market-like'; // API 엔드포인트
    final headers = {
      'Content-Type': 'application/json',
      'Cookie': cookie ?? '',
    };
    final body = json.encode({'market_id': marketId});

    final response = await http.delete(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      setState(() {
        favoriteMarkets.removeWhere((market) => market['id'] == marketId);
      });
    } else {
      throw Exception('Failed to toggle favorite');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return Scaffold(
        body: Center(
          child: Text(
            '로그인 후 이용 가능합니다.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: favoriteMarkets.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/마켓3.png'), // 예시 이미지
            ),
            title: Text(
              favoriteMarkets[index]['name'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: GestureDetector(
              onTap: () {
                toggleFavorite(favoriteMarkets[index]['id']);
              },
              child: Icon(
                Icons.star,
                color: Colors.yellow[700],
              ),
            ),
            onTap: () {
              print('${favoriteMarkets[index]['name']} 클릭됨');
            },
          );
        },
      ),
    );
  }
}
