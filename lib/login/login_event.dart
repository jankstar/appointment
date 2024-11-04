// ignore_for_file: non_constant_identifier_names

import '../models/models.dart';

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

class DoSetMeEvent extends LoginEvent {
  final Token token;
  final String timezone;
  final String username;
  final String name;
  final String avatar_url;
  final String secondary_email;
  DoSetMeEvent(this.token, this.timezone, this.username, this.name, this.avatar_url, this.secondary_email);
}
