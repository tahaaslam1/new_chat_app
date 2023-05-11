part of 'message_bloc.dart';

enum MessageStatus { initial, loading, success, failure }

class MessageState extends Equatable {
  final MessageStatus status;
  final List<Message?> messages;
  const MessageState({
    this.status = MessageStatus.initial,
    this.messages = const <Message?>[],
  });
  MessageState copyWith({
    List<Message?>? messages,
    MessageStatus? status,
  }) {
    return MessageState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status, messages];
}
