// ignore_for_file: non_constant_identifier_names

import 'package:appointment/models/me.dart';
import 'package:bloc/bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

import '../repository/api_repository.dart';
import '../repository/lib_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiRepository api_repository; // Ihre Datenbankinstanz

  LoginBloc(this.api_repository) : super(LoginLoading()) {
    on<DoLoginEvent>(_onLogin);
    on<DoLogoutEvent>(_onLogout);
    on<DoSetMeEvent>(_onSetTimezone);
  }

  Future<void> _onLogin(DoLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    //print('Logging in... username ${event.username}, password ${event.password}');
    try {
      final tokenData = await api_repository.doLogin(username: event.username, password: event.password);
      final meData = await api_repository.getMe(token: tokenData.access_token);
      LibRepository().getLogger().d('Login success: $meData');
      emit(LoggedIn(tokenData, meData));
    } catch (e) {
      LibRepository().getLogger().e('Login failed: $e');
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

  Future<void> _onSetTimezone(DoSetMeEvent event, Emitter<LoginState> emit) async {
    try {
      var meChanged = Me(timezone: event.timezone, username: event.username, name: event.name, avatar_url: event.avatar_url, 
      secondary_email: event.secondary_email);
      final meData  = await api_repository.setMe(token: event.token.access_token, me: meChanged);
      emit(LoggedIn(event.token, meData));
    } catch (e) {
      LibRepository().getLogger().e('SetTimezone failed: $e');
      emit(LoginError(e.toString()));
    }
  }
}
