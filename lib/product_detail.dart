import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;
  final String productTitle;
  final double productPrice;

  ProductDetailPage({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _isFavorited = false;
  String? cookie;

  @override
  void initState() {
    super.initState();
    _getCookie();
    _checkIfFavorited();
  }

  void _getCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cookie = prefs.getString('cookie');
    });
  }

  void _toggleFavorite() async {
    final url = 'http://10.0.2.2:5000/api/product-like';
    final method = _isFavorited ? 'DELETE' : 'POST';
    final headers = {
      'Content-Type': 'application/json',
      'Cookie': cookie ?? '',
    };
    final body = jsonEncode({
      'gonggu_product_id': widget.productId,
      'name': widget.productTitle,
      'price': widget.productPrice,
    });

    final response = await (method == 'POST'
        ? http.post(Uri.parse(url), headers: headers, body: body)
        : http.delete(Uri.parse(url), headers: headers, body: body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        _isFavorited = !_isFavorited;
      });
    }
  }

  void _checkIfFavorited() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5000/api/favorite-products'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': cookie ?? '',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> favoriteProducts = jsonDecode(response.body);
      setState(() {
        _isFavorited = favoriteProducts.any((product) => product['id'] == widget.productId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat('#,###');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('상품 상세 페이지'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              // Implement action for home icon
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(_getImageForProductId(widget.productId)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${priceFormat.format(widget.productPrice)}원~',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      Text('5.0 (127)'),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          _isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorited ? Colors.red : null,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '무료배송 (전 상품 무료배송)',
                        style: TextStyle(color: Colors.blue),
                      ),
                      Spacer(),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '2개팀',
                              style: TextStyle(
                                color: Colors.blueAccent.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ' 전체보기',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Text(
                    '공동구매 참여하기',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  SizedBox(height: 8),
                  _buildGroupPurchaseItem('이유정', '3/7'),
                  _buildGroupPurchaseItem('하지윤', '11/30'),
                  Divider(),
                  _buildTabSection(),
                  SizedBox(height: 16),
                  SizedBox(height: 16),
                  _buildBottomButtons(),
                ],
              ),
            ),
          ],
        ),
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

  Widget _buildGroupPurchaseItem(String name, String status) {
    return Row(
      children: [
        CircleAvatar(
          child: Text(name[0]),
        ),
        SizedBox(width: 8),
        Text('$name ($status)'),
        Spacer(),
        TextButton(
          onPressed: () => _showBottomSheet(context, name, status),
          child: Text('공동구매 참여'),
          style: TextButton.styleFrom(
            backgroundColor: Color(0xFF00308D),
            primary: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTabSection() {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: '상품정보'),
              Tab(text: '상품후기 127'),
              Tab(text: '상품문의'),
            ],
          ),
          Container(
            height: 200,
            child: TabBarView(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset('assets/images/1.png'),
                      Image.asset('assets/images/2.png'),
                      Image.asset('assets/images/3.png'),
                      Image.asset('assets/images/4.png'),
                    ],
                  ),
                ),
                SingleChildScrollView(child: ReviewSection()),
                SingleChildScrollView(child: QuestionSection()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _showBottomSheet(context, '', ''),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 17),
              child: Text('장바구니 담기', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Color(0xFF76A9E6),
              side: BorderSide(width: 2, color: Color(0xFF76A9E6)),
            ),
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _showBottomSheet(context, '', ''),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Column(
                children: [
                  Text('5,400원~', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('공동구매 시작하기', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF76A9E6),
              onPrimary: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context, String name, String status) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: BottomSheetContent(
          name: name,
          status: status,
          teams: [
            {'name': '이유정', 'status': '3/7'},
            {'name': '하지윤', 'status': '11/30'},
          ],
        ),
      ),
    );
  }
}

class BottomSheetContent extends StatefulWidget {
  final String name;
  final String status;
  final List<Map<String, String>> teams;

  BottomSheetContent({
    required this.name,
    required this.status,
    required this.teams,
  });

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  int _selectedQuantity = 1;
  final double _pricePerItem = 5400.00;
  String _selectedTeamName = '';
  String _selectedTeamStatus = '';

  @override
  void initState() {
    super.initState();
    if (widget.teams.isNotEmpty) {
      _selectedTeamName = widget.teams[0]['name']!;
      _selectedTeamStatus = widget.teams[0]['status']!;
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedPrice = NumberFormat.currency(locale: 'ko_KR', symbol: '').format(_pricePerItem * _selectedQuantity);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '공동구매 참여하기',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15),
        Container(
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
                SizedBox(height: 5,),
                Text('   참여선택', style: TextStyle(fontSize: 16), textAlign: TextAlign.start,),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 20),
                  child: Row(
                    children: [
                      Text('팀장명 ',),
                      DropdownButton<Map<String, String>>(
                        value: widget.teams.firstWhere(
                              (team) => team['name'] == _selectedTeamName,
                        ),
                        items: widget.teams.map((team) {
                          return DropdownMenuItem<Map<String, String>>(
                            value: team,
                            child: Text('  ${team['name']}', style: TextStyle(fontSize: 13),),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTeamName = value!['name']!;
                            _selectedTeamStatus = value['status']!;
                          });
                        },
                      ),
                      Spacer(),
                      Text('진행 인원  ($_selectedTeamStatus)'),
                    ],
                  ),
                )
              ],
            )
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text('수량 ', style: TextStyle(fontSize: 16),),
            SizedBox(width: 10),
            DropdownButton<int>(
              value: _selectedQuantity,
              items: List.generate(10, (index) => index + 1)
                  .map((value) => DropdownMenuItem(
                value: value,
                child: Text(value.toString()),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedQuantity = value!;
                });
              },
            ),
            Spacer(),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '결제 예상 금액   ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  TextSpan(
                    text: '$formattedPrice원',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF00308D)),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // 장바구니 담기 버튼 클릭 시 처리
                },
                child: Text('장바구니 담기'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  side: BorderSide(color: Color(0xFF00308D), width: 2),
                  onPrimary: Colors.black,
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // 바로 구매 버튼 클릭 시 처리
                },
                child: Text('바로 구매'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF00308D),
                  onPrimary: Colors.white,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class ReviewSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '상품 후기',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        ReviewItem('사용자1', 5, '정말 좋아요! 매우 만족합니다.'),
        ReviewItem('사용자2', 4, '가격 대비 괜찮은 상품입니다.'),
        // 추가적인 리뷰 아이템들을 필요에 따라 추가할 수 있습니다.
      ],
    );
  }
}

