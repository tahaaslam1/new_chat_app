import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_chat_app/app/models/message.dart';

class FirebaseService {
  final FirebaseFirestore _firestore;

  FirebaseService({
    required firestore,
  }) : _firestore = firestore;

  Future<void> addMessage({required Map<String, dynamic> messageMap}) async {
    await _firestore.collection(MessageKeys.collection).add(messageMap);
  }

  Stream<List<Map<String, dynamic>?>> getMessages() {
    final querySnapShotStream = _firestore.collection(MessageKeys.collection).orderBy(MessageKeys.timeStamp, descending: true).snapshots();

    return querySnapShotStream.map(
      (event) => event.docs.map((e) => e.data()).toList(),
    );
  }
}
