// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'language.g.dart';

@JsonSerializable()
class Language {
  int? id;
  String? Name;

  Language();

  factory Language.fromJson(Map<String, dynamic> json) =>
      _$LanguageFromJson(json);

  /// Connect the generated [_$LanguageToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$LanguageToJson(this);
}
