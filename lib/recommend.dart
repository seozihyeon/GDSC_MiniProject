import 'package:flutter/material.dart';

class ProductRecommend extends StatelessWidget {
  final List<Product> products = [
    Product(
      name: '상품 1',
      price: '9000',
    ),
    Product(
      name: '상품 2',
      price: '9000',
    ),
    Product(
      name: '상품 3',
      price: '9000',
    ),
    Product(
      name: '상품 4',
      price: '9000',
    ),
    Product(
      name: '상품 5',
      price: '9000',
    ),
    Product(
      name: '상품 6',
      price: '9000',
    ),
    Product(
      name: '상품 7',
      price: '9000',
    ),
    Product(
      name: '상품 8',
      price: '9000',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('추천 상품'),
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
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductItem(
            product: products[index],
          );
        },
      ),
    );
  }
}

class Product {
  final String name;
  final String price;

  Product({required this.name, required this.price});
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
          Image.asset('assets/images/veg2.png'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  product.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  product.price,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
