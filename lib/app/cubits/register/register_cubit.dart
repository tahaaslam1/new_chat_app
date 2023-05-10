import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_chat_app/app/repositories/auth_repository/auth_repository.dart';
import 'package:new_chat_app/core/failure.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthenticationRepository _authRepository;
  RegisterCubit({required AuthenticationRepository authenticationRepository})
      : _authRepository = authenticationRepository,
        super(RegisterInitial());

  Future<void> register(String username, String password) async {
    emit(RegisterLoading());
    try {
      await _authRepository.register(username, password);
      emit(RegisterSucess());
    } on Failure catch (e) {
      emit(RegisterFailure(errorMessage: e.message));
    }
  }
}
