import 'package:flutter/foundation.dart';

class AnalyticsService {
  static void logEvent(String eventName, {Map<String, dynamic>? parameters}) {
    final message = StringBuffer('Analytics Event: $eventName');
    if (parameters != null && parameters.isNotEmpty) {
      message.write(
        ' | ${parameters.entries.map((e) => '${e.key}=${e.value}').join(', ')}',
      );
    }
    debugPrint(message.toString());
  }

  static void logScreenView(String screenName) {
    logEvent('screen_view', parameters: {'screen_name': screenName});
  }
}
