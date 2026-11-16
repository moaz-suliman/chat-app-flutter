import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_time_chat/core/app_state.dart';
import 'package:real_time_chat/feature/auth/data/model/user_model.dart';
import 'package:real_time_chat/feature/auth/data/repositories/user_repositories.dart';

class UserProvider extends ChangeNotifier {
  final UserRepositories repo;

  UserProvider(this.repo);

  ViewState state = ViewState.initial;
  String errorMessage = '';
  UserModel? currentUser;

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final searchController = TextEditingController();

  // Users list
  List<UserModel> allUsers = [];
  List<UserModel> filteredUsers = [];
  ViewState usersState = ViewState.initial;

  void updateState(ViewState newState, [String message = '']) {
    state = newState;
    errorMessage = message;
    notifyListeners();
  }

  void clearControllers() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    state = ViewState.initial;
    errorMessage = '';
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    updateState(ViewState.loading);
    try {
      currentUser = await repo.signUp(
        name: name,
        email: email,
        password: password,
      );
      updateState(ViewState.success);
      return true;
    } on FirebaseAuthException catch (e) {
      updateState(ViewState.error, authErrorMessage(e.code));
      return false;
    } catch (e) {
      updateState(
        ViewState.error,
        'An unexpected error occurred, please try again',
      );
      return false;
    }
  }

  Future<bool> logIn({required String email, required String password}) async {
    updateState(ViewState.loading);
    try {
      currentUser = await repo.logIn(email: email, password: password);
      updateState(ViewState.success);
      return true;
    } on FirebaseAuthException catch (e) {
      updateState(ViewState.error, authErrorMessage(e.code));
      return false;
    } catch (e) {
      updateState(
        ViewState.error,
        'An unexpected error occurred, please try again',
      );
      return false;
    }
  }

  Future<void> loadUsers() async {
    usersState = ViewState.loading;
    notifyListeners();
    try {
      final users = await repo.getUsers();
      allUsers = users.where((user) => user.uid != currentUser?.uid).toList();
      filteredUsers = allUsers;
      usersState = ViewState.success;
    } catch (e) {
      usersState = ViewState.error;
    }
    notifyListeners();
  }

  void searchUsers(String query) {
    final text = query.trim().toLowerCase();
    filteredUsers = allUsers
        .where(
          (user) =>
              user.name.toLowerCase().contains(text) ||
              user.email.toLowerCase().contains(text),
        )
        .toList();
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    filteredUsers = allUsers;
  }

  // Log out
  Future<bool> logOut() async {
    updateState(ViewState.loading);
    try {
      await repo.logOut();
      currentUser = null;
      updateState(ViewState.success);
      return true;
    } catch (e) {
      updateState(ViewState.error, 'Could not log out, please try again');
      return false;
    }
  }

  String authErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already in use';
      case 'invalid-email':
        return 'The email address is not valid';
      case 'weak-password':
        return 'Weak password, it must be at least 6 characters';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'The email or password is incorrect';
      case 'network-request-failed':
        return 'Please check your internet connection';
      default:
        return 'The operation failed, please try again';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    searchController.dispose();
    super.dispose();
  }
}