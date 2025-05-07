import 'package:json_annotation/json_annotation.dart';

part 'user_upsert_request.g.dart';

@JsonSerializable()
class UserUpsertRequest {
  int id;
  final String firstname;
  final String lastname;
  final String email;
  final int primaryLanguageId;
  final int secondaryLanguageId;
  final int parentUserId;

  UserUpsertRequest({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.primaryLanguageId,
    required this.secondaryLanguageId,
    required this.parentUserId,
  });

  factory UserUpsertRequest.fromJson(Map<String, dynamic> json) =>
      _$UserUpsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserUpsertRequestToJson(this);
}
