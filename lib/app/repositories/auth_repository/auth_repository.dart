import 'package:new_chat_app/app/cubits/auth/authentication_cubit.dart';
import 'package:new_chat_app/app/models/user.dart';

abstract class AuthenticationRepository {
  Stream<AuthenticationStatus> get authenticationStatus;
  Future<void> login(String username, String password);
  Future<void> register(String username, String password);
  Future<void> logout();
  User? get getLoggedInUser;
  Future<bool> isSignedIn();
  void dispose();
}
