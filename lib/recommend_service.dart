import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchRecommendedProducts(int userId) async {
  final response = await http.get(Uri.parse('http://10.0.2.2:5000/recommendations?user_id=$userId'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load recommended products');
  }
}
