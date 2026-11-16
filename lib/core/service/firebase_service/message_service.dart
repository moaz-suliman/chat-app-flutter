import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  final FirebaseFirestore database = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _messages(String chatRoomId) {
    return database.collection('chats').doc(chatRoomId).collection('messages');
  }

  Future<void> sendMessage(String chatRoomId, Map<String, dynamic> data) async {
    await _messages(chatRoomId).add(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatRoomId) {
    return _messages(chatRoomId).orderBy('time').snapshots();
  }
}