import 'package:real_time_chat/feature/auth/data/model/user_model.dart';

abstract class UserRepositories {
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> logIn({
    required String email,
    required String password,
  });
  Future<List<UserModel>> getUsers();

  Future<void> logOut();
}