import 'package:flutter/services.dart';

class DebugMessageLogger {
  static final DebugMessageLogger _instance = DebugMessageLogger._internal();
  factory DebugMessageLogger() => _instance;

  DebugMessageLogger._internal();

  final List<String> _messages = [];

  void addMessage(String message) {
    _messages.add(message);
    _copyMessagesToClipboard();
  }

  void _copyMessagesToClipboard() {
    Clipboard.setData(ClipboardData(text: _messages.join('\n')));
  }

  List<String> get messages => _messages;
}
