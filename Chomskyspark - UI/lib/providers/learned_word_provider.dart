import 'package:shop/models/learned_word.dart';
import 'package:shop/providers/base_provider.dart';

class LearnedWordProvider
    extends BaseProvider<LearnedWord> {
  LearnedWordProvider() : super("LearnedWord");

  @override
  LearnedWord fromJson(data) {
    return LearnedWord.fromJson(data);
  }
}
