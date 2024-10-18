import '../models/models.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoggedIn extends LoginState {
  final Token token;
  final Me me;
  LoggedIn(this.token, this.me);
}
class LoginError extends LoginState {
  final String error;
  LoginError(this.error);
}