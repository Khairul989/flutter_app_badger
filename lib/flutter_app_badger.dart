import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FlutterAppBadger {
  static const MethodChannel _channel =
      const MethodChannel('g123k/flutter_app_badger');

  static void updateBadgeCount(int count,
      {String title = 'Missed notification', String description = ''}) async {
    final mock = _mockUpdateBadgeCount;
    if (mock != null) {
      await mock(count);
      return;
    }
    _channel.invokeMethod('updateBadgeCount',
        {"count": count, "title": title, "description": description});
  }

  static Future<void> removeBadge() async {
    final mock = _mockRemoveBadge;
    if (mock != null) {
      await mock();
      return;
    }

    return _channel.invokeMethod('removeBadge');
  }

  static Future<bool> isAppBadgeSupported() async {
    final mock = _mockIsAppBadgeSupported;
    if (mock != null) {
      return mock();
    }

    bool? appBadgeSupported =
        await _channel.invokeMethod('isAppBadgeSupported');
    return appBadgeSupported ?? false;
  }

  static Future<void> Function(int count)? _mockUpdateBadgeCount;
  static Future<void> Function()? _mockRemoveBadge;
  static Future<bool> Function()? _mockIsAppBadgeSupported;

  @visibleForTesting
  static void setMocks({
    Future<void> Function(int count)? updateBadgeCount,
    Future<void> Function()? removeBadge,
    Future<bool> Function()? isAppBadgeSupported,
  }) {
    _mockUpdateBadgeCount = updateBadgeCount;
    _mockRemoveBadge = removeBadge;
    _mockIsAppBadgeSupported = isAppBadgeSupported;
  }

  @visibleForTesting
  static void clearMocks() {
    _mockUpdateBadgeCount = null;
    _mockRemoveBadge = null;
    _mockIsAppBadgeSupported = null;
  }
}
