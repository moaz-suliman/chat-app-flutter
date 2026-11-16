import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/core/app_color.dart';
import 'package:real_time_chat/core/app_state.dart';
import 'package:real_time_chat/feature/auth/data/model/user_model.dart';
import 'package:real_time_chat/feature/auth/presintation/provider/user_provider.dart';
import 'package:real_time_chat/feature/chat_page/data/model/message_model.dart';
import 'package:real_time_chat/feature/chat_page/presintation/provider/message_provider.dart';
import 'package:real_time_chat/feature/chat_page/presintation/widget/message.dart';

class ChatPage extends StatelessWidget {
  final UserModel user;

  const ChatPage({super.key, required this.user});

  String formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final messageProvider = context.read<MessageProvider>();
    final myId = context.read<UserProvider>().currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backGroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                user.image.isEmpty
                    ? 'assets/images/profile_image.png'
                    : user.image,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              user.name,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: messageProvider.getMessages(myId, user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Something went wrong',
                      style: GoogleFonts.inter(color: Colors.red),
                    ),
                  );
                }
                final messages = snapshot.data ?? [];
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet',
                      style: GoogleFonts.inter(
                        color: AppColor.secondryColor,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Message(
                      text: message.text,
                      time: formatTime(message.time),
                      isMe: message.senderId == myId,
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageProvider.messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 16,
                          color: AppColor.secondryColor,
                        ),
                        filled: true,
                        fillColor: const Color(0xffE8EAFF),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: AppColor.primaryColor,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () async {
                        final success = await messageProvider.sendMessage(
                          senderId: myId,
                          receiverId: user.uid,
                        );
                        if (!success &&
                            messageProvider.sendState == ViewState.error &&
                            context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(messageProvider.errorMessage)),
                          );
                        }
                      },
                      child: const SizedBox(
                        width: 48,
                        height: 48,
                        child: Icon(Icons.send, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}