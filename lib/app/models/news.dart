import 'package:equatable/equatable.dart';
import 'package:new_chat_app/core/constants.dart';

class News extends Equatable {
  final String imageUrl;
  final String sourceName;
  final String title;

  const News({required this.imageUrl, required this.sourceName, required this.title});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      imageUrl: json['urlToImage'] ?? kRandomImageUrl,
      sourceName: json['source']['name'] ?? 'N/A',
      title: json['title'] ?? 'N/A',
    );
  }

  @override
  List<Object?> get props => [imageUrl, sourceName, title];
}
