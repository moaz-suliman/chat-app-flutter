import 'package:flutter/material.dart';
import 'package:real_time_chat/core/app_state.dart';
import 'package:real_time_chat/feature/chat_page/data/model/message_model.dart';
import 'package:real_time_chat/feature/chat_page/data/repositories/message_repo.dart';

class MessageProvider extends ChangeNotifier {
  final MessageRepo repo;

  MessageProvider(this.repo);

  ViewState sendState = ViewState.initial;
  String errorMessage = '';

  final messageController = TextEditingController();

  void updateState(ViewState newState, [String message = '']) {
    sendState = newState;
    errorMessage = message;
    notifyListeners();
  }

  Stream<List<MessageModel>> getMessages(String myId, String otherId) {
    return repo.getMessages(myId, otherId);
  }

  Future<bool> sendMessage({
    required String senderId,
    required String receiverId,
  }) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return false;

    updateState(ViewState.loading);
    try {
      final message = MessageModel(
        senderId: senderId,
        receiverId: receiverId,
        text: text,
        time: DateTime.now(),
      );
      await repo.sendMessage(message);
      messageController.clear();
      updateState(ViewState.success);
      return true;
    } catch (e) {
      updateState(ViewState.error, 'Could not send the message, please try again');
      return false;
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}