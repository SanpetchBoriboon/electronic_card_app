import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:electronic_card_app/font_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/api_config.dart';
import 'main.dart';

// Global color constant
const Color kPrimaryColor = Color(0xFF7E8B78);

// Token storage keys
const String tokenKey = 'guest_token';
const String usernameKey = 'guest_username';

// Custom exception for time not reached error
class TimeNotReachedException implements Exception {
  final String message;
  TimeNotReachedException(this.message);
}

class WishesPage extends StatefulWidget {
  const WishesPage({super.key});

  @override
  State<WishesPage> createState() => _WishesPageState();
}

class _WishesPageState extends State<WishesPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _wishController = TextEditingController();
  final int _maxLength = 300;
  int _currentLength = 0;
  bool _isSubmitting = false;
  bool _showSuccess = false;
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = [];
  final List<Uint8List> _selectedImagesData = [];
  final List<String> _selectedImageNames =
      []; // Store original filenames for web

  @override
  void initState() {
    super.initState();
    _wishController.addListener(() {
      setState(() {
        _currentLength = _wishController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _wishController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFC6B4), // Sage green background
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Title
                  Text(
                    'เขียนคำอวยพรให้บ่าวสาว',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  // Subtitle
                  Text(
                    'ฝากความรักใส่ในวันพิเศษนี้',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Form Container
                  Center(
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 500, // Maximum width for desktop
                      ),
                      padding: const EdgeInsets.all(25.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Wishes Field
                          Text(
                            'เขียนคำอวยพร',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _wishController,
                              maxLines: 6,
                              maxLength: _maxLength,
                              decoration: InputDecoration(
                                hintText: 'ขอให้รักกันแบบนี้ไปนาน ๆ นะคะ...',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(15),
                                counterText: '',
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),

                          // Character Counter
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '$_currentLength/$_maxLength ตัวอักษร',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Attach Photo Button
                          Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  kPrimaryColor.withValues(alpha: 0.1),
                                  kPrimaryColor.withValues(alpha: 0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: kPrimaryColor.withValues(alpha: 0.3),
                                style: BorderStyle.solid,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: kPrimaryColor.withValues(alpha: 0.1),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: _showImagePickerDialog,
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor.withValues(
                                          alpha: 0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.add_photo_alternate_outlined,
                                        color: kPrimaryColor,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'แนบรูปภาพ',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: kPrimaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '${kIsWeb ? (_selectedImagesData.isNotEmpty ? "1" : "0") : (_selectedImages.isNotEmpty ? "1" : "0")} รูปที่เลือก',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: kPrimaryColor.withValues(
                                        alpha: 0.7,
                                      ),
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Selected Images Preview
                          if ((kIsWeb && _selectedImagesData.isNotEmpty) ||
                              (!kIsWeb && _selectedImages.isNotEmpty))
                            Column(
                              children: [
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.collections_outlined,
                                      color: kPrimaryColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'รูปภาพที่เลือก',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Full width image preview for single image
                                Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(11),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 200,
                                          child: kIsWeb
                                              ? Image.memory(
                                                  _selectedImagesData.first,
                                                  width: double.infinity,
                                                  height: 200,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.file(
                                                  _selectedImages.first,
                                                  width: double.infinity,
                                                  height: 200,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (mounted) {
                                              setState(() {
                                                if (kIsWeb) {
                                                  _selectedImagesData.clear();
                                                  _selectedImageNames.clear();
                                                } else {
                                                  _selectedImages.clear();
                                                }
                                              });
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade500,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.red.withValues(
                                                    alpha: 0.4,
                                                  ),
                                                  spreadRadius: 1,
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                          const SizedBox(height: 30),

                          // Send Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _sendWishes,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 2,
                              ),
                              child: Text(
                                'ส่งคำอวยพร',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Loading Popup
          if (_isSubmitting) _buildLoadingPopup(),

          // Success Popup
          if (_showSuccess) _buildSuccessPopup(),
        ],
      ),
    );
  }

  void _sendWishes() async {
    if (_wishController.text.trim().isEmpty) {
      _showErrorSnackBar('กรุณาเขียนคำอวยพร');
      return;
    }

    // Check if it's the allowed date (February 26, 2026)
    final now = DateTime.now();
    final allowedDate = DateTime(2026, 2, 26);

    if (now.year == allowedDate.year &&
        now.month == allowedDate.month &&
        now.day == allowedDate.day) {
      // Show preview dialog for confirmation
      _showPreviewDialog();
    } else {
      // For testing or if it's not the right date, proceed directly
      _showPreviewDialog();
      // await _submitWish();
    }
  }

  Future<void> _submitWish() async {
    // Show loading
    setState(() {
      _isSubmitting = true;
    });

    try {
      await _submitWishToAPI();

      // Show success popup with delay (like the Angular code)
      await Future.delayed(Duration(milliseconds: 300));
      setState(() {
        _showSuccess = true;
      });
    } catch (e) {
      // Don't show error snackbar for TimeNotReachedException
      if (e is! TimeNotReachedException) {
        _showErrorSnackBar(
          'เกิดข้อผิดพลาดในการส่งคำอวยพร กรุณาลองใหม่อีกครั้ง',
        );
      }
      // print('Error submitting wish: $e');
    } finally {
      // Always clear form and hide loading after submit attempt
      setState(() {
        _isSubmitting = false;
      });
      _clearForm();
    }
  }

  Future<void> _submitWishToAPI() async {
    try {
      // print('Starting API submission...');

      String? token;

      // Check if we have a stored token for this username
      final storedToken = await _getStoredToken();

      if (storedToken != null) {
        // แจ้งผู้ใช้ว่ากำลังใช้ token ที่เก็บไว้
        token = storedToken;
      } else {
        // Generate new token for this username
        token = await _generateGuestToken();
        await _saveToken(token);
      }

      // Step 2: Prepare form data
      // print('Preparing form data...');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.uploadCardImage),
      );

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add form fields
      request.fields['message'] = _wishController.text.trim();

      // Add image if selected
      if (kIsWeb && _selectedImagesData.isNotEmpty) {
        // For web platform
        final imageData = _selectedImagesData.first;
        final imageName = _selectedImageNames.first;
        final imageInfo = _getImageTypeInfo(imageName);
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            imageData,
            filename: 'wish_image.${imageInfo['extension']}',
            contentType: MediaType.parse(imageInfo['contentType']!),
          ),
        );
        // print('Adding web image to request: ${imageData.length} bytes (${imageInfo['contentType']}) - Original: $imageName');
      } else if (!kIsWeb && _selectedImages.isNotEmpty) {
        // For mobile platform
        final imageFile = _selectedImages.first;
        final imageInfo = _getImageTypeInfo(imageFile.path);
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
            filename: 'wish_image.${imageInfo['extension']}',
            contentType: MediaType.parse(imageInfo['contentType']!),
          ),
        );
        // print('Adding mobile image to request: ${imageFile.path} (${imageInfo['contentType']})');
      } else {
        // print('No image selected');
      }

      // Step 3: Send request
      // print('Sending wish data to server...');
      final streamedResponse = await request.send().timeout(
        Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);

      // print('Upload response status: ${response.statusCode}');
      // print('Upload response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // print('Wish submitted successfully');
      } else if (response.statusCode == 401) {
        // Token expired or invalid, clear and try again
        // print('Token invalid, clearing and retrying...');
        await _clearStoredToken();
        throw Exception('Token หมดอายุ กรุณาลองใหม่อีกครั้ง');
      } else {
        throw Exception(
          'Server error: ${response.statusCode} - ${response.body}',
        );
      }
    } on TimeoutException {
      // print('Request timeout');
      throw Exception(
        'การเชื่อมต่อหมดเวลา กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต',
      );
    } on SocketException {
      // print('Network error');
      throw Exception(
        'ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้ กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต',
      );
    } catch (e) {
      // print('API Error: $e');
      rethrow;
    }
  }

  Future<String> _generateGuestToken() async {
    try {
      // print('Generating guest token...');
      final response = await http
          .post(
            Uri.parse(ApiConfig.guestTokens),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(Duration(seconds: 10));

      // print('Token generation response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        // print('Token generated successfully for user: ${data['user']['username']}');
        return token;
      } else {
        // print('Token generation failed: ${response.body}');

        // Check if it's the specific "not time yet" error
        if (response.statusCode == 403) {
          try {
            final errorData = json.decode(response.body);
            if (errorData['error'] == 'Token Request Forbidden' &&
                errorData['message']?.contains('February 26, 2026') == true) {
              _showTimeNotReachedDialog(errorData);
              throw TimeNotReachedException('Time not reached');
            }
          } catch (parseError) {
            if (parseError is TimeNotReachedException) {
              rethrow;
            }
            // print('Error parsing error response: $parseError');
          }
        }

        throw Exception('ไม่สามารถสร้าง token ได้: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error generating token: $e');
      rethrow;
    }
  }

  void _showPreviewDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.preview, color: kPrimaryColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'ยืนยันการส่งคำอวยพร',
                style: AppFonts.kanit(
                  color: kPrimaryColor,
                  fontSize: 20,
                  fontWeight: AppFonts.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'กรุณาตรวจสอบข้อมูลก่อนส่ง',
                  style: AppFonts.kanit(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontWeight: AppFonts.medium,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'ข้อความอวยพร',
                  style: AppFonts.kanit(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontWeight: AppFonts.light,
                  ),
                ),
                const SizedBox(height: 4),
                // Message preview
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _wishController.text.trim(),
                        style: AppFonts.kanit(
                          fontSize: 14,
                          color: Colors.grey[800],
                          height: 1.4,
                          fontWeight: AppFonts.light,
                        ),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Image preview
                if ((kIsWeb && _selectedImagesData.isNotEmpty) ||
                    (!kIsWeb && _selectedImages.isNotEmpty))
                  Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'รูปภาพ',
                              style: AppFonts.kanit(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: AppFonts.light,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: kPrimaryColor.withValues(alpha: 0.2),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: kIsWeb
                                    ? Image.memory(
                                        _selectedImagesData.first,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        _selectedImages.first,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 16),
                Text(
                  'คำอวยพรของคุณจะถูกส่งไปให้บ่าวสาว',
                  style: AppFonts.kanit(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                    fontWeight: AppFonts.light,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(
                'ยกเลิก',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _submitWish();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'ส่งคำอวยพร',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[400],
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showTimeNotReachedDialog(Map<String, dynamic> errorData) {
    // Check if the current date is after the allowed date
    final now = DateTime.now();

    // Parse the allowed date from the error data
    DateTime allowedDate;
    try {
      final allowedDateString = errorData['allowedDate'] as String?;
      if (allowedDateString != null) {
        allowedDate = DateTime.parse(allowedDateString);
      } else {
        allowedDate = DateTime(2026, 2, 26); // Fallback
      }
    } catch (e) {
      allowedDate = DateTime(2026, 2, 26); // Fallback
    }

    final isAfterWeddingDate = now.isAfter(allowedDate);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(
                isAfterWeddingDate ? Icons.event_busy : Icons.access_time,
                color: kPrimaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                isAfterWeddingDate ? 'งานจบแล้ว' : 'ยังไม่ถึงเวลา',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isAfterWeddingDate
                    ? 'การเขียนคำอวยพรได้ปิดให้บริการแล้ว เนื่องจากงานแต่งงานได้จบสิ้นลงแล้ว'
                    : 'การเขียนคำอวยพรจะเปิดให้ใช้งานในวันงานเท่านั้น',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: kPrimaryColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📅 วันที่งานแต่งงาน: ${_formatDateToThai(errorData['allowedDate'])}',
                      style: TextStyle(
                        fontSize: 14,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '📅 วันที่ปัจจุบัน: ${_formatDateToThai(errorData['currentDate'])}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isAfterWeddingDate
                    ? 'ขอบคุณสำหรับความรักและกำลังใจที่มีให้บ่าวสาว! 💕'
                    : 'กรุณากลับมาใหม่ในวันงานเพื่อส่งคำอวยพรให้บ่าวสาว! 💕',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'เข้าใจแล้ว',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        );
      },
    );
  }

  void _clearForm() {
    _nameController.clear();
    _wishController.clear();
    setState(() {
      _currentLength = 0;
      _selectedImages.clear();
      _selectedImagesData.clear();
      _selectedImageNames.clear();
    });
  }

  // Helper method to format date to Thai format
  String _formatDateToThai(String? dateString) {
    if (dateString == null) return '26 กุมภาพันธ์ 2026';

    try {
      // Parse the date string (assuming format: 2026-02-26)
      final dateParts = dateString.split('-');
      if (dateParts.length == 3) {
        final year = dateParts[0];
        final month = dateParts[1];
        final day = int.parse(dateParts[2]).toString(); // Remove leading zero

        final monthNames = [
          '',
          'มกราคม',
          'กุมภาพันธ์',
          'มีนาคม',
          'เมษายน',
          'พฤษภาคม',
          'มิถุนายน',
          'กรกฎาคม',
          'สิงหาคม',
          'กันยายน',
          'ตุลาคม',
          'พฤศจิกายน',
          'ธันวาคม',
        ];

        final monthIndex = int.parse(month);
        if (monthIndex >= 1 && monthIndex <= 12) {
          return '$day ${monthNames[monthIndex]} $year';
        }
      }
    } catch (e) {
      // print('Error formatting date: $e');
    }

    return '26 กุมภาพันธ์ 2026'; // Default fallback
  }

  // Token management methods
  Future<String?> _getStoredToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(tokenKey);
    } catch (e) {
      // print('Error getting stored token: $e');
      return null;
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(tokenKey, token);
    } catch (e) {
      // print('Error saving token: $e');
    }
  }

  Future<void> _clearStoredToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(tokenKey);
      await prefs.remove(usernameKey);
      // print('Token cleared from storage');
    } catch (e) {
      // print('Error clearing token: $e');
    }
  }

  // Helper method to get content type and extension
  Map<String, String> _getImageTypeInfo(String? imagePath) {
    if (imagePath != null) {
      final extension = imagePath.toLowerCase().split('.').last;
      switch (extension) {
        case 'jpg':
        case 'jpeg':
          return {'contentType': 'image/jpeg', 'extension': 'jpg'};
        case 'png':
          return {'contentType': 'image/png', 'extension': 'png'};
        case 'gif':
          return {'contentType': 'image/gif', 'extension': 'gif'};
        case 'webp':
          return {'contentType': 'image/webp', 'extension': 'webp'};
        default:
          return {'contentType': 'image/jpeg', 'extension': 'jpg'};
      }
    }
    return {'contentType': 'image/jpeg', 'extension': 'jpg'};
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('ถ่ายรูป'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('เลือกจากแกลเลอรี่'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        if (kIsWeb) {
          // For web, read as bytes and store filename (replace existing)
          final bytes = await image.readAsBytes();
          if (mounted) {
            setState(() {
              _selectedImagesData.clear(); // Clear existing
              _selectedImageNames.clear(); // Clear existing
              _selectedImagesData.add(bytes);
              _selectedImageNames.add(image.name);
            });
          }
        } else {
          // For mobile, use File (replace existing)
          if (mounted) {
            setState(() {
              _selectedImages.clear(); // Clear existing
              _selectedImages.add(File(image.path));
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'เกิดข้อผิดพลาดในการเลือกรูปภาพ',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red[400],
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _buildLoadingPopup() {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                strokeWidth: 3,
              ),
              SizedBox(height: 20),
              Text(
                'กำลังส่งคำอวยพร',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6f7f67),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'กรุณารอสักครู่...',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessPopup() {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('💛', style: TextStyle(fontSize: 48)),
              SizedBox(height: 15),
              Text(
                'ขอบคุณสำหรับคำอวยพร',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6f7f67),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'ความรักของคุณถูกส่งถึงบ่าวสาวแล้ว',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showSuccess = false;
                    });

                    // Simply navigate to the thank you tab
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(initialIndex: 4),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Color(0xFF6f7f67),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'ปิด',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
