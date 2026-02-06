// Global API Configuration
class ApiConfig {
  // Base API URL - loaded from dart-define or fallback to localhost
  static String get baseUrl {
    // Check for dart-define first (for production builds)
    const apiUrl = String.fromEnvironment('API_BASE_URL');
    if (apiUrl.isNotEmpty) {
      return apiUrl;
    }

    // Fallback to localhost for development
    return 'http://localhost:3000/api';
  }

  // API Endpoints
  static String get uploadCardImage => '$baseUrl/upload/card-image';
  static String get guestTokens => '$baseUrl/auth/guest/tokens';
  static String get cards => '$baseUrl/cards';
  static String get images => '$baseUrl/images';

  // Helper method for image proxy
  static String imageProxy(String imageUrl) {
    return '$cards/image-proxy?url=${Uri.encodeComponent(imageUrl)}';
  }

  // Helper method to build custom endpoint
  static String endpoint(String path) {
    return '$baseUrl$path';
  }
}
