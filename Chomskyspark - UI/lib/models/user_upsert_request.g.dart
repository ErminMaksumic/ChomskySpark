// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_upsert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUpsertRequest _$UserUpsertRequestFromJson(Map<String, dynamic> json) =>
    UserUpsertRequest(
      id: json['id'] as int,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      email: json['email'] as String,
      primaryLanguageId: json['primaryLanguageId'] as int,
      secondaryLanguageId: json['secondaryLanguageId'] as int,
      parentUserId: json['parentUserId'] as int,
    );

Map<String, dynamic> _$UserUpsertRequestToJson(UserUpsertRequest instance) {
      final json = <String, dynamic>{
            'firstname': instance.firstname,
            'lastname': instance.lastname,
            'email': instance.email,
            'primaryLanguageId': instance.primaryLanguageId,
            'secondaryLanguageId': instance.secondaryLanguageId,
            'parentUserId': instance.parentUserId,
      };

      if (instance.id != 0) {
            json['id'] = instance.id;
      }
      return json;
}
