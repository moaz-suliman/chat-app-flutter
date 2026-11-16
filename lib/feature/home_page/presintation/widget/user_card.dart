import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_time_chat/core/app_color.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String image;
  final VoidCallback onTap;

  const UserCard({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF1F3FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: ClipOval(
          child: Image.asset(image, width: 48, height: 48, fit: BoxFit.cover),
        ),
        title: Text(
          name,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColor.secondryColor,
            ),
          ),
        ),
      ),
    );
  }
}