// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
import 'package:chomskyspark/models/user_language.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  List<UserLanguage>? userLanguages;

  User();

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  /// Connect the generated [_$UserToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}