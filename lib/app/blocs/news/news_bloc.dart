import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_chat_app/app/models/news.dart';
import 'package:new_chat_app/app/repositories/news_repository/news_repository.dart';
import 'package:new_chat_app/core/constants.dart';
import 'package:new_chat_app/core/failure.dart';
import 'package:new_chat_app/services/http_service.dart';
import 'package:new_chat_app/services/logger.dart';
import 'package:stream_transform/stream_transform.dart';

part 'news_event.dart';
part 'news_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  late NewsRepository _newsRepository;
  NewsBloc({
    required NewsRepository newsRepository,
  })  : _newsRepository = newsRepository,
        super(const NewsState()) {
    on<FetchNews>(
      _onFetchNews,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onFetchNews(FetchNews event, Emitter<NewsState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == NewsStatus.initial) {
        final news = await _newsRepository.getNews();
        return emit(state.copyWith(
          status: NewsStatus.success,
          news: news,
          hasReachedMax: false,
        ));
      }

      final news = await _newsRepository.getNews(state.page + 1);

      news.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(state.copyWith(
              status: NewsStatus.success,
              news: List.of(state.news)..addAll(news),
              hasReachedMax: false,
              page: state.page + 1,
            ));
    } on Failure catch (_) {
      emit(state.copyWith(status: NewsStatus.failure));
    }
  }

  // Future<List<News>> _getNews([int startIndex = 1]) async {
  //   logger.d(startIndex);
  //   try {
  //     const int limit = 10;
  //     List<News> news = [];

  //     final response = await _newsRepository.request(RequestMethod.get, kBaseUrl, queryParameters: {
  //       'country': 'us',
  //       'apiKey': kApiKey,
  //       'pageSize': limit,
  //       'page': startIndex,
  //     });

  //     news = response.data['articles'].map<News>((res) => News.fromJson(res)).toList();

  //     return news;
  //   } catch (e) {
  //     logger.e(e);
  //     throw Failure(message: kGenericErrorMessage);
  //   }
  // }
}
