import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000';

  Future<List<Map<String, dynamic>>> fetchRecommendedProducts(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/recommendations?user_id=$userId'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<Map<String, dynamic>> productsWithTitles = [];
      for (var product in data) {
        final productResponse = await http.get(Uri.parse('$baseUrl/api/gonggu_product/${product['product_id']}'));
        if (productResponse.statusCode == 200) {
          Map<String, dynamic> productData = jsonDecode(productResponse.body);
          product['title'] = productData['title'];
          product['price'] = productData['price'];
          productsWithTitles.add(product);
        }
      }

      return productsWithTitles;
    } else {
      throw Exception('Failed to load recommended products');
    }
  }


  Future<List<Map<String, dynamic>>> fetchAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/all-products'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load all products');
    }
  }
}
