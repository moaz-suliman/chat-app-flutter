import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/core/app_color.dart';
import 'package:real_time_chat/core/app_state.dart';
import 'package:real_time_chat/core/app_widget/app_button_widget.dart';
import 'package:real_time_chat/core/app_widget/text_form_field_widget.dart';
import 'package:real_time_chat/feature/auth/presintation/provider/user_provider.dart';
import 'package:real_time_chat/feature/auth/presintation/view/log_in_page.dart';
import 'package:real_time_chat/feature/home_page/presintation/view/home_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
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
                    const SizedBox(height: 8),
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
                      'Create your account to start messaging',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColor.secondryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormFieldWidget(
                controller: provider.nameController,
                hintText: 'John Doe',
                icon: const Icon(Icons.person_outline, color: Colors.grey),
                labelText: 'Full Name',
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              TextFormFieldWidget(
                controller: provider.confirmPasswordController,
                hintText: '••••••••',
                icon: const Icon(Icons.lock_reset, color: Colors.grey),
                labelText: 'Confirm Password',
                obscureText: true,
              ),
              if (provider.state == ViewState.error) ...[
                const SizedBox(height: 12),
                Text(
                  provider.errorMessage,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.red),
                ),
              ],
              const SizedBox(height: 24),
              provider.state == ViewState.loading
                  ? const CircularProgressIndicator()
                  : AppButtonWidget(
                      text: 'Create Account',
                      onTap: () async {
                        if (provider.passwordController.text !=
                            provider.confirmPasswordController.text) {
                          provider.updateState(
                            ViewState.error,
                            'Passwords do not match',
                          );
                          return;
                        }
                        final success = await provider.signUp(
                          name: provider.nameController.text.trim(),
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
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?  ',
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
                          builder: (context) => const LogInPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Log In',
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