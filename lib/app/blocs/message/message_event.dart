part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class MessageRequested extends MessageEvent {
  const MessageRequested();
}

class MessageReceived extends MessageEvent {
  final List<Message?> messages;
  const MessageReceived({
    required this.messages,
  });
}

class MessageSent extends MessageEvent {
  final Message message;
  const MessageSent({
    required this.message,
  });
}
