import 'package:encrypt/encrypt.dart';

class AESCrypt {
  static const String _key = '5f478d390e24f38a6b9c7e2b46d0a1c8';

  static String encriptar(String text) {
    final key = Key.fromUtf8(_key);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  static String desencriptar(String encryptedText) {
    final key = Key.fromUtf8(_key);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    final encrypted = Encrypted.fromBase64(encryptedText);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}
