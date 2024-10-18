// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart';

@JsonSerializable()
class Token extends Equatable {
  const Token(this.access_token, this.token_type);

  final String access_token;
  final String token_type;

  @override
  List<Object> get props => [access_token, token_type];

  @override
  toString() => 'Token { access_token: $access_token, token_type: $token_type }';

  static const empty = Token('-', '-');

  factory Token.fromJson(Map<String, dynamic> json) =>
      _$TokenFromJson(json);

 Map<String, dynamic> toJson() => _$TokenToJson(this);
}