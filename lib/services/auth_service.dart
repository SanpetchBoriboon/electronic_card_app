import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';

/// Service สำหรับจัดการ authentication และ guest tokens
class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Token storage keys
  static const String _tokenKey = 'guest_token';
  static const String _usernameKey = 'guest_username';
  static const String _tokenExpiryKey = 'token_expiry';

  // In-memory cache
  String? _cachedToken;
  String? _cachedUsername;
  DateTime? _tokenExpiry;

  /// ดึง token ที่เก็บไว้ (จาก cache หรือ SharedPreferences)
  Future<String?> getToken() async {
    // Check in-memory cache first
    if (_cachedToken != null && _isTokenValid()) {
      return _cachedToken;
    }

    // Load from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_tokenKey);
    _cachedUsername = prefs.getString(_usernameKey);

    final expiryTimestamp = prefs.getInt(_tokenExpiryKey);
    if (expiryTimestamp != null) {
      _tokenExpiry = DateTime.fromMillisecondsSinceEpoch(expiryTimestamp);
    }

    // Validate token
    if (_cachedToken != null && _isTokenValid()) {
      return _cachedToken;
    }

    return null;
  }

  /// ดึง username ที่เก็บไว้
  Future<String?> getUsername() async {
    if (_cachedUsername != null) {
      return _cachedUsername;
    }

    final prefs = await SharedPreferences.getInstance();
    _cachedUsername = prefs.getString(_usernameKey);
    return _cachedUsername;
  }

  /// เรียก API เพื่อสร้าง guest token ใหม่
  Future<Map<String, dynamic>> generateGuestToken() async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.guestTokens),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'] as String;
        final username = data['user']?['username'] as String?;

        // Save token with expiry (default 24 hours)
        await _saveToken(token, username);

        return {'token': token, 'username': username, 'user': data['user']};
      } else if (response.statusCode == 403) {
        // Time not reached error
        final errorData = json.decode(response.body);
        throw TokenForbiddenException(
          errorData['message'] ?? 'Token request forbidden',
          errorData,
        );
      } else {
        throw TokenGenerationException(
          'Failed to generate token: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is TokenForbiddenException || e is TokenGenerationException) {
        rethrow;
      }
      throw TokenGenerationException('Error generating token: $e', 0);
    }
  }

  /// ดึง token หรือสร้างใหม่ถ้ายังไม่มี
  Future<String> getOrCreateToken() async {
    // Try to get existing token
    final existingToken = await getToken();
    if (existingToken != null) {
      return existingToken;
    }

    // Generate new token
    final result = await generateGuestToken();
    return result['token'] as String;
  }

  /// บันทึก token และ username
  Future<void> _saveToken(String token, String? username) async {
    _cachedToken = token;
    _cachedUsername = username;
    _tokenExpiry = DateTime.now().add(const Duration(hours: 24));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    if (username != null) {
      await prefs.setString(_usernameKey, username);
    }
    await prefs.setInt(_tokenExpiryKey, _tokenExpiry!.millisecondsSinceEpoch);
  }

  /// ลบ token ที่เก็บไว้
  Future<void> clearToken() async {
    _cachedToken = null;
    _cachedUsername = null;
    _tokenExpiry = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_tokenExpiryKey);
  }

  /// ตรวจสอบว่า token ยังใช้งานได้หรือไม่
  bool _isTokenValid() {
    if (_tokenExpiry == null) return true; // Assume valid if no expiry set
    return DateTime.now().isBefore(_tokenExpiry!);
  }

  /// Refresh token (get new one)
  Future<String> refreshToken() async {
    await clearToken();
    return await getOrCreateToken();
  }
}

/// Exception สำหรับกรณี token generation failed
class TokenGenerationException implements Exception {
  final String message;
  final int statusCode;

  TokenGenerationException(this.message, this.statusCode);

  @override
  String toString() =>
      'TokenGenerationException: $message (Status: $statusCode)';
}

/// Exception สำหรับกรณี forbidden (เช่น ยังไม่ถึงเวลา)
class TokenForbiddenException implements Exception {
  final String message;
  final Map<String, dynamic> errorData;

  TokenForbiddenException(this.message, this.errorData);

  @override
  String toString() => 'TokenForbiddenException: $message';
}
