import 'package:flutter/material.dart';

class MyPurchaseScren extends StatefulWidget {
  const MyPurchaseScren({super.key});

  @override
  State<MyPurchaseScren> createState() => _MyPurchaseScrenState();
}

class _MyPurchaseScrenState extends State<MyPurchaseScren> {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            CartItem(Mname: "싱싱마켓", Pname: "신선하고 깨끗한 아삭한 콩나물", Pimg: 'assets/images/veg2.png', Dstate: 0, price: 1800, quantity: 2, currentNum: 3, totalNum: 8),
            CartItem(Mname: "하호마켓", Pname: "신선한 콩두부 350g", Pimg: 'assets/images/tofu.png', Dstate: 1, price: 2300, quantity: 1, currentNum: 5, totalNum: 11),
            CartItem(Mname: "하호마켓", Pname: "신선한 콩두부 350g", Pimg: 'assets/images/tofu.png', Dstate: 0, price: 2300, quantity: 1, currentNum: 5, totalNum: 11),
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatefulWidget {
  final String Mname;
  final String Pname;
  final String Pimg;
  final int Dstate;
  final int price;
  final int quantity;
  final int currentNum;
  final int totalNum;

  CartItem({
    required this.Mname,
    required this.Pname,
    required this.Pimg,
    required this.Dstate,
    required this.price,
    required this.quantity,
    required this.currentNum,
    required this.totalNum,
  });

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  bool isChecked = false;
  int Dstate = 1;

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
                  Text('24.07.21', style: TextStyle(fontWeight: FontWeight.bold),),
                  Text('주문상세 >', style: TextStyle(color: Color(0xFF76A9E6)),)
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
                        widget.Pimg,
                        fit: BoxFit.cover,
                        height: 100,
                      ),
                      SizedBox(width: 6,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.Mname, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                          Text('${widget.Pname}', style: TextStyle(fontSize: 15), ),
                          Text('가격: ${widget.price}원', style: TextStyle(color: Colors.grey.shade600),),
                          Text('수량: ${widget.quantity}', style: TextStyle(color: Colors.grey.shade600)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Color(0xFF00308D), width: 1,), borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            child: widget.Dstate == 0
                                ? Center(child: Text('진행중 (${widget.currentNum}/${widget.totalNum})', style: TextStyle(color: Color(0xFF00308D), fontSize: 15),))
                                : Center(child: Text('배송완료', style: TextStyle(color: Color(0xFF00308D), fontSize: 15),),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1,), borderRadius: BorderRadius.circular(8)),
                        child: Text('구매후기작성', textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
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
