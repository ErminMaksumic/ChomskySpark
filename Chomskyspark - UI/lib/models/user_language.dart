// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
import 'package:shop/models/language.dart';
import 'package:shop/models/user.dart';
part 'user_language.g.dart';

@JsonSerializable()
class UserLanguage {
  int? userId;
  User? user;
  int? languageId;
  Language? language;
  String? type;

  UserLanguage();

  factory UserLanguage.fromJson(Map<String, dynamic> json) =>
      _$UserLanguageFromJson(json);

  /// Connect the generated [_$UserLanguageToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserLanguageToJson(this);
}
