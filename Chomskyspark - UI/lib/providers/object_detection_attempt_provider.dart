import 'package:chomskyspark/models/object_detection_attempt_model.dart';
import 'package:chomskyspark/providers/base_provider.dart';

class ObjectDetectionAttemptProvider
    extends BaseProvider<ObjectDetectionAttempt> {
  ObjectDetectionAttemptProvider() : super("ObjectDetectionAttempt");

  @override
  ObjectDetectionAttempt fromJson(data) {
    return ObjectDetectionAttempt.fromJson(data);
  }
}
