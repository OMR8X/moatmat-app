import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// debug tools

bool get isDebugging => kDebugMode;

void log({String tag = '', dynamic message, bool showInRelease = true}) {
  if (!showInRelease && isDebugging) {
    developer.log('$tag: $message');
  } else if (showInRelease) {}
}
