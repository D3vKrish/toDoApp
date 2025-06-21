import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  static const storage = FlutterSecureStorage();

  static Future<bool> isTokenValid() async {
    String? token = await storage.read(key: 'jwtToken');
    if (token == null || JwtDecoder.isExpired(token)) {
      return false;
    }
    return true;
  }
}
