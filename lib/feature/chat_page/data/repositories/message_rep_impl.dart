import 'package:real_time_chat/core/service/firebase_service/message_service.dart';
import 'package:real_time_chat/feature/chat_page/data/model/message_model.dart';
import 'package:real_time_chat/feature/chat_page/data/repositories/message_repo.dart';

class MessageRepoImpl implements MessageRepo {
  final MessageService _messageService;

  MessageRepoImpl(this._messageService);

  String _chatRoomId(String senderId, String receiverId) {
    final ids = [senderId, receiverId]..sort();
    return ids.join('_');
  }

  @override
  Future<void> sendMessage(MessageModel message) {
    final chatRoomId = _chatRoomId(message.senderId, message.receiverId);
    return _messageService.sendMessage(chatRoomId, message.toMap());
  }

  @override
  Stream<List<MessageModel>> getMessages(String senderId, String receiverId) {
    final chatRoomId = _chatRoomId(senderId, receiverId);
    return _messageService.getMessages(chatRoomId).map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data()))
          .toList();
    });
  }
}