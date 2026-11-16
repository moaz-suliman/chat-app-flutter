import 'package:real_time_chat/core/service/firebase_service/auth_service.dart';
import 'package:real_time_chat/core/service/firebase_service/user_service.dart';
import 'package:real_time_chat/feature/auth/data/model/user_model.dart';
import 'package:real_time_chat/feature/auth/data/repositories/user_repositories.dart';

class UserRepositoriesImpl implements UserRepositories {
  final AuthService _authService;
  final UserService _userService;

  UserRepositoriesImpl(this._authService, this._userService);

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _authService.register(
      email: email,
      password: password,
    );

    final user = UserModel(
      uid: credential.user!.uid,
      name: name,
      email: email,
      image: '',
    );

    await _userService.createUser(user.uid, user.toMap());
    return user;
  }

  @override
  Future<UserModel> logIn({
    required String email,
    required String password,
  }) async {
    final credential = await _authService.login(
      email: email,
      password: password,
    );

    final doc = await _userService.getUser(credential.user!.uid);
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final snapshot = await _userService.getUsers();
    return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
  }

  @override
  Future<void> logOut() {
    return _authService.signOut();
  }
}
