import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/core/app_color.dart';
import 'package:real_time_chat/core/app_state.dart';
import 'package:real_time_chat/core/app_widget/app_button_widget.dart';
import 'package:real_time_chat/core/app_widget/text_form_field_widget.dart';
import 'package:real_time_chat/feature/auth/presintation/provider/user_provider.dart';
import 'package:real_time_chat/feature/auth/presintation/view/sign_up_page.dart';
import 'package:real_time_chat/feature/home_page/presintation/view/home_page.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xffF1F3FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.sms,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Chatly',
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Simple, fast, and secure messaging',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColor.secondryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Column(
                  children: [
                    TextFormFieldWidget(
                      controller: provider.emailController,
                      hintText: 'name@example.com',
                      icon: const Icon(Icons.email_outlined, color: Colors.grey),
                      labelText: 'Email address',
                    ),
                    const SizedBox(height: 16),
                    TextFormFieldWidget(
                      controller: provider.passwordController,
                      hintText: '••••••••',
                      icon: const Icon(Icons.lock_outline, color: Colors.grey),
                      labelText: 'Password',
                      obscureText: true,
                    ),
                    if (provider.state == ViewState.error) ...[
                      const SizedBox(height: 12),
                      Text(
                        provider.errorMessage,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    provider.state == ViewState.loading
                        ? const CircularProgressIndicator()
                        : AppButtonWidget(
                            text: 'Log In',
                            onTap: () async {
                              final success = await provider.logIn(
                                email: provider.emailController.text.trim(),
                                password: provider.passwordController.text,
                              );
                              if (success && context.mounted) {
                                provider.clearControllers();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              }
                            },
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColor.secondryColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      provider.clearControllers();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Register',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}