import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_chat_app/app/models/message.dart';
import 'package:new_chat_app/app/repositories/message_repository/message_repository_impl.dart';
import 'package:new_chat_app/services/logger.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  late final StreamSubscription? messageStream;
  late final MessageRepository _messageRepository;

  @override
  Future<void> close() {
    messageStream?.cancel();
    return super.close();
  }

  MessageBloc({required MessageRepository messageRepository})
      : _messageRepository = messageRepository,
        super(const MessageState()) {
    on<MessageRequested>((event, emit) {
      try {
        emit(state.copyWith(status: MessageStatus.loading));
        messageStream = _messageRepository.getMessages().listen((messages) {
          add(MessageReceived(messages: messages));
        });
      } on Exception catch (e, trace) {
        logger.e('Issue while loading message $e $trace');
        emit(state.copyWith(status: MessageStatus.failure));
      }
    });
    on<MessageReceived>((event, emit) {
      emit(state.copyWith(status: MessageStatus.loading, messages: event.messages));
    });
  }
}
