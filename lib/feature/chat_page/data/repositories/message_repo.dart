import 'package:real_time_chat/feature/chat_page/data/model/message_model.dart';

abstract class MessageRepo {
  Future<void> sendMessage(MessageModel message);
  Stream<List<MessageModel>> getMessages(String myId, String otherId);
}