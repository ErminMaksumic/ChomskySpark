import 'package:shop/models/word_for_image.dart';
import 'package:shop/providers/base_provider.dart';

class WordForImageProvider
    extends BaseProvider<WordForImage> {
  WordForImageProvider() : super("WordForImage");

  @override
  WordForImage fromJson(data) {
    return WordForImage.fromJson(data);
  }
}
