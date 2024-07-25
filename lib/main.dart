import 'package:flutter/material.dart';
import 'package:miniproject/mycart.dart';
import 'market.dart';
import 'product_detail.dart';
import 'package:miniproject/login.dart';
import 'package:miniproject/recommend.dart';

void main() {
  runApp(MyApp());
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

  final Color customBlue = const Color(0xFF76A9E6);

  final List<Widget> _pages = [
    HomeScreen(customBlue: const Color(0xFF76A9E6)),
    MarketScreen(customBlue: const Color(0xFF76A9E6)),
    CategoryScreen(),
    PurchaseHistoryScreen(),
    LoginPage(),
  ];

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
          setState(() {
            _currentIndex = index;
          });
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

class HomeScreen extends StatelessWidget {
  final Color customBlue;

  HomeScreen({required this.customBlue});

  final List<Map<String, String>> recommendedProducts = List.generate(
    4,
        (index) => {
      'image': 'assets/images/veg2.png',
      'description': '[곰곰]뽑기신선하고 아삭한 깨끗한 콩나물 1kg 2kg',
    },
  );

  final List<Map<String, String>> recentlyViewedProducts = List.generate(
    4,
        (index) => {
      'image': 'assets/images/apple.jpg',
      'description': '아삭한 사과칩',
    },
  );

  final List<Map<String, String>> bestProducts = List.generate(
    4,
        (index) => {
      'image': 'assets/images/tofu.png',
      'description': '신선한 두부 300g',
    },
  );

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
          _buildSection('추천 상품', recommendedProducts, Colors.grey.shade700, context),
          _buildSection('최근 본 상품', recentlyViewedProducts, Colors.grey.shade700, context),
          _buildSection('베스트 상품', bestProducts, Colors.grey.shade700, context),
        ],
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
                '서울 성동구 행당동',
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
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Column(
            children: [
              Image.asset(category['image']!, width: 50, height: 50),
              Text(category['label']!),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, String>> products, Color titleColor, BuildContext context) {
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
                    primary: customBlue,
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

  Widget _buildProductCard(Map<String, String> product, BuildContext context) {
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

class MyInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('내 정보 화면'),
    );
  }
}
