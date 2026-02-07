import 'package:electronic_card_app/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Global color constant
const Color kPrimaryColor = Color(0xFF7E8B78);

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFC6B4), // Background color from image
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Dress Code Section
              Text(
                'DRESS CODE :',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),

              // Color circles
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildColorCircle(const Color(0xFF7E8B78)),
                  const SizedBox(width: 15),
                  _buildColorCircle(const Color(0xFFBFC6B4)),
                  const SizedBox(width: 15),
                  _buildColorCircle(const Color(0xFFE1E6D5)),
                  const SizedBox(width: 15),
                  _buildColorCircle(const Color(0xFFF8F3C7)),
                  const SizedBox(width: 15),
                  _buildColorCircle(const Color(0xFFE9C56E)),
                ],
              ),
              const SizedBox(height: 40),

              // Hashtag
              Text(
                '#เบญจเมแต่งแล้วครับ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.8),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Map Section
              GestureDetector(
                onTap: () async {
                  // Open Google Maps for "บ้านไม้ สาย 3 กรุงเทพ"
                  final url = Uri.parse(
                    'https://www.google.com/maps/search/%E0%B8%9A%E0%B9%89%E0%B8%B2%E0%B8%99%E0%B9%84%E0%B8%A1%E0%B9%89+%E0%B8%AA%E0%B8%B2%E0%B8%A2+3+%E0%B8%81%E0%B8%A3%E0%B8%B8%E0%B8%87%E0%B9%80%E0%B8%97%E0%B8%9E',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFBFC6B4).withValues(alpha: 0.3),
                            const Color(0xFF7E8B78).withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 60,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'บ้านไม้สาย 3',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'กรุงเทพมหานคร',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: kPrimaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'แตะเพื่อดูแผนที่',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Journey Timeline
              _buildTimelineItem(
                '07.00 น.',
                'พิธีสงฆ์',
                customIcon: Image.asset(
                  'assets/icons/monk.png',
                  width: 24,
                  height: 24,
                  color: kPrimaryColor,
                ),
                isFirst: true,
              ),
              _buildTimelineItem(
                '08.29 น.',
                'พิธีแห่ขันหมาก',
                customIcon: Image.asset(
                  'assets/icons/gift.png',
                  width: 24,
                  height: 24,
                  color: kPrimaryColor,
                ),
              ),
              _buildTimelineItem(
                '09.00 น.',
                'พิธีหมั้น',
                customIcon: Image.asset(
                  'assets/icons/ring.png',
                  width: 24,
                  height: 24,
                  color: kPrimaryColor,
                ),
              ),
              _buildTimelineItem(
                '10.00 น.',
                'พิธีผูกข้อไม้ข้อมือ',
                customIcon: Image.asset(
                  'assets/icons/wedding.png',
                  width: 24,
                  height: 24,
                  color: kPrimaryColor,
                ),
              ),
              _buildTimelineItem(
                '11.00 น.',
                'ฉลองมงคลสมรส (บุฟเฟ่ต์)',
                customIcon: Image.asset(
                  'assets/icons/after-party.png',
                  width: 24,
                  height: 24,
                  color: kPrimaryColor,
                ),
                isLast: true,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorCircle(Color color) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String time,
    String activity, {
    IconData? iconData,
    Widget? customIcon,
    bool isFirst = false,
    bool isLast = false,
  }) {
    // ต้องมีอย่างน้อย 1 อัน
    assert(iconData != null || customIcon != null);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Timeline indicator column
        SizedBox(
          width: 50,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Vertical line
              Positioned(
                left: 23,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              // Circle with icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child:
                      customIcon ??
                      Icon(iconData, color: kPrimaryColor, size: 24),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        // Content
        Expanded(
          child: Container(
            margin: EdgeInsets.only(
              top: isFirst ? 0 : 10,
              bottom: isLast ? 0 : 10,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: AppFonts.kanit(
                    fontSize: 14,
                    color: kPrimaryColor,
                    fontWeight: AppFonts.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  activity,
                  style: AppFonts.kanit(
                    fontSize: 16,
                    color: Colors.grey[800],
                    fontWeight: AppFonts.light,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
