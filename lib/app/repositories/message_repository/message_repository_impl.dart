import 'package:new_chat_app/app/models/message.dart';

abstract class MessageRepository {
  Future<void> sendMessage({required Message message});
  Stream<List<Message?>> getMessages();
}
