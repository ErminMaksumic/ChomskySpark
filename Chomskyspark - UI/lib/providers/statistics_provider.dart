import 'dart:convert';

import 'package:chomskyspark/models/child_average_time.dart';
import 'package:chomskyspark/models/child_improvement_area.dart';
import 'package:chomskyspark/models/child_word_statistic.dart';
import 'package:chomskyspark/models/daily_statistic.dart';
import 'package:chomskyspark/models/user_statistics.dart';
import 'package:chomskyspark/providers/base_provider.dart';

class StatisticsProvider
    extends BaseProvider<UserStatistics> {
  StatisticsProvider() : super("Statistics");

  @override
  UserStatistics fromJson(data) {
    return UserStatistics.fromJson(data);
  }

  Future<UserStatistics> fetchUserStatistics(int userId) async {
    var url = "$fullUrl/user/$userId";

    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    var response = await httpClient!.get(uri, headers: headers);
    if (isValidResponseCode(response)) {
      return UserStatistics.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("An error occurred!");
    }
  }

  Future<List<ChildWordStatistic>> fetchWordsStatistics(int userId, String? targetWord, DateTime? startDate, DateTime? endDate) async {
    var url = "$fullUrl/words/$userId";
    Map<String, String> queryParams = {
      if (targetWord != null) 'targetWord': targetWord,
      if (startDate != null) 'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate.toIso8601String(),
    };

    String queryString = Uri(queryParameters: queryParams).query;
    var uri = Uri.parse(url + '?' + queryString);

    Map<String, String> headers = createHeaders();
    var response = await httpClient!.get(uri, headers: headers);
    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return data.map((x) => ChildWordStatistic.fromJson(x)).cast<ChildWordStatistic>().toList();
    } else {
      throw Exception("An error occurred!");
    }
  }

  Future<List<DailyStatistic>> fetchDailyStatistics(int userId) async {
    var url = "$fullUrl/user/$userId/daily";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    var response = await httpClient!.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data.map((x) => DailyStatistic.fromJson(x)).cast<DailyStatistic>().toList();
    } else {
      throw Exception('Failed to load statistics');
    }
  }

  Future<List<ChildImprovementArea>> fetchImprovementAreas(int userId) async {
    var url = "$fullUrl/user/$userId/improvement-areas";
    var uri = Uri.parse(url);

    Map<String, String> headers = createHeaders();
    var response = await httpClient!.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data.map((x) => ChildImprovementArea.fromJson(x)).cast<ChildImprovementArea>().toList();
    } else {
      throw Exception('Failed to load statistics');
    }
  }
}
