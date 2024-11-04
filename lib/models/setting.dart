// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'setting.g.dart';

@JsonSerializable()
class Setting extends Equatable {
  const Setting(this.langu, this.themeMode);

  final String langu;
  final ThemeMode themeMode;

  @override
  List<Object> get props => [langu, themeMode];

  Setting copyWith({String? langu, ThemeMode? themeMode}) {
    return Setting(
      langu ?? this.langu,
      themeMode ?? this.themeMode,
    );
  }

  @override
  toString() => 'Setting { langu: $langu, themeMode: $themeMode }';

  static const empty = Setting('en', ThemeMode.system);

  factory Setting.fromJson(Map<String, dynamic> json) => _$SettingFromJson(json);

  Map<String, dynamic> toJson() => _$SettingToJson(this);
}
