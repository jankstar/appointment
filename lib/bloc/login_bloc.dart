// ignore_for_file: non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

import '../repository/api_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiRepository api_repository; // Ihre Datenbankinstanz

  LoginBloc(this.api_repository) : super(LoginInitial()) {
    on<DoLoginEvent>(_onLogin);
    on<DoLogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(DoLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    //print('Logging in... username ${event.username}, password ${event.password}');
    try {
      final tokenData = await api_repository.doLogin(username: event.username, password: event.password);
      final meData = await api_repository.getMe(token: tokenData.access_token);
      //print('Login successful: $data');
      emit(LoggedIn(tokenData, meData));
    } catch (e) {
      print('Login failed: $e');
      emit(LoginError(e.toString()));
    }
  }

  Future<void> _onLogout(DoLogoutEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      await api_repository.getLogout(token: event.token);
      emit(LoginInitial());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
