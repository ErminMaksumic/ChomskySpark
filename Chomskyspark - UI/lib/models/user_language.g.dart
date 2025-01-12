// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLanguage _$UserLanguageFromJson(Map<String, dynamic> json) => UserLanguage()
  ..userId = (json['userId'] as num?)?.toInt()
  ..type = (json['type'] as String?)?.toString()
  ..user = json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>)
  ..languageId = (json['languageId'] as num?)?.toInt()
  ..language = json['language'] == null
      ? null
      : Language.fromJson(json['language'] as Map<String, dynamic>);

Map<String, dynamic> _$UserLanguageToJson(UserLanguage instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'user': instance.user,
      'languageId': instance.languageId,
      'language': instance.language,
    };
