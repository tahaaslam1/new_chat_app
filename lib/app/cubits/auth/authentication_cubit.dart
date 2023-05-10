import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:new_chat_app/app/models/user.dart';
import 'package:new_chat_app/app/repositories/auth_repository/auth_repository.dart';

part 'authentication_state.dart';

// class AuthenticationCubit extends Cubit<AuthenticationState> {
//   AuthenticationCubit() : super(AuthenticationInitial());
// }

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  AuthenticationCubit({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    Future.delayed(const Duration(seconds: 3), () => _authenticationStatusSubscription = _authenticationRepository.authenticationStatus.listen((status) => _authStatusChanged(status)));
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  void _authStatusChanged(AuthenticationStatus authenticationStatus) async {
    switch (authenticationStatus) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        return emit(const AuthenticationState.authenticated());
      case AuthenticationStatus.unknown:
        return emit(const AuthenticationState.unknown());
    }
  }

  void logout() {
    _authenticationRepository.logout();
  }
}
