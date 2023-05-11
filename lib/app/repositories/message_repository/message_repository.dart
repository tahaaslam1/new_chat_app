import 'package:new_chat_app/app/models/message.dart';
import 'package:new_chat_app/app/repositories/message_repository/message_repository_impl.dart';
import 'package:new_chat_app/services/firebase_service.dart';

class MessageRepositoryImpl extends MessageRepository {
  final FirebaseService _firebaseService;

  MessageRepositoryImpl({required FirebaseService firebaseService}) : _firebaseService = firebaseService;

  @override
  Stream<List<Message?>> getMessages() {
    final messageMapStream = _firebaseService.getMessages();

    return messageMapStream.map(
      (event) => event.map(
        (e) {
          return e != null ? Message.fromMap(e) : null;
        },
      ).toList(),
    );
  }

  @override
  Future<void> sendMessage({required Message message}) async {
    await _firebaseService.addMessage(messageMap: message.toMap());
  }
}
