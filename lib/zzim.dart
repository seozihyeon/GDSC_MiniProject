import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ZzimPage extends StatefulWidget {
  @override
  _ZzimPageState createState() => _ZzimPageState();
}

class _ZzimPageState extends State<ZzimPage> {
  List<Product> favoriteProducts = [];
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
      fetchFavoriteProducts();
    }
  }

  Future<void> fetchFavoriteProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cookie = prefs.getString('cookie');

    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/api/favorite-products'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': cookie ?? '',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        favoriteProducts = data.map((item) => Product.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load favorite products');
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
      appBar: AppBar(
        title: Text('찜한 상품'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // 현재 화면을 종료할 수 없을 때 수행할 작업
            }
          },
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.75, // 가로:세로 비율
        ),
        itemCount: favoriteProducts.length,
        itemBuilder: (context, index) {
          return ProductItem(
            product: favoriteProducts[index],
          );
        },
      ),
    );
  }
}

class Product {
  final int id;
  final String name;
  final int price; // 여기서 double 대신 int 타입으로 변경합니다.

  Product({required this.id, required this.name, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'], // int 타입으로 받습니다.
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(_getImageForProductId(product.id)),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${product.price}원',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
}
