// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'me.g.dart';

@JsonSerializable()
class Me extends Equatable {
  const Me(
      {this.username,
      this.name,
      this.avatar_url,
      this.email,
      this.secondary_email,
      this.preferred_email,
      this.timezone,
      this.is_setup,
      this.level,
      this.unique_hash,
      this.schedule_links});

  final String? username;
  final String? name;
  final String? avatar_url;
  final String? email;
  final String? secondary_email;
  final String? preferred_email;
  final String? timezone;
  final bool? is_setup;
  final int? level;
  final String? unique_hash;
  final List<String>? schedule_links;

  @override
  List<Object> get props => [];

  @override
  toString() => 'Me { username: $username, email: $email }';

  static const empty = Me();

  factory Me.fromJson(Map<String, dynamic> json) => _$MeFromJson(json);

  Map<String, dynamic> toJson() => _$MeToJson(this);
}
