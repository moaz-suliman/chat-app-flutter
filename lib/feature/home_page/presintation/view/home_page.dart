import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/core/app_color.dart';
import 'package:real_time_chat/core/app_state.dart';
import 'package:real_time_chat/feature/auth/presintation/provider/user_provider.dart';
import 'package:real_time_chat/feature/auth/presintation/view/log_in_page.dart';
import 'package:real_time_chat/feature/chat_page/presintation/view/chat_page.dart';
import 'package:real_time_chat/feature/home_page/presintation/widget/user_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<UserProvider>();
    provider.clearSearch();
    Future.microtask(() => provider.loadUsers());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backGroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Chats',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final success = await provider.logOut();
              if (success && context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LogInPage()),
                );
              }
            },
            icon: const Icon(Icons.logout, color: Colors.black),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: provider.searchController,
              onChanged: provider.searchUsers,
              decoration: InputDecoration(
                hintText: 'Search chats or users...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColor.secondryColor,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xffF1F3FF),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: buildUsersList(provider)),
          ],
        ),
      ),
    );
  }

  Widget buildUsersList(UserProvider provider) {
    if (provider.usersState == ViewState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.usersState == ViewState.error) {
      return Center(
        child: Text(
          'Something went wrong',
          style: GoogleFonts.inter(color: Colors.red),
        ),
      );
    }
    final users = provider.filteredUsers;
    if (users.isEmpty) {
      return Center(
        child: Text(
          'No users found',
          style: GoogleFonts.inter(color: AppColor.secondryColor),
        ),
      );
    }
    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final user = users[index];
        return UserCard(
          name: user.name,
          lastMessage: user.email,
          image: user.image.isEmpty
              ? 'assets/images/profile_image.png'
              : user.image,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatPage(user: user)),
            );
          },
        );
      },
    );
  }
}
