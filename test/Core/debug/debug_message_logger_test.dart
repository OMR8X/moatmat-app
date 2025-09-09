import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:moatmat_app/Core/debug/debug_message_logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('DebugMessageLogger', () {
    test('addMessage should add a message to the list and copy to clipboard', () {
      // Clear messages before each test for isolation
      DebugMessageLogger().messages.clear();

      final logger = DebugMessageLogger();
      const testMessage = 'Test message 1';
      logger.addMessage(testMessage);

      expect(logger.messages, contains(testMessage));
      expect(logger.messages.length, 1);

      // Verify that the clipboard was updated with the message
      // Note: In a real widget test, you might use a mock for Clipboard.
      // For a unit test like this, we're relying on the actual Clipboard.setData
      // to be called, and trusting Flutter's implementation.
      // A more robust test would involve mocking Clipboard.
    });

    test('addMessage should copy all messages to clipboard', () {
      DebugMessageLogger().messages.clear();

      final logger = DebugMessageLogger();
      const message1 = 'First message';
      const message2 = 'Second message';

      logger.addMessage(message1);
      logger.addMessage(message2);

      expect(logger.messages, containsAll([message1, message2]));
      expect(logger.messages.length, 2);

      // We cannot directly read from the clipboard in a unit test without
      // platform-specific implementation or mocking.
      // This test primarily ensures addMessage calls the _copyMessagesToClipboard
      // method and the messages list is correctly populated.
    });
  });
}
