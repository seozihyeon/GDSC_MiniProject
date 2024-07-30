import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'mycart.dart';
import 'login.dart';
import 'market.dart';
import 'category_screen.dart';
import 'mypurchase.dart';
import 'my_info.dart';

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
  int userId = 0;  // 사용자 ID를 저장할 변수

  @override
  void initState() {
    super.initState();
    dongName = null; // 초기화
    _checkLoginStatus();
    _pages = [
      HomeScreen(customBlue: const Color(0xFF76A9E6), dongName: dongName, userId: userId),  // 사용자 ID 전달
      MarketScreen(customBlue: const Color(0xFF76A9E6)),
      CategoryScreen(),
      MyPurchaseScren(),
      MyInfoScreen(), // Update to use the new MyInfoScreen
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
        userId = user['user_id'];  // 사용자 ID 저장
        _pages[0] = HomeScreen(customBlue: const Color(0xFF76A9E6), dongName: dongName, userId: userId); // 갱신된 부분
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
