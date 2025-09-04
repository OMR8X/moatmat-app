import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static final _key = encrypt.Key.fromUtf8('1234567890123456'); // 16-byte key
  static final _iv = encrypt.IV.fromUtf8('Q48I:(^V?/DC[C3U'); // 16-byte IV
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  /// Encrypt plain text to base64 string (synchronous).
  /// Use this for small text data or when immediate response is needed.
  static String encryptData(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  /// Decrypt base64 string to plain text (synchronous).
  /// Use this for small text data or when immediate response is needed.
  static String decryptData(String encryptedText) {
    return _encrypter.decrypt64(encryptedText, iv: _iv);
  }

  /// Encrypt binary data (Uint8List) (synchronous).
  /// Use this for small binary data or when immediate response is needed.
  static Uint8List encryptBinaryData(Uint8List data) {
    final encrypted = _encrypter.encryptBytes(data, iv: _iv);
    return encrypted.bytes;
  }

  /// Decrypt encrypted binary data (Uint8List) (synchronous).
  /// Use this for small binary data or when immediate response is needed.
  static Uint8List decryptBinaryData(Uint8List encryptedData) {
    final encrypted = encrypt.Encrypted(encryptedData);
    final decryptedBytes = _encrypter.decryptBytes(encrypted, iv: _iv);
    return Uint8List.fromList(decryptedBytes);
  }

  /// Encrypt plain text to base64 string asynchronously in an isolate.
  /// Recommended for large text data or to avoid blocking the UI thread.
  static Future<String> encryptDataAsync(String plainText) async {
    return await Isolate.run(() => _encryptDataIsolate(plainText));
  }

  /// Decrypt base64 string to plain text asynchronously in an isolate.
  /// Recommended for large text data or to avoid blocking the UI thread.
  static Future<String> decryptDataAsync(String encryptedText) async {
    return await Isolate.run(() => _decryptDataIsolate(encryptedText));
  }

  /// Encrypt binary data (Uint8List) asynchronously in an isolate.
  /// Recommended for large binary data (images, videos, files) to avoid blocking the UI thread.
  static Future<Uint8List> encryptBinaryDataAsync(Uint8List data) async {
    return await Isolate.run(() => encryptBinaryData(data));
  }

  /// Decrypt encrypted binary data (Uint8List) asynchronously in an isolate.
  /// Recommended for large binary data (images, videos, files) to avoid blocking the UI thread.
  static Future<Uint8List> decryptBinaryDataAsync(Uint8List encryptedData) async {
    return await Isolate.run(() => decryptBinaryData(encryptedData));
  }

  // Private isolate functions that recreate the encryption context
  static String _encryptDataIsolate(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  static String _decryptDataIsolate(String encryptedText) {
    return _encrypter.decrypt64(encryptedText, iv: _iv);
  }

  /// Generate a secure encrypted filename with appropriate extension.
  static String generateSecureFileName(String fileType) {
    final randomBytes = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    final hex = randomBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '$hex${_getFileExtension(fileType)}.enc';
  }

  /// Map file type to file extension.
  static String _getFileExtension(String fileType) {
    const ext = {
      'pdf': '.pdf',
      'mp4': '.mp4',
      'video/mp4': '.mp4',
      'avi': '.avi',
      'video/avi': '.avi',
      'mov': '.mov',
      'video/mov': '.mov',
      'jpg': '.jpg',
      'jpeg': '.jpg',
      'image/jpeg': '.jpg',
      'png': '.png',
      'image/png': '.png',
      'gif': '.gif',
      'image/gif': '.gif',
      'webp': '.webp',
      'image/webp': '.webp',
    };
    return ext[fileType.toLowerCase()] ?? '.bin';
  }

  /// Check if a file is encrypted by its extension.
  static bool isFileEncrypted(String filePath) {
    return filePath.toLowerCase().endsWith('.enc');
  }
}
