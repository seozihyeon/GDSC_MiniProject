import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:miniproject/mycart.dart';
import 'market.dart';
import 'product_detail.dart';
import 'login.dart';
import 'recommend.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchRecommendedProducts() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:5000/all-products')); // 서버 IP 주소 및 엔드포인트를 정확히 기입

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load recommended products');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _resetLoginStatus(); // 앱 시작 시 로그인 상태 초기화
  runApp(MyApp());
}

Future<void> _resetLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', false); // 로그인 상태 초기화
  await prefs.remove('userInfo');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  late List<Widget> _pages;
  String? dongName;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    dongName = null; // 초기화
    _checkLoginStatus();
    _pages = [
      HomeScreen(customBlue: const Color(0xFF76A9E6), dongName: dongName),
      MarketScreen(customBlue: const Color(0xFF76A9E6)),
      CategoryScreen(),
      PurchaseHistoryScreen(),
      MyInfoScreen(),
    ];
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
    _loadUserData(); // 로그인 상태 확인 후에 사용자 데이터를 로드
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfo = prefs.getString('userInfo');
    if (userInfo != null) {
      var user = jsonDecode(userInfo);
      setState(() {
        dongName = user['region_name'];
        _pages[0] = HomeScreen(customBlue: const Color(0xFF76A9E6), dongName: dongName); // 갱신된 부분
      });
    } else {
      setState(() {
        dongName = null; // 초기화
      });
    }
  }

  final Color customBlue = const Color(0xFF76A9E6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 4 && !isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            ).then((_) {
              _checkLoginStatus();
              if (isLoggedIn) {
                setState(() {
                  _currentIndex = index;
                });
              }
            });
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        selectedItemColor: customBlue,
        unselectedItemColor: Colors.grey.shade700,
        selectedLabelStyle: TextStyle(color: customBlue),
        unselectedLabelStyle: TextStyle(color: Colors.grey.shade700),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: '마켓',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: '카테고리',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: '구매내역',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내 정보',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Color customBlue;
  final String? dongName;

  HomeScreen({required this.customBlue, required this.dongName});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> bestProductsFuture;

  final List<Map<String, String>> recentlyViewedProducts = List.generate(
    4,
        (index) => {
      'image': 'assets/images/apple.jpg',
      'description': '아삭한 사과칩',
    },
  );

  final List<Map<String, String>> recommendProducts = List.generate(
    4,
        (index) => {
      'image': 'assets/images/tofu.png',
      'description': '신선한 두부 300g',
    },
  );

  @override
  void initState() {
    super.initState();
    bestProductsFuture = fetchRecommendedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          _buildCustomAppBar(context),
          const SizedBox(height: 20),
          _buildSearchBar(),
          _buildCategorySection(),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: bestProductsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return _buildSection('베스트 상품', snapshot.data ?? [], Colors.grey.shade700, context);
              }
            },
          ),
          _buildSection2('추천 상품', recommendProducts, Colors.grey.shade700, context),
          _buildSection2('최근 본 상품', recentlyViewedProducts, Colors.grey.shade700, context),
        ],
      ),
    );
  }

  Widget _buildSection2(String title, List<Map<String, String>> products, Color titleColor, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0), // 카테고리와 추천 상품 사이의 간격 조정
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: titleColor),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductRecommend()),
                    );
                  },
                  child: const Text('더보기'),
                  style: TextButton.styleFrom(
                    primary: Color(0xFF76A9E6),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _buildProductCard2(products[index], context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard2(Map<String, String> product, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(),
          ),
        );
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              product['image']!,
              fit: BoxFit.cover,
              height: 100,
            ),
            const SizedBox(height: 8),
            Text(
              product['description']!,
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                widget.dongName ?? '위치 정보 없음',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyCartPage()),
              );
            },
            child: Icon(Icons.shopping_cart, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: '검색',
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade700),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    final List<Map<String, String>> categories = [
      {'image': 'assets/images/fruit.png', 'label': '과일'},
      {'image': 'assets/images/vegetable.png', 'label': '채소'},
      {'image': 'assets/images/grain.png', 'label': '곡류'},
      {'image': 'assets/images/seafood.png', 'label': '해산물'},
      {'image': 'assets/images/meat.png', 'label': '육류'},
      {'image': 'assets/images/processed.png', 'label': '가공식품'},
      {'image': 'assets/images/dairy.png', 'label': '유제품 및 계란'},
      {'image': 'assets/images/etc.png', 'label': '기타'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(categories[index]['image']!),
              ),
              const SizedBox(height: 8),
              Text(
                categories[index]['label']!,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> products, Color color, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductRecommend()),
                    );
                  },
                  child: const Text('더보기'),
                  style: TextButton.styleFrom(
                    primary: widget.customBlue,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _buildProductCard(products[index], context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailPage()),
        );
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              product['image_url'] ?? 'assets/images/veg2.png', // 기본 이미지 사용
              fit: BoxFit.cover,
              height: 100,
            ),
            const SizedBox(height: 8),
            Text(
              product['title'] ?? '',
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _dummyProducts() {
    return [
      {
        'image': 'assets/images/fruit.png',
        'description': '신선한 과일',
      },
      {
        'image': 'assets/images/vegetable.png',
        'description': '신선한 채소',
      },
      {
        'image': 'assets/images/grain.png',
        'description': '신선한 곡류',
      },
    ];
  }
}

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('카테고리 화면'),
    );
  }
}

class PurchaseHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('구매내역 화면'),
    );
  }
}

class MyInfoScreen extends StatefulWidget {
  @override
  _MyInfoScreenState createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen> {
  Map<String, dynamic>? userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfoString = prefs.getString('userInfo');
    if (userInfoString != null) {
      setState(() {
        userInfo = jsonDecode(userInfoString);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보'),
      ),
      body: userInfo == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('이름: ${userInfo!['username']}'),
            Text('아이디: ${userInfo!['User ID']}'),
            Text('지역: ${userInfo!['region_name']}'),
            Text('주소: ${userInfo!['address']}'),
            Text('전화번호: ${userInfo!['phone']}'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}