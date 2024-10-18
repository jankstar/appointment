// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Me _$MeFromJson(Map<String, dynamic> json) => Me(
      username: json['username'] as String?,
      name: json['name'] as String?,
      avatar_url: json['avatar_url'] as String?,
      email: json['email'] as String?,
      secondary_email: json['secondary_email'] as String?,
      preferred_email: json['preferred_email'] as String?,
      timezone: json['timezone'] as String?,
      is_setup: json['is_setup'] as bool?,
      level: (json['level'] as num?)?.toInt(),
      unique_hash: json['unique_hash'] as String?,
      schedule_links: (json['schedule_links'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MeToJson(Me instance) => <String, dynamic>{
      'username': instance.username,
      'name': instance.name,
      'avatar_url': instance.avatar_url,
      'email': instance.email,
      'secondary_email': instance.secondary_email,
      'preferred_email': instance.preferred_email,
      'timezone': instance.timezone,
      'is_setup': instance.is_setup,
      'level': instance.level,
      'unique_hash': instance.unique_hash,
      'schedule_links': instance.schedule_links,
    };
