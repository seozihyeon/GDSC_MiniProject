import 'package:flutter/material.dart';

class MarketScreen extends StatelessWidget {
  final Color customBlue;

  MarketScreen({required this.customBlue});

  final List<Map<String, String>> stores = [
    {
      'name': '사과농장',
      'localFood': '로컬푸드',
      'organic': '유기농',
      'products': 'assets/images/img.png',
      'followers': '11만'
    },
    {
      'name': '콩나물농장',
      'localFood': '로컬푸드',
      'organic': '유기농',
      'products': 'assets/images/img.png',
      'followers': '5만'
    },
    {
      'name': '두부농장',
      'localFood': '로컬푸드',
      'organic': '유기농',
      'products': 'assets/images/img.png',
      'followers': '2만'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,  // Scaffold 배경색을 흰색으로 설정
        appBar: AppBar(
          title: Text('스토어'),
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
            Center(child: Text('관심 마켓')),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreList() {
    return ListView.builder(
      itemCount: stores.length,
      itemBuilder: (context, index) {
        return StoreCard(store: stores[index], rank: index + 1, customBlue: customBlue);
      },
    );
  }
}

class StoreCard extends StatefulWidget {
  final Map<String, String> store;
  final int rank;
  final Color customBlue;

  StoreCard({required this.store, required this.rank, required this.customBlue});

  @override
  _StoreCardState createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  bool isFavorite = false;

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
                    backgroundImage: AssetImage(widget.store['products']!),
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
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          color: isFavorite ? Colors.yellow : null,
                        ),
                        Text(widget.store['followers']!),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(widget.store['localFood']!),
                    style: TextButton.styleFrom(
                      primary: widget.customBlue,
                      textStyle: TextStyle(
                        color: widget.customBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {},
                    child: Text(widget.store['organic']!),
                    style: TextButton.styleFrom(
                      primary: widget.customBlue,
                      textStyle: TextStyle(
                        color: widget.customBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Image.asset(widget.store['products']!, width: 80),
                    const SizedBox(width: 8),
                    Image.asset(widget.store['products']!, width: 80),
                    const SizedBox(width: 8),
                    Image.asset(widget.store['products']!, width: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
