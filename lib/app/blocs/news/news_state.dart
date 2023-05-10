part of 'news_bloc.dart';

enum NewsStatus { initial, success, failure }

class NewsState extends Equatable {
  final NewsStatus status;
  final List<News> news;
  final bool hasReachedMax;
  final int page;
  const NewsState({
    this.status = NewsStatus.initial,
    this.news = const <News>[],
    this.hasReachedMax = false,
    this.page = 1,
  });
  NewsState copyWith({
    NewsStatus? status,
    List<News>? news,
    bool? hasReachedMax,
    int? page,
  }) {
    return NewsState(
      status: status ?? this.status,
      news: news ?? this.news,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }

  @override
  List<Object> get props => [status, news, hasReachedMax, page];
}
