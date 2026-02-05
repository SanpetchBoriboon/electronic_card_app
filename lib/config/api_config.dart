// Global API Configuration
class ApiConfig {
  // Base API URL - เปลี่ยน URL ตามจริงของ server
  static const String baseUrl = 'http://localhost:3000/api';

  // API Endpoints
  static const String uploadCardImage = '$baseUrl/upload/card-image';
  static const String guestTokens = '$baseUrl/auth/tokens/guest';
  static const String cards = '$baseUrl/cards';

  // Helper method for image proxy
  static String imageProxy(String imageUrl) {
    return '$cards/image-proxy?url=${Uri.encodeComponent(imageUrl)}';
  }

  // Helper method to build custom endpoint
  static String endpoint(String path) {
    return '$baseUrl$path';
  }
}
