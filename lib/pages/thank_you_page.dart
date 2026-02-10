import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../utils/utils.dart';

// Global color constants
const Color kPrimaryColor = Color(0xFF7E8B78);
const Color kBackgroundColor = Color(0xFFE8F4F0);
const Color kSunflowerYellow = Color(0xFFFFD700);
const Color kSunflowerOrange = Color(0xFFFF8C00);

class ThankYouPage extends StatefulWidget {
  const ThankYouPage({super.key});

  @override
  State<ThankYouPage> createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<Map<String, dynamic>> _wishes = [];
  bool _isLoading = true;
  Timer? _refreshTimer;
  String? _lastDataHash; // For checking data changes
  DateTime? _allowedDate;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    // Load wishes data
    _loadWishes();

    // Start auto refresh timer to check for changes every 3 seconds
    _startAutoRefreshTimer();
  }

  void _startAutoRefreshTimer() async {
    // Check if it's the wedding day
    bool isWeddingDay = await _isWeddingDay();

    if (!isWeddingDay) {
      // If not wedding day (before or after), don't start timer
      return;
    }

    // If wedding day, start periodic timer
    _refreshTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      _checkForDataChanges();
    });
  }

  Future<DateTime?> _getAllowedDateFromToken() async {
    if (_allowedDate != null) {
      return _allowedDate;
    }

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.guestTokens),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final allowedDateString = data['allowedDate'] as String?;
        if (allowedDateString != null) {
          _allowedDate = DateTime.parse(allowedDateString);
          return _allowedDate;
        }
      } else if (response.statusCode == 403) {
        final errorData = json.decode(response.body);
        final allowedDateString = errorData['allowedDate'] as String?;
        if (allowedDateString != null) {
          _allowedDate = DateTime.parse(allowedDateString);
          return _allowedDate;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching allowed date: $e');
      }
    }

    return null;
  }

  Future<bool> _isWeddingDay() async {
    final now = DateTime.now();
    final allowedDate = await _getAllowedDateFromToken();

    if (allowedDate == null) {
      return false;
    }

    final nowDate = DateTime(now.year, now.month, now.day);
    final allowedDateOnly = DateTime(
      allowedDate.year,
      allowedDate.month,
      allowedDate.day,
    );

    // Return true only if today is exactly the wedding day
    return nowDate.isAtSameMomentAs(allowedDateOnly);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkForDataChanges() async {
    try {
      // Get stored token using TokenUtils
      String token = await TokenUtils.getOrGenerateToken();

      final response = await http.get(
        Uri.parse(ApiConfig.cards),
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers':
              'Origin, Content-Type, Accept, Authorization, X-Request-With',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final String newDataHash = _generateDataHash(response.body);

        // Only update if data has changed
        if (_lastDataHash != null && _lastDataHash != newDataHash) {
          if (kDebugMode) {
            debugPrint('Data changed, updating wishes...');
          }
          _parseAndUpdateWishes(response.body);
        } else if (_lastDataHash == null) {
          // First time loading
          _parseAndUpdateWishes(response.body);
        }

        _lastDataHash = newDataHash;
      }
    } catch (e) {
      // Silently handle errors for background checks
      if (kDebugMode) {
        debugPrint('Background check error: $e');
      }
    }
  }

  String _generateDataHash(String data) {
    // Simple hash function using data length and first/last characters
    // In production, you might want to use a proper hash function
    final bytes = data.codeUnits;
    int hash = 0;
    for (int byte in bytes) {
      hash = hash * 31 + byte;
    }
    return hash.toString();
  }

  void _parseAndUpdateWishes(String responseBody) {
    try {
      final Map<String, dynamic> responseData = json.decode(responseBody);
      final List<dynamic> cardsData = responseData['cards'] ?? [];

      setState(() {
        _wishes = cardsData
            .map(
              (card) => {
                'title': card['title'] ?? 'ไม่ระบุชื่อ',
                'message': card['message'] ?? '',
                'createdAt':
                    card['createdAt'] ?? DateTime.now().toIso8601String(),
                'imageUrl': card['imageUrl'],
                'template': card['template'] ?? '#7E8B78',
              },
            )
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error parsing wishes data: $e');
      }
    }
  }

  Future<void> _loadWishes() async {
    try {
      // Get stored token using TokenUtils
      String token = await TokenUtils.getOrGenerateToken();

      final response = await http.get(
        Uri.parse(ApiConfig.cards),
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers':
              'Origin, Content-Type, Accept, Authorization, X-Request-With',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _lastDataHash = _generateDataHash(response.body);
        _parseAndUpdateWishes(response.body);
      } else {
        // print('Failed to load cards: ${response.statusCode}');
        setState(() {
          _wishes = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      // print('Error loading wishes: $e');
      setState(() {
        _wishes = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/thank-you-logo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Header section
                  _buildHeader(),

                  // Wishes list
                  Expanded(
                    child: _isLoading
                        ? _buildLoadingState()
                        : _buildWishesList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth > 1000;

    return Container(
      height: isLargeScreen
          ? 80.0
          : null, // Increased height to accommodate larger logo
      padding: isLargeScreen
          ? const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0, // Increased vertical padding
            )
          : const EdgeInsets.all(5.0), // Original padding
      decoration: isLargeScreen
          ? BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            )
          : null,
      child: isLargeScreen
          ? // Navbar layout for large screens
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/tag-thank-you.png',
                  height: 80, // Increased from 60 to 80
                  fit: BoxFit.contain,
                ),
                // Add more navbar items here if needed
              ],
            )
          : // Original center layout for small screens
            Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/tag-thank-you.png',
                      height: 80,
                      width: MediaQuery.of(context).size.width / 2,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Text(
            'กำลังโหลดคำอวยพร...',
            style: TextStyle(
              fontSize: 16,
              color: kPrimaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishesList() {
    if (_wishes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 20),
            Text(
              'ยังไม่มีคำอวยพร',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'รอคำอวยพรจากแขกที่รัก',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth > 1000; // Larger than iPhone

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        isLargeScreen ? 40 : 20, // Add extra top padding for large screens
        20,
        20,
      ),
      child: isLargeScreen
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0, // Square cards
              ),
              itemCount: _wishes.length,
              itemBuilder: (context, index) {
                final wish = _wishes[index];
                return _buildWishCard(wish, index);
              },
            )
          : ListView.builder(
              itemCount: _wishes.length,
              itemBuilder: (context, index) {
                final wish = _wishes[index];
                return _buildWishCard(wish, index);
              },
            ),
    );
  }

  Widget _buildWishCard(Map<String, dynamic> wish, int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth > 1000;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200), // Fixed duration - no cascading delay!
      curve: Curves.easeOut,
      margin: isLargeScreen
          ? EdgeInsets
                .zero // GridView handles spacing
          : const EdgeInsets.only(bottom: 16), // ListView spacing
      child: GestureDetector(
        onTap: () => _showWishDetail(wish),
        child: Container(
          padding: EdgeInsets.all(isLargeScreen ? 12 : 20),
          decoration: BoxDecoration(
            color: _parseColor(wish['template']).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _parseColor(wish['template']).withValues(alpha: 0.4),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _parseColor(wish['template']).withValues(alpha: 0.15),
                spreadRadius: 2,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with name and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Container(
                          width: isLargeScreen ? 30 : 40,
                          height: isLargeScreen ? 30 : 40,
                          decoration: BoxDecoration(
                            color: _parseColor(wish['template']),
                            borderRadius: BorderRadius.circular(
                              isLargeScreen ? 15 : 20,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              wish['title']![0].toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isLargeScreen ? 14 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                wish['title'] ?? 'ไม่ระบุชื่อ',
                                style: TextStyle(
                                  fontSize: isLargeScreen ? 12 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: kPrimaryColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (!isLargeScreen)
                                Text(
                                  _formatDate(wish['createdAt']),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (!isLargeScreen)
                    Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.pink[300], size: 20),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.visibility,
                          color: Colors.grey[400],
                          size: 16,
                        ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Message (truncated if too long)
              isLargeScreen
                  ? Expanded(
                      child: Text(
                        wish['message'] ?? '',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[700],
                          height: 1.4,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : Text(
                      wish['message'] ?? '',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                        height: 1.4,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

              // Image if exists (smaller in grid view)
              if (wish['imageUrl'] != null && wish['imageUrl'] != '') ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    height: isLargeScreen
                        ? 250
                        : 200, // 1/3 size for large screen
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _buildImageWidget(
                      wish['imageUrl'],
                      isInDetail: false,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showWishDetail(Map<String, dynamic> wish) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth > 1000;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isLargeScreen
                  ? MediaQuery.of(context).size.width *
                        0.7 // Wider for large screen
                  : MediaQuery.of(context).size.width * 0.9,
              maxHeight: isLargeScreen
                  ? MediaQuery.of(context).size.height *
                        0.6 // Less height for landscape style
                  : MediaQuery.of(context).size.height * 0.8,
            ),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _parseColor(wish['template']),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          wish['title']![0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wish['title'] ?? 'ไม่ระบุชื่อ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
                          ),
                          Text(
                            _formatDate(wish['createdAt']),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, color: Colors.grey[600]),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Full message
                Flexible(
                  child:
                      isLargeScreen &&
                          wish['imageUrl'] != null &&
                          wish['imageUrl'] != ''
                      ? // Horizontal layout for large screen with image
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Message section (left side)
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ข้อความ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: _parseColor(
                                          wish['template'],
                                        ).withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _parseColor(
                                            wish['template'],
                                          ).withValues(alpha: 0.5),
                                        ),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Text(
                                          wish['message'] ?? '',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[700],
                                            height: 1.8,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Image section (right side)
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'รูปภาพ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: _buildImageWidget(
                                          wish['imageUrl'],
                                          isInDetail: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : // Original vertical layout for small screen or no image
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ข้อความ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: kPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _parseColor(
                                    wish['template'],
                                  ).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _parseColor(
                                      wish['template'],
                                    ).withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Text(
                                  wish['message'] ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                    height: 1.8,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                              // Image if exists
                              if (wish['imageUrl'] != null &&
                                  wish['imageUrl'] != '') ...[
                                const SizedBox(height: 24),
                                Text(
                                  'รูปภาพ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: double.infinity,
                                    constraints: BoxConstraints(maxHeight: 300),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: _buildImageWidget(
                                      wish['imageUrl'],
                                      isInDetail: true,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageWidget(String imageUrl, {bool isInDetail = false}) {
    // Use the new image proxy endpoint for both web and mobile
    final String proxyUrl = ApiConfig.imageProxy(imageUrl);

    Widget imageWidget = Image.network(
      proxyUrl,
      fit: BoxFit.cover,
      cacheWidth: isInDetail ? 1500 : 800, // Optimize width, maintains aspect ratio
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                : null,
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // print('Image proxy error: $error');
        // print('Original URL: $imageUrl');
        // print('Proxy URL: $proxyUrl');

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, color: Colors.grey[400], size: 40),
              const SizedBox(height: 8),
              Text(
                'ไม่สามารถโหลดรูปได้',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
              Text(
                'ลองใหม่ในภายหลัง',
                style: TextStyle(color: Colors.grey[400], fontSize: 10),
              ),
            ],
          ),
        );
      },
    );

    // Add tap functionality for detail view
    if (isInDetail) {
      return GestureDetector(
        onTap: () => _showImagePopup(proxyUrl, imageUrl),
        child: Stack(
          children: [
            imageWidget,
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.zoom_in, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      );
    }

    return imageWidget;
  }

  void _showImagePopup(String proxyUrl, String originalUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              // Black background
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withValues(alpha: 0.9),
              ),

              // Close button
              Positioned(
                top: 50,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                ),
              ),

              // Image
              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.95,
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  child: Image.network(
                    proxyUrl,
                    fit: BoxFit.contain,
                    cacheWidth: 2000, // High-res modal, maintains aspect ratio
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              color: Colors.white,
                              size: 60,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'ไม่สามารถโหลดรูปได้',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      return kPrimaryColor; // fallback color
    }

    try {
      // Remove # if present
      String colorCode = colorString.replaceAll('#', '');

      // Add FF for alpha if not provided (make it fully opaque)
      if (colorCode.length == 6) {
        colorCode = 'FF$colorCode';
      }

      return Color(int.parse(colorCode, radix: 16));
    } catch (e) {
      // print('Error parsing color: $colorString');
      return kPrimaryColor; // fallback color
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';

    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'วันนี้';
      } else if (difference.inDays == 1) {
        return 'เมื่อวาน';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} วันที่แล้ว';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return '';
    }
  }
}
