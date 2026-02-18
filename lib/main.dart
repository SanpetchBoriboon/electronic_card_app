import 'dart:async';

import 'package:flutter/material.dart';

import 'font_styles.dart';
import 'pages/gallery.dart';
import 'pages/schedule.dart';
import 'pages/splash_screen.dart';
import 'pages/thank_you_page.dart';
import 'pages/wishes.dart';
import 'services/auth_service.dart';

// Global color constant
const Color kPrimaryColor = Color(0xFF7E8B78);

void main() {
  // Configure image cache for better memory management on mobile
  WidgetsFlutterBinding.ensureInitialized();

  // Set image cache limits (30MB cache, 200 images max) - Optimized for mobile!
  PaintingBinding.instance.imageCache.maximumSizeBytes =
      30 * 1024 * 1024; // 30MB (reduced from 100MB)
  PaintingBinding.instance.imageCache.maximumSize =
      200; // 200 images (reduced from 1000)

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ben Mea The Wedding',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'Kanit', // Use Kanit as default
        textTheme: TextTheme(
          displayLarge: AppFonts.kanit(fontWeight: AppFonts.light),
          displayMedium: AppFonts.kanit(fontWeight: AppFonts.light),
          displaySmall: AppFonts.kanit(fontWeight: AppFonts.light),
          headlineLarge: AppFonts.kanit(fontWeight: AppFonts.light),
          headlineMedium: AppFonts.kanit(fontWeight: AppFonts.light),
          headlineSmall: AppFonts.kanit(fontWeight: AppFonts.light),
          titleLarge: AppFonts.kanit(fontWeight: AppFonts.light),
          titleMedium: AppFonts.kanit(fontWeight: AppFonts.light),
          titleSmall: AppFonts.kanit(fontWeight: AppFonts.light),
          bodyLarge: AppFonts.kanit(fontWeight: AppFonts.light),
          bodyMedium: AppFonts.kanit(fontWeight: AppFonts.light),
          bodySmall: AppFonts.kanit(fontWeight: AppFonts.light),
          labelLarge: AppFonts.kanit(fontWeight: AppFonts.light),
          labelMedium: AppFonts.kanit(fontWeight: AppFonts.light),
          labelSmall: AppFonts.kanit(fontWeight: AppFonts.light),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const MyHomePage(),
        '/thank-you': (context) => const MyHomePage(initialIndex: 4),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int initialIndex;

  const MyHomePage({super.key, this.initialIndex = 0});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late Timer _timer;
  DateTime? _weddingDate;
  Duration _timeRemaining = Duration.zero;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFlipped = false;
  int _currentIndex = 0;
  late PageController _pageController;
  bool _hasShownWelcomePopup = false;
  bool _isWeddingTime = false; // Track if wedding time has arrived

  @override
  void initState() {
    super.initState();
    _fetchAllowedDate(); // Fetch wedding date from API
    _startTimer();

    // Adjust initial index if trying to access hidden pages
    int adjustedIndex = widget.initialIndex;
    if (!_isWeddingDateReached() && widget.initialIndex > 2) {
      adjustedIndex =
          0; // Redirect to home if trying to access wishes/thank you
    }
    _currentIndex = adjustedIndex;

    // Initialize PageController
    _pageController = PageController(initialPage: adjustedIndex);

    // Initialize flip animation - FASTER!
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 400), // Reduced from 800ms
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Images will be loaded lazily when needed
  }

  Future<void> _fetchAllowedDate() async {
    try {
      // Use AuthService to get token (already fetched in splash screen)
      final authService = AuthService();
      final token = await authService.getToken();

      if (token != null) {
        // Token exists, try to get allowed date from user data
        final result = await authService.generateGuestToken();
        final allowedDateString = result['user']?['allowedDate'] as String?;
        if (allowedDateString != null && mounted) {
          setState(() {
            _weddingDate = DateTime.parse(allowedDateString);
          });
          return;
        }
      }
    } on TokenForbiddenException catch (e) {
      // Handle forbidden error
      final allowedDateString = e.errorData['allowedDate'] as String?;
      if (allowedDateString != null && mounted) {
        setState(() {
          _weddingDate = DateTime.parse(allowedDateString);
        });
        return;
      }
    } catch (e) {
      // Do nothing, will use fallback below
    }

    // Fallback to hardcoded date if API fails or no date found
    if (mounted && _weddingDate == null) {
      setState(() {
        _weddingDate = DateTime(2026, 2, 26);
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Skip calculation if wedding date hasn't been fetched yet
      if (_weddingDate == null) return;

      final now = DateTime.now();
      final difference = _weddingDate!.difference(now);

      setState(() {
        if (difference.inSeconds <= 0) {
          // Wedding time has arrived!
          _isWeddingTime = true;
          _timeRemaining = Duration.zero;

          // Show welcome popup once
          if (!_hasShownWelcomePopup) {
            _hasShownWelcomePopup = true;
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                _showWelcomePopup();
              }
            });
          }
        } else {
          // Still counting down
          _timeRemaining = difference;
        }
      });
    });
  }

  void _flipCard() {
    if (!_isFlipped) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  bool _isWeddingDateReached() {
    if (_weddingDate == null) return false; // Not reached if not fetched yet
    final now = DateTime.now();
    return now.isAfter(_weddingDate!) || now.isAtSameMomentAs(_weddingDate!);
  }

  List<Widget> _getPages(
    double screenWidth,
    double logoSize,
    int days,
    int hours,
    int minutes,
    int seconds,
  ) {
    List<Widget> pages = [
      // Wedding Invitation Page
      GestureDetector(
        onTap: _flipCard,
        child: Container(
          color: screenWidth > 768 ? Colors.grey[100] : Colors.white,
          child: SafeArea(
            child: AnimatedBuilder(
              animation: _flipAnimation,
              builder: (context, child) {
                final isShowingFront = _flipAnimation.value < 0.5;
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(_flipAnimation.value * 3.14159),
                  child: isShowingFront
                      ? _buildFrontPage(
                          screenWidth,
                          logoSize,
                          days,
                          hours,
                          minutes,
                          seconds,
                        )
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(3.14159),
                          child: _buildBackPage(screenWidth),
                        ),
                );
              },
            ),
          ),
        ),
      ),
      // Schedule Page
      const SchedulePage(),
      // Gallery Page
      const GalleryPage(),
    ];

    // Only add Wishes and Thank You pages if wedding date has been reached
    if (_isWeddingDateReached()) {
      pages.add(const WishesPage());
      pages.add(const ThankYouPage());
    }

    return pages;
  }

  List<BottomNavigationBarItem> _getNavigationItems() {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: Builder(
          builder: (context) {
            try {
              return Image.asset(
                'assets/icons/wedding-invitation.png',
                width: 24,
                height: 24,
                color: _currentIndex == 0 ? kPrimaryColor : Colors.grey,
                colorBlendMode: BlendMode.srcIn,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.card_giftcard,
                    size: 24,
                    color: _currentIndex == 0 ? kPrimaryColor : Colors.grey,
                  );
                },
              );
            } catch (e) {
              return Icon(
                Icons.card_giftcard,
                size: 24,
                color: _currentIndex == 0 ? kPrimaryColor : Colors.grey,
              );
            }
          },
        ),
        label: 'การ์ดเชิญ',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.event,
          color: _currentIndex == 1 ? kPrimaryColor : Colors.grey,
        ),
        label: 'กำหนดการ',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.photo_library,
          color: _currentIndex == 2 ? kPrimaryColor : Colors.grey,
        ),
        label: 'แกลเลอรี่',
      ),
    ];

    // Only add Wishes and Thank You navigation items if wedding date has been reached
    if (_isWeddingDateReached()) {
      items.add(
        BottomNavigationBarItem(
          icon: Icon(
            Icons.edit_note,
            color: _currentIndex == 3 ? kPrimaryColor : Colors.grey,
          ),
          label: 'เขียนคำอวยพร',
        ),
      );
      items.add(
        BottomNavigationBarItem(
          icon: Icon(
            Icons.auto_awesome,
            color: _currentIndex == 4 ? kPrimaryColor : Colors.grey,
          ),
          label: 'ดูคำอวยพร',
        ),
      );
    }

    return items;
  }

  void _showWelcomePopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Project Logo
                Image.asset(
                  'assets/images/main-logo.png',
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.favorite,
                        size: 60,
                        color: kPrimaryColor,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 25),
                // Welcome text
                Text(
                  'ยินดีต้อนรับ!',
                  style: AppFonts.kanit(
                    fontSize: 32,
                    fontWeight: AppFonts.bold,
                    color: kPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  'วันพิเศษของเราถึงแล้ว!',
                  style: AppFonts.kanit(
                    fontSize: 20,
                    fontWeight: AppFonts.regular,
                    color: kPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'ขอบคุณที่มาร่วมแบ่งปันความสุขกับเรา',
                  style: AppFonts.kanit(
                    fontSize: 16,
                    fontWeight: AppFonts.light,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                // Close button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Flip to back card after closing popup
                    if (!_isFlipped) {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (mounted) {
                          _flipCard();
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'เข้าสู่งานแต่งงาน',
                    style: AppFonts.kanit(
                      fontSize: 16,
                      fontWeight: AppFonts.regular,
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

  @override
  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    _flipController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int days = _timeRemaining.inDays;
    int hours = _timeRemaining.inHours.remainder(24);
    int minutes = _timeRemaining.inMinutes.remainder(60);
    int seconds = _timeRemaining.inSeconds.remainder(60);

    // Get screen size for responsive logo
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate logo size: 1/3 of card for desktop, 50% screen for mobile
    double logoSize = screenWidth > 768
        ? 600 /
              3 // Desktop: 1/3 of 600px card = 200px
        : screenWidth * 0.5; // Mobile: 50% of screen

    return Scaffold(
      body: Container(
        color: screenWidth > 768 ? Colors.grey[100] : Colors.white,
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: _getPages(
            screenWidth,
            logoSize,
            days,
            hours,
            minutes,
            seconds,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(
              milliseconds: 250,
            ), // Faster page transitions
            curve: Curves.easeOut, // Snappier curve
          );
        },
        backgroundColor: Colors.white,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
        items: _getNavigationItems(),
      ),
    );
  }

  Widget _buildFrontPage(
    double screenWidth,
    double logoSize,
    int days,
    int hours,
    int minutes,
    int seconds,
  ) {
    // Calculate card width based on screen size
    double cardWidth = screenWidth > 768 ? 600 : screenWidth;
    double cardPadding = screenWidth > 768 ? 40.0 : 20.0;

    return Center(
      child: Container(
        width: cardWidth,
        constraints: BoxConstraints(
          maxWidth: 600, // Maximum width for desktop
          minHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth > 768 ? 40 : 0,
          vertical: 20,
        ),
        decoration: screenWidth > 768
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: const Offset(0, 3),
                  ),
                ],
              )
            : null,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: cardPadding,
            vertical: 40.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main logo
              SizedBox(
                height: logoSize + 20,
                child: Center(
                  child: Image.asset(
                    'assets/images/main-logo.png',
                    height: logoSize,
                    width: logoSize,
                    fit: BoxFit.contain,
                    cacheWidth: (logoSize * 2)
                        .toInt(), // 2x for Retina, maintains aspect
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: logoSize,
                        width: logoSize,
                        decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: kPrimaryColor,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Invitation text - using AppFonts
              Text(
                'invite you to celebrate',
                style: AppFonts.crimsonPro(
                  fontSize: 18,
                  color: kPrimaryColor,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              Text(
                'our wedding',
                style: AppFonts.crimsonPro(
                  fontSize: 18,
                  color: kPrimaryColor,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 20),

              // Wedding date
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '26',
                    style: AppFonts.glacialIndifference(
                      fontSize: 24,
                      fontWeight: AppFonts.light,
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    '  |  ',
                    style: AppFonts.glacialIndifference(
                      fontSize: 20,
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    '02',
                    style: AppFonts.glacialIndifference(
                      fontSize: 24,
                      fontWeight: AppFonts.light,
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    '  |  ',
                    style: AppFonts.glacialIndifference(
                      fontSize: 20,
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    '2026',
                    style: AppFonts.glacialIndifference(
                      fontSize: 24,
                      fontWeight: AppFonts.light,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Message
              Text(
                'WE LOOK FORWARD TO YOUR PRESENCE',
                style: AppFonts.season(
                  fontSize: 12,
                  color: kPrimaryColor,
                  letterSpacing: 2.0,
                  fontWeight: AppFonts.regular,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              Text(
                'ON OUR SPECIAL DAY.',
                style: AppFonts.season(
                  fontSize: 12,
                  color: kPrimaryColor,
                  letterSpacing: 2.0,
                  fontWeight: AppFonts.regular,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 20),

              // Countdown timer - Hide when wedding time arrives
              if (!_isWeddingTime)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCountdownItem(days.toString().padLeft(2, '0'), 'Day'),
                    _buildCountdownItem(
                      hours.toString().padLeft(2, '0'),
                      'Hours',
                    ),
                    _buildCountdownItem(
                      minutes.toString().padLeft(2, '0'),
                      'Minutes',
                    ),
                    _buildCountdownItem(
                      seconds.toString().padLeft(2, '0'),
                      'Second',
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackPage(double screenWidth) {
    // Calculate card width based on screen size
    double cardWidth = screenWidth > 768 ? 600 : screenWidth;
    double cardPadding = screenWidth > 768 ? 40.0 : 30.0;

    return Center(
      child: Container(
        width: cardWidth,
        constraints: BoxConstraints(
          maxWidth: 600,
          minHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth > 768 ? 40 : 0,
          vertical: 20,
        ),
        decoration: screenWidth > 768
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: const Offset(0, 3),
                  ),
                ],
              )
            : null,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: cardPadding,
            vertical: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ชื่อพ่อแม่
              screenWidth < 400
                  ? Column(
                      children: [
                        // Left side parents
                        Column(
                          children: [
                            Text(
                              'นายมนตรี กรวิริยะกิจ',
                              style: AppFonts.kanit(
                                fontSize: 16,
                                color: kPrimaryColor,
                                fontWeight: AppFonts.medium,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'นางสุรพจน์ กรวิริยะกิจ',
                              style: AppFonts.kanit(
                                fontSize: 16,
                                color: kPrimaryColor,
                                fontWeight: AppFonts.medium,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Center "และ"
                        Text(
                          'และ',
                          style: AppFonts.kanit(
                            fontSize: 14,
                            color: kPrimaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        // Right side parents
                        Column(
                          children: [
                            Text(
                              'นายเจริญ บริบูรณ์',
                              style: AppFonts.kanit(
                                fontSize: 16,
                                color: kPrimaryColor,
                                fontWeight: AppFonts.medium,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'นางญัฐธยาน์ บริบูรณ์',
                              style: AppFonts.kanit(
                                fontSize: 16,
                                color: kPrimaryColor,
                                fontWeight: AppFonts.medium,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left column
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'นายมนตรี กรวิริยะกิจ',
                                style: AppFonts.kanit(
                                  fontSize: 16,
                                  color: kPrimaryColor,
                                  fontWeight: AppFonts.medium,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'นางสุรพจน์ กรวิริยะกิจ',
                                style: AppFonts.kanit(
                                  fontSize: 16,
                                  color: kPrimaryColor,
                                  fontWeight: AppFonts.medium,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        // Center "และ"
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'และ',
                            style: AppFonts.kanit(
                              fontSize: 14,
                              color: kPrimaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Right column
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'นายเจริญ บริบูรณ์',
                                style: AppFonts.kanit(
                                  fontSize: 16,
                                  color: kPrimaryColor,
                                  fontWeight: AppFonts.medium,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'นางญัฐธยาน์ บริบูรณ์',
                                style: AppFonts.kanit(
                                  fontSize: 16,
                                  color: kPrimaryColor,
                                  fontWeight: AppFonts.medium,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 20),

              // ข้อความเชิญ
              Text(
                'มีความยินดีขอเรียนเชิญเพื่อมาเป็นเกียรติในพิธีมงคงสมรสระหว่าง',
                style: AppFonts.kanit(fontSize: 14, color: kPrimaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),

              // Main Logo
              SizedBox(
                height: screenWidth * 0.1,
                child: Center(
                  child: Image.asset(
                    'assets/images/main-logo.png',
                    height: screenWidth * 0.1,
                    width: screenWidth * 0.1,
                    fit: BoxFit.contain,
                    cacheWidth: (screenWidth * 0.2)
                        .toInt(), // 2x for Retina, maintains aspect
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: screenWidth * 0.09,
                        width: screenWidth * 0.09,
                        decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.image_not_supported,
                          size: screenWidth * 0.1,
                          color: kPrimaryColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // ชื่อคู่บ่าวสาว
              Text(
                'นางสาวอาทิตยา กรวิริยะกิจ',
                style: AppFonts.kanit(
                  fontSize: 18,
                  color: kPrimaryColor,
                  fontWeight: AppFonts.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'นายสรรเพชญ บริบูรณ์',
                style: AppFonts.kanit(
                  fontSize: 18,
                  color: kPrimaryColor,
                  fontWeight: AppFonts.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // วันที่
              Text(
                '26.02.2026',
                style: AppFonts.glacialIndifference(
                  fontSize: 28,
                  color: kPrimaryColor,
                  fontWeight: AppFonts.regular,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'ณ บ้านไม้ สาย 3 กรุงเทพฯ',
                style: AppFonts.kanit(
                  fontSize: 16,
                  color: kPrimaryColor,
                  fontWeight: AppFonts.extraLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),

              // กำหนดการ
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kPrimaryColor.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTimeItem('07.00 น.', 'พิธีสงฆ์'),
                          const SizedBox(height: 12),
                          _buildTimeItem('08.29 น.', 'พิธีแห่ขันหมาก'),
                          const SizedBox(height: 12),
                          _buildTimeItem('09.00 น.', 'พิธีหมั้น'),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 80,
                      color: kPrimaryColor.withValues(alpha: 0.3),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTimeItem('10.00 น.', 'พิธีผูกข้อไม้ข้อมือ'),
                          const SizedBox(height: 12),
                          _buildTimeItem(
                            '11.00 น.',
                            'ฉลองมงคลสมรส\n(บุฟเฟ่ต์)',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Dress Code
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'DRESS CODE : ',
                    style: AppFonts.ttHovesPro(
                      fontSize: 12,
                      color: kPrimaryColor,
                      fontWeight: AppFonts.thin,
                    ),
                  ),
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF7E8B78),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFBFC6B4),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE1E6D5),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF8F3C7),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE9C56E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '#เบญจเมแต่งแล้วครับ',
                style: AppFonts.kanit(
                  fontSize: 14,
                  color: kPrimaryColor,
                  fontWeight: AppFonts.extraLight,
                ),
                textAlign: TextAlign.center,
              ),

              // Extra spacing for better scrolling
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeItem(String time, String activity) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: AppFonts.kanit(
              fontSize: 14,
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            activity,
            style: TextStyle(fontSize: 12, color: kPrimaryColor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownItem(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: kPrimaryColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
