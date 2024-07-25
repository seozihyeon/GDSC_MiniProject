import 'package:flutter/material.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({super.key});

  @override
  State<MyCartPage> createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
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
        title: Text('나의 장바구니'),
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
            CartItem(Mname: "싱싱마켓", Pname: "신선하고 깨끗한 아삭한 콩나물", Pimg: 'assets/images/veg2.png', Team: "진행중", price: 1800, quantity: 2, currentNum: 3, totalNum: 8),
            CartItem(Mname: "하호마켓", Pname: "신선한 콩두부 350g", Pimg: 'assets/images/tofu.png', Team: "진행중", price: 2300, quantity: 1, currentNum: 5, totalNum: 11),
            CartItem(Mname: "하호마켓", Pname: "신선한 콩두부 350g", Pimg: 'assets/images/tofu.png', Team: "진행중", price: 2300, quantity: 1, currentNum: 5, totalNum: 11),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color(0xFF00308D),
          ),
          child: Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('----원 구매하기', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              SizedBox(width: 8,),
              Container(padding:EdgeInsets.symmetric(horizontal: 8, vertical: 0.5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(900), color: Colors.white), child: Text('3', style: TextStyle(color: Color(0xFF00308D), fontWeight: FontWeight.bold, fontSize: 17),),)
            ],
          )),
        ),
      ),
    );
  }
}

class CartItem extends StatefulWidget {
  final String Mname;
  final String Pname;
  final String Pimg;
  final String Team;
  final int price;
  final int quantity;
  final int currentNum;
  final int totalNum;

  CartItem({
    required this.Mname,
    required this.Pname,
    required this.Pimg,
    required this.Team,
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
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? newValue) {
                    setState(() {
                      isChecked = newValue ?? false;
                    });
                  },
                ),
                Text(
                  widget.Mname,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
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
                          Text('${widget.Pname}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), ),
                          Text('가격: ${widget.price}원'),
                          Text('수량: ${widget.quantity}'),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 8,),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF76A9E6),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${widget.Team}', style: TextStyle(color: Colors.white, fontSize: 16),),
                          Text('모집인원 (${widget.currentNum}/${widget.totalNum})', style: TextStyle(color: Colors.white, fontSize: 16),)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1,), borderRadius: BorderRadius.circular(8)),
                          child: Text('옵션변경', textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
                        ),
                      ),
                      SizedBox(width: 8,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1,), borderRadius: BorderRadius.circular(8)),
                          child: Text('총 ${widget.price * widget.quantity}원', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
