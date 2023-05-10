import 'package:new_chat_app/app/models/news.dart';

abstract class NewsRepository {
  Future<List<News>> getNews([int startIndex = 1]);
}
