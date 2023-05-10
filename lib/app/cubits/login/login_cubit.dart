import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:new_chat_app/app/repositories/auth_repository/auth_repository.dart';
import 'package:new_chat_app/core/failure.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authRepository;
  LoginCubit({required AuthenticationRepository authRepository})
      : _authRepository = authRepository,
        super(LoginInitial());

  Future<void> login(String username, String password) async {
    emit(LoginLoading());
    try {
      await _authRepository.login(username, password);
      emit(LoginSucess());
    } on Failure catch (e) {
      emit(LoginFailure(errorMessage: e.message));
    }
  }
}
