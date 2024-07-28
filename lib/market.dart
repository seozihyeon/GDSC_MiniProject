import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'favorite_market.dart';

class MarketScreen extends StatefulWidget {
  final Color customBlue;

  MarketScreen({required this.customBlue});

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  List<Map<String, dynamic>> stores = [];
  bool isLoggedIn = false;

  final String defaultProfileImage = 'assets/images/마켓3.png';
  final List<String> defaultProductImages = [
    'assets/images/사과.png',
    'assets/images/두부.png',
    'assets/images/veg2.png',
    'assets/images/두부.png',
    'assets/images/두부.png',
    'assets/images/veg2.png',
    'assets/images/두부.png',
    'assets/images/두부.png',
    'assets/images/두부.png',
    'assets/images/두부.png',
    'assets/images/사과.png',
    'assets/images/사과.png',
    'assets/images/사과.png',
    'assets/images/사과.png',
    'assets/images/사과.png',
    'assets/images/사과.png',
    'assets/images/사과.png',
    'assets/images/사과.png',
    'assets/images/사과.png',
    'assets/images/사과.png',
    'assets/images/사과.png',
    'assets/images/사과.png',
    'assets/images/사과.png',
    'assets/images/사과.png',
    'assets/images/사과.png',
    'assets/images/사과.png',
    'assets/images/사과.png',
    'assets/images/사과.png',
    'assets/images/사과.png',
    'assets/images/veg2.png',
    'assets/images/veg2.png',
  ];

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    fetchMarkets();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Future<void> fetchMarkets() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/markets'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        stores = data.map((item) => {
          'id': item['id'],
          'name': item['name'],
          'keywords': List<String>.from(item['keywords'] ?? []),
          'profile': defaultProfileImage, // 프로필 이미지는 하드코딩
          'products': defaultProductImages, // 상품 이미지는 하드코딩
          'followers': '1.5만',  // 하드코딩
          'is_favorite': item['is_favorite'] ?? false,
        }).toList();
      });
    } else {
      throw Exception('Failed to load markets');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,  // Scaffold 배경색을 흰색으로 설정
        appBar: AppBar(
          title: Text('마켓'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          bottom: TabBar(
            tabs: [
              Tab(text: '랭킹'),
              Tab(text: '관심 마켓'),
            ],
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          children: [
            _buildStoreList(),
            FavoriteMarketPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreList() {
    return ListView.builder(
      itemCount: stores.length,
      itemBuilder: (context, index) {
        return StoreCard(
          store: stores[index],
          rank: index + 1,
          customBlue: widget.customBlue,
          isLoggedIn: isLoggedIn,
        );
      },
    );
  }
}

class StoreCard extends StatefulWidget {
  final Map<String, dynamic> store;
  final int rank;
  final Color customBlue;
  final bool isLoggedIn;

  StoreCard({
    required this.store,
    required this.rank,
    required this.customBlue,
    required this.isLoggedIn,
  });

  @override
  _StoreCardState createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  late bool isFavorite;
  String? cookie;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.store['is_favorite'];
    _loadCookie();
  }

  Future<void> _loadCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cookie = prefs.getString('cookie');
  }

  Future<void> toggleFavorite() async {
    if (!widget.isLoggedIn) {
      _showLoginRequiredDialog();
      return;
    }

    final url = 'http://10.0.2.2:5000/api/market-like';
    final headers = {
      'Content-Type': 'application/json',
      'Cookie': cookie ?? '',
    };
    final body = json.encode({
      'market_id': widget.store['id'],
    });

    final response = await (isFavorite
        ? http.delete(Uri.parse(url), headers: headers, body: body)
        : http.post(Uri.parse(url), headers: headers, body: body));

    if (response.statusCode == 201 || response.statusCode == 200) {
      setState(() {
        isFavorite = !isFavorite;
      });
    } else {
      throw Exception('Failed to toggle favorite');
    }
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그인 필요'),
          content: Text('관심 마켓으로 등록하려면 로그인이 필요합니다.'),
          actions: [
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,  // Card 배경색을 흰색으로 설정
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(widget.store['profile']!),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${widget.rank}. ${widget.store['name']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: toggleFavorite,
                    child: Column(
                      children: [
                        Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          color: isFavorite ? Colors.yellow[700] : null,
                        ),
                        Text(widget.store['followers'].toString()),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: (widget.store['keywords'] as List<String>).map<Widget>((keyword) {
                  return TextButton(
                    onPressed: () {},
                    child: Text(keyword),
                    style: TextButton.styleFrom(
                      primary: widget.customBlue,
                      textStyle: TextStyle(
                        color: widget.customBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: (widget.store['products'] as List<String>).map<Widget>((product) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.asset(product, width: 80),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
