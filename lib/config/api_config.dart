import 'package:flutter_dotenv/flutter_dotenv.dart';

// Global API Configuration
class ApiConfig {
  // Base API URL - loaded from .env file
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api';

  // API Endpoints
  static String get uploadCardImage => '$baseUrl/upload/card-image';
  static String get guestTokens => '$baseUrl/auth/tokens/guest';
  static String get cards => '$baseUrl/cards';

  // Helper method for image proxy
  static String imageProxy(String imageUrl) {
    return '$cards/image-proxy?url=${Uri.encodeComponent(imageUrl)}';
  }

  // Helper method to build custom endpoint
  static String endpoint(String path) {
    return '$baseUrl$path';
  }
}
