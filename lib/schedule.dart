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

              // Schedule Items
              _buildScheduleItem('พิธีสวดมนต์', '07.00 น.'),
              const SizedBox(height: 10),
              _buildScheduleItem('พิธีแห่ขันหมาก', '08.29 น.'),
              const SizedBox(height: 10),
              _buildScheduleItem('พิธีหมั้น', '09.00 น.'),
              const SizedBox(height: 10),
              _buildScheduleItem('พิธีผูกข้อมือใข้อมือ', '10.00 น.'),
              const SizedBox(height: 10),
              _buildScheduleItem('ฉลองมงคลสมรส (บุฟเฟ่ต์)', '11.00 น.'),
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
                              Icons.map_outlined,
                              size: 60,
                              color: kPrimaryColor,
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

  Widget _buildScheduleItem(String activity, String time) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              activity,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
