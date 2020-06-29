import 'dart:convert';

import 'package:flutterappinfinitescroll/model/news_model.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  static Future<NewsModel> getNewsData(int currentPage) async {
    final url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=29c99d03194f4d46acbbceaa5cd22f9d&page=$currentPage";
    final results = await http.get(url);
    print("statuse kode: +${results.statusCode}");
    if (results.statusCode == 200) {
      NewsModel newsModel = NewsModel.fromJson(jsonDecode(results.body));
      return newsModel;
    }
    return null;
  }
}