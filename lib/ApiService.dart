import 'dart:convert';

import 'package:fresh_apk/Post.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const url =
      "https://dakshindspl.com/devddspl/public/api/cash-detail-req";

  Future<List<Post>> getPostApi(Function(List<Post>) updateState) async {
    final response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      List<Post> newData = [];
      for (Map i in data) {
        newData.add(Post.fromJson(i as Map<String, dynamic>));
      }
      updateState(newData);
      return newData;
    } else {
      throw Exception('Failed to load data from API');
    }
  }
}
