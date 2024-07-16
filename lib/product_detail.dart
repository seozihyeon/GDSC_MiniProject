import 'package:flutter/material.dart';
import 'package:miniproject/login.dart';


class ProductDetailPage extends StatefulWidget {
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _isFavorited = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Image.asset('assets/images/veg2.png'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '[곰팡몰]신선하고 아삭한 깨끗한 콩나물 1kg 2kg',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '5,400원~',
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
                    style: TextStyle(fontWeight: FontWeight.bold),
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
          onPressed: () {
            // Implement action for group purchase item
          },
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
            onPressed: () {
              // Implement action for adding to cart button
            },
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
            onPressed: () {
              // Implement action for starting group purchase button
            },
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