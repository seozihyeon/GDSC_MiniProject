import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:miniproject/login.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyPurchaseScreen extends StatefulWidget {
  const MyPurchaseScreen({super.key});

  @override
  State<MyPurchaseScreen> createState() => _MyPurchaseScreenState();
}

class _MyPurchaseScreenState extends State<MyPurchaseScreen> {
  bool isLoggedIn = false;
  String? cookie;
  List<dynamic> purchases = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _fetchPurchases();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? savedCookie = prefs.getString('cookie');

    setState(() {
      isLoggedIn = loggedIn;
      cookie = savedCookie;
      isLoading = false;
    });

    if (isLoggedIn && cookie != null) {
      _fetchPurchases();
    }
  }

  Future<void> _fetchPurchases() async {
    if (cookie == null) return;

    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/purchase-list'),
      headers: {'Cookie': cookie!},
    );

    if (response.statusCode == 200) {
      setState(() {
        purchases = json.decode(response.body);
      });
    } else {
      print('Failed to load purchases');
    }
  }

  String _getImageForProductId(int productId) {
    switch (productId) {
      case 8:
        return 'assets/images/veg2.png';
      case 1:
        return 'assets/images/apple.jpg';
      case 10:
        return 'assets/images/tofu.png';
      default:
        return 'assets/images/veg2.png'; // 기본 이미지
    }
  }

  int _getDstateForProductId(int productId) {
    return (productId == 1 || productId == 10) ? 1 : 0;
  }

  void _navigateToLogin() async {
    bool? isLoggedInAfterLogin = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );

    if (isLoggedInAfterLogin == true) {
      setState(() {
        isLoggedIn = true;
      });
      _fetchPurchases();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 구매내역'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              // Implement action for home icon
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchPurchases,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : isLoggedIn
            ? purchases.isEmpty
            ? Center(child: Text('구매 내역이 없습니다.'))
            : ListView(
          children: purchases.map((purchase) {
            return CartItem(
              Mname: purchase['market_name'],
              Pname: purchase['title'],
              Pid: purchase['product_id'],
              Pimg: _getImageForProductId(purchase['product_id']),
              Dstate: _getDstateForProductId(purchase['product_id']),
              price: purchase['price'] ?? 0,
              quantity: purchase['quantity'],
              currentNum: 3,
              totalNum: 8,
            );
          }).toList(),
        )
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '로그인 후 사용 가능한 페이지입니다',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToLogin,
                child: Text('로그인하러 가기'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Color(0xFF76A9E6),
                  side: BorderSide(width: 2, color: Color(0xFF76A9E6)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final String Mname;
  final String Pname;
  final int Pid;
  final String Pimg;
  final int Dstate;
  final int price;
  final int quantity;
  final int currentNum;
  final int totalNum;

  CartItem({
    required this.Mname,
    required this.Pname,
    required this.Pid,
    required this.Pimg,
    required this.Dstate,
    required this.price,
    required this.quantity,
    required this.currentNum,
    required this.totalNum,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('24.07.21', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('주문상세 >', style: TextStyle(color: Color(0xFF76A9E6))),
                ],
              ),
            ),
            Container(
              height: 1.0,
              color: Colors.grey.shade400,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        Pimg,
                        fit: BoxFit.cover,
                        height: 100,
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Mname,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              Pname,
                              style: TextStyle(fontSize: 15),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '가격: $price원',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            Text(
                              '수량: $quantity',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF00308D), width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            child: Dstate == 0
                                ? Center(child: Text('진행중 ($currentNum/$totalNum)', style: TextStyle(color: Color(0xFF00308D), fontSize: 15)))
                                : Center(child: Text('배송완료', style: TextStyle(color: Color(0xFF00308D), fontSize: 15))),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('구매후기작성', textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
