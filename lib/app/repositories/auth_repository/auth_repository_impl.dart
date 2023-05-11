import 'dart:async';

import 'package:crypt/crypt.dart';
import 'package:new_chat_app/app/models/user.dart';
import 'package:new_chat_app/app/cubits/auth/authentication_cubit.dart';
import 'package:new_chat_app/app/repositories/auth_repository/auth_repository.dart';
import 'package:new_chat_app/core/failure.dart';
import 'package:new_chat_app/services/database_helper.dart';
import 'package:new_chat_app/services/logger.dart';
import 'package:uuid/uuid.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  @override
  Stream<AuthenticationStatus> get authenticationStatus async* {
    final signedIn = isSignedIn();
    if (await signedIn) {
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      _controller.add(AuthenticationStatus.unauthenticated);
    }
    yield* _controller.stream;
  }

  @override
  Future<bool> isSignedIn() async {
    return await DatabaseHelper.instance.checkUserLoggedIn();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  // TODO: implement getLoggedInUser
  User? get getLoggedInUser => throw UnimplementedError();

  bool _isValidPassword(String enteredPassword, String hash) => Crypt(hash).match(enteredPassword);

  @override
  Future<void> login(String username, String password) async {
    try {
      Map<String, Object?> res = await DatabaseHelper.instance.getUser(username);
      if (_isValidPassword(password, res['password'].toString())) {
        User.instance.userId = res['user_id'].toString();
        User.instance.username = res['username'].toString();

        _controller.add(AuthenticationStatus.authenticated);

        return;
      } else {
        throw Failure(message: 'Invalid Credentials');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await DatabaseHelper.instance.logoutUser(User.instance.userId!);

      User.instance.userId = null;
      User.instance.username = null;

      _controller.add(AuthenticationStatus.unauthenticated);
    } catch (e) {
      logger.e(e);
      throw Failure(message: 'Failed to logout');
    }
  }

  @override
  Future<void> register(String username, String password) async {
    try {
      var uuid = const Uuid();
      final userId = uuid.v1();
      final userMap = User.toMap(userId, username, Crypt.sha256(password).toString(), 1); // 0 -> false || 1 - true

      await DatabaseHelper.instance.insertUser(userMap);

      User.instance.userId = userId;
      User.instance.username = username;

      _controller.add(AuthenticationStatus.authenticated);
    } catch (e) {
      logger.e(e);
      throw Failure(message: 'Failed to register');
    }
  }
}
