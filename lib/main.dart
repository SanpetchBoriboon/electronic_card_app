import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'gallery.dart';
import 'schedule.dart';
import 'splash_screen.dart';
import 'thank_you_page.dart';
import 'wishes.dart';

// Global color constant
const Color kPrimaryColor = Color(0xFF7E8B78);

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wedding Invitation',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'Times New Roman',
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late Timer _timer;
  late DateTime _weddingDate;
  Duration _timeRemaining = Duration.zero;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFlipped = false;
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _weddingDate = DateTime(2026, 2, 26); // Wedding date: February 26, 2026
    _startTimer();

    // Initialize flip animation
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeRemaining = _weddingDate.difference(DateTime.now());
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

  @override
  void dispose() {
    _timer.cancel();
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
    double logoSize = screenWidth * 0.5; // 50% of screen width

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          // Wedding Invitation Page
          GestureDetector(
            onTap: _flipCard,
            child: Container(
              color: Colors.white,
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
          // Wishes Page
          const WishesPage(),
          // Thank You Page
          const ThankYouPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: Colors.white,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'การ์ดเชิญ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'กำหนดการ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'แกลเลอรี่',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: 'คำอวยพร',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'ขอบคุณ',
          ),
        ],
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
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
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

            // Invitation text
            Text(
              'invite you to celebrate',
              style: TextStyle(
                fontSize: 18,
                color: kPrimaryColor,
                fontStyle: FontStyle.italic,
                letterSpacing: 1.0,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'our wedding',
              style: TextStyle(
                fontSize: 18,
                color: kPrimaryColor,
                fontStyle: FontStyle.italic,
                letterSpacing: 1.0,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Wedding date
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '26',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: kPrimaryColor,
                  ),
                ),
                Text(
                  '  |  ',
                  style: TextStyle(fontSize: 20, color: kPrimaryColor),
                ),
                Text(
                  '02',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: kPrimaryColor,
                  ),
                ),
                Text(
                  '  |  ',
                  style: TextStyle(fontSize: 20, color: kPrimaryColor),
                ),
                Text(
                  '2026',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Message
            Text(
              'WE LOOK FORWARD TO YOUR PRESENCE',
              style: TextStyle(
                fontSize: 12,
                color: kPrimaryColor,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'ON OUR SPECIAL DAY.',
              style: TextStyle(
                fontSize: 12,
                color: kPrimaryColor,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Countdown timer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCountdownItem(days.toString().padLeft(2, '0'), 'Day'),
                _buildCountdownItem(hours.toString().padLeft(2, '0'), 'Hours'),
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
    );
  }

  Widget _buildBackPage(double screenWidth) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ชื่อพ่อแม่
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left column
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'นายมนตรี กรวิริยะกิจ',
                        style: TextStyle(
                          fontSize: 16,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'นางสุรพงษ์ กรวิริยะกิจ',
                        style: TextStyle(
                          fontSize: 16,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w500,
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
                    style: TextStyle(fontSize: 14, color: kPrimaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Right column
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'นายเจริญ บริบูรณ์',
                        style: TextStyle(
                          fontSize: 16,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'นางญัฐธยาน์ บริบูรณ์',
                        style: TextStyle(
                          fontSize: 16,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w500,
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
              style: TextStyle(fontSize: 14, color: kPrimaryColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),

            // Main Logo
            SizedBox(
              height: screenWidth * 0.33 + 20,
              child: Center(
                child: Image.asset(
                  'assets/images/main-logo.png',
                  height: screenWidth * 0.33,
                  width: screenWidth * 0.33,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: screenWidth * 0.33,
                      width: screenWidth * 0.33,
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
              style: TextStyle(
                fontSize: 18,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'นายสรรเพชญ บริบูรณ์',
              style: TextStyle(
                fontSize: 18,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // วันที่
            Text(
              '26.02.2026',
              style: TextStyle(
                fontSize: 28,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'ณ บ้านไม้ สาย 3 กรุงเทพฯ',
              style: TextStyle(fontSize: 16, color: kPrimaryColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),

            // กำหนดการ
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTimeItem('07.00 น.', 'พิธีสวดมนต์'),
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
                    color: kPrimaryColor.withOpacity(0.3),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTimeItem('10.00 น.', 'พิธีผูกข้อมือข้อมือ'),
                        const SizedBox(height: 12),
                        _buildTimeItem('11.00 น.', 'ฉลองมงคลสมรส\n(บุฟเฟ่ต์)'),
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
                  style: TextStyle(
                    fontSize: 12,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w100,
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
              style: TextStyle(fontSize: 14, color: kPrimaryColor),
              textAlign: TextAlign.center,
            ),

            // Extra spacing for better scrolling
            const SizedBox(height: 40),
          ],
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
            style: TextStyle(
              fontSize: 14,
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(activity, style: TextStyle(fontSize: 12, color: kPrimaryColor)),
        ],
      ),
    );
  }

  Widget _buildCountdownItem(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
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
