import 'package:chomskyspark/models/learned_word.dart';
import 'package:chomskyspark/providers/base_provider.dart';

class LearnedWordProvider
    extends BaseProvider<LearnedWord> {
  LearnedWordProvider() : super("LearnedWord");

  @override
  LearnedWord fromJson(data) {
    return LearnedWord.fromJson(data);
  }
}
