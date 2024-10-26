abstract class LoginEvent {}

class DoLoginEvent extends LoginEvent {
  final String username;
  final String password;
  DoLoginEvent(this.username, this.password);
}

class DoLogoutEvent extends LoginEvent {
  final String token;
  DoLogoutEvent(this.token);
}