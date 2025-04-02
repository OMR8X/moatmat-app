import 'package:encrypt/encrypt.dart' as encrypt;


class EncryptionService {
  static final _key = encrypt.Key.fromUtf8('1234567890123456'); // Ensure 16, 24, or 32 bytes
  static final _iv = encrypt.IV.fromUtf8('Q48I:(^V?/DC[C3U'); // Ensure 16 bytes

  static String encryptData(String plainText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  static String decryptData(String encryptedText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);
    return decrypted;
  }
}
