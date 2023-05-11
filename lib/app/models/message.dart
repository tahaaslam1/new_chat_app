import 'dart:convert';

import 'package:equatable/equatable.dart';

class MessageKeys {
  static const String collection = 'chat_room';
  static const String timeStamp = 'timeStamp';
  static const String content = 'content';
  static const String authorId = 'authorId';
  static const String authorName = 'authorName';
  static const String messageId = 'messageId';
}

class Message extends Equatable {
  final String messageId;
  final String content;
  final String authorId;
  final String? authorName;
  final String? timeStamp;

  const Message({
    required this.messageId,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.timeStamp,
  });

  Message copyWith({
    String? messageId,
    String? content,
    String? authorId,
    String? authorName,
    String? timeStamp,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      MessageKeys.authorId: authorId,
      MessageKeys.authorName: authorName,
      MessageKeys.content: content,
      MessageKeys.timeStamp: timeStamp,
      MessageKeys.messageId: messageId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map[MessageKeys.messageId],
      content: map[MessageKeys.content],
      authorId: map[MessageKeys.authorId] as String,
      authorName: map[MessageKeys.authorName] as String,
      timeStamp: map[MessageKeys.timeStamp] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [messageId, content, authorId, authorName, timeStamp];
}
