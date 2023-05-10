import 'package:new_chat_app/app/models/news.dart';
import 'package:new_chat_app/app/repositories/news_repository/news_repository.dart';
import 'package:new_chat_app/core/constants.dart';
import 'package:new_chat_app/core/failure.dart';
import 'package:new_chat_app/services/http_service.dart';
import 'package:new_chat_app/services/logger.dart';

class NewsRepositoryImpl extends NewsRepository {
  final HttpService _httpService;

  NewsRepositoryImpl({required httpService}) : _httpService = httpService;

  @override
  Future<List<News>> getNews([int startIndex = 1]) async {
    try {
      const int limit = 10;
      List<News> news = [];

      final response = await _httpService.request(RequestMethod.get, kBaseUrl, queryParameters: {
        'country': 'us',
        'apiKey': kApiKey,
        'pageSize': limit,
        'page': startIndex,
      });

      news = response.data['articles'].map<News>((res) => News.fromJson(res)).toList();

      return news;
    } catch (e) {
      logger.e(e);
      throw Failure(message: kGenericErrorMessage);
    }
  }
}