class ReviewItem extends StatelessWidget {
  final String username;
  final int rating;
  final String reviewText;

  ReviewItem(this.username, this.rating, this.reviewText);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              child: Text(username[0]),
            ),
            SizedBox(width: 8),
            Text(username),
            Spacer(),
            Icon(Icons.star, color: Colors.amber, size: 16),
            Text('$rating.0'),
          ],
        ),
        SizedBox(height: 8),
        Text(
          reviewText,
          style: TextStyle(fontSize: 14),
        ),
        Divider(),
      ],
    );
  }
}

class QuestionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        FaqSection(),
        SizedBox(height: 8),
        Text(
          '상품 문의',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue
          ),
        ),
        SizedBox(height: 8),
        QuestionItem('고객1', '이 제품의 유통기한은 얼마나 되나요?'),
        QuestionItem('고객2', '배송은 어떻게 진행되나요?'),
        // 추가적인 문의 아이템들을 필요에 따라 추가할 수 있습니다.
      ],
    );
  }
}

class QuestionItem extends StatelessWidget {
  final String username;
  final String questionText;

  QuestionItem(this.username, this.questionText);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              child: Text(username[0]),
            ),
            SizedBox(width: 8),
            Text(username),
          ],
        ),
        SizedBox(height: 4),
        Text(
          questionText,
          style: TextStyle(fontSize: 14),
        ),
        Divider(),
      ],
    );
  }
}

class FaqSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '자주 묻는 질문',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue
          ),
        ),
        SizedBox(height: 8),
        FaqItem(
          question: '배송은 얼마나 걸리나요?',
          answer: '평균적으로 주문 후 2~3일이 소요됩니다.',
        ),
        FaqItem(
          question: '환불 정책은 어떻게 되나요?',
          answer: '구매 후 7일 이내에 요청하시면 전액 환불해 드립니다.',
        ),
        // 추가적인 FAQ 아이템들을 필요에 따라 추가할 수 있습니다.
      ],
    );
  }
}

class FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          answer,
          style: TextStyle(fontSize: 14),
        ),
        Divider(),
      ],
    );
  }
}