
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/firebase_options.dart';

import 'package:real_time_chat/core/service/firebase_service/auth_service.dart';
import 'package:real_time_chat/core/service/firebase_service/message_service.dart';
import 'package:real_time_chat/core/service/firebase_service/user_service.dart';
import 'package:real_time_chat/feature/auth/data/repositories/user_repositories_impl.dart';
import 'package:real_time_chat/feature/auth/presintation/provider/user_provider.dart';
import 'package:real_time_chat/feature/auth/presintation/view/log_in_page.dart';
import 'package:real_time_chat/feature/chat_page/data/repositories/message_rep_impl.dart';
import 'package:real_time_chat/feature/chat_page/presintation/provider/message_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              UserProvider(UserRepositoriesImpl(AuthService(), UserService())),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              MessageProvider(MessageRepoImpl(MessageService())),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LogInPage(),
      ),
    ),
  );
}
