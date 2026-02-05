import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/api_config.dart';

// Global color constant
const Color kPrimaryColor = Color(0xFF7E8B78);

// Token storage keys
const String TOKEN_KEY = 'guest_token';
const String USERNAME_KEY = 'guest_username';

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
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Form Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name Field
                        Text(
                          'ชื่อของคุณ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'พิมพ์ชื่อคุณที่นี่...',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(15),
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

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
                                kPrimaryColor.withOpacity(0.1),
                                kPrimaryColor.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: kPrimaryColor.withOpacity(0.3),
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: kPrimaryColor.withOpacity(0.1),
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
                                      color: kPrimaryColor.withOpacity(0.15),
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
                                          '${kIsWeb ? _selectedImagesData.length : _selectedImages.length} รูปที่เลือก',
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
                                    color: kPrimaryColor.withOpacity(0.7),
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
                              SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: kIsWeb
                                      ? _selectedImagesData.length
                                      : _selectedImages.length,
                                  itemBuilder: (context, index) {
                                    return AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      margin: EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            spreadRadius: 1,
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: kPrimaryColor
                                                    .withOpacity(0.2),
                                                width: 2,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: kIsWeb
                                                  ? Image.memory(
                                                      _selectedImagesData[index],
                                                      width: 120,
                                                      height: 120,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.file(
                                                      _selectedImages[index],
                                                      width: 120,
                                                      height: 120,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (kIsWeb) {
                                                    _selectedImagesData
                                                        .removeAt(index);
                                                    _selectedImageNames
                                                        .removeAt(index);
                                                  } else {
                                                    _selectedImages.removeAt(
                                                      index,
                                                    );
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: Colors.red.shade500,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.red
                                                          .withOpacity(0.4),
                                                      spreadRadius: 1,
                                                      blurRadius: 4,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
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
                                          // Image count badge
                                          Positioned(
                                            bottom: 8,
                                            left: 8,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(
                                                  0.7,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                '${index + 1}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
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
                              padding: const EdgeInsets.symmetric(vertical: 15),
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
    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackBar('กรุณาใส่ชื่อของคุณ');
      return;
    }

    if (_wishController.text.trim().isEmpty) {
      _showErrorSnackBar('กรุณาเขียนคำอวยพร');
      return;
    }

    // Show loading
    setState(() {
      _isSubmitting = true;
    });

    try {
      await _submitWishToAPI();

      // Hide loading first
      setState(() {
        _isSubmitting = false;
      });

      // Clear the form
      _clearForm();

      // Show success popup with delay (like the Angular code)
      await Future.delayed(Duration(milliseconds: 300));
      setState(() {
        _showSuccess = true;
      });
    } catch (e) {
      // Hide loading and show error
      setState(() {
        _isSubmitting = false;
      });

      _showErrorSnackBar('เกิดข้อผิดพลาดในการส่งคำอวยพร กรุณาลองใหม่อีกครั้ง');
      print('Error submitting wish: $e');
    }
  }

  Future<void> _submitWishToAPI() async {
    try {
      print('Starting API submission...');

      final username = _nameController.text.trim();
      String? token;

      // Check if we have a stored token for this username
      final storedUsername = await _getStoredUsername();
      final storedToken = await _getStoredToken();

      if (storedUsername == username && storedToken != null) {
        print('Using stored token for username: $username');
        // แจ้งผู้ใช้ว่ากำลังใช้ token ที่เก็บไว้
        _showInfoSnackBar('กำลังใช้ข้อมูลที่บันทึกไว้สำหรับ: $username');
        token = storedToken;
      } else {
        // Generate new token for this username
        print('Generating new token for username: $username');
        token = await _generateGuestToken(username);
        await _saveToken(token, username);
      }

      // Step 2: Prepare form data
      print('Preparing form data...');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.uploadCardImage),
      );

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add form fields
      request.fields['title'] = username;
      request.fields['message'] = _wishController.text.trim();

      print(
        'Form fields added - title: $username, message length: ${_wishController.text.trim().length}',
      );

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
        print(
          'Adding web image to request: ${imageData.length} bytes (${imageInfo['contentType']}) - Original: $imageName',
        );
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
        print(
          'Adding mobile image to request: ${imageFile.path} (${imageInfo['contentType']})',
        );
      } else {
        print('No image selected');
      }

      // Step 3: Send request
      print('Sending wish data to server...');
      final streamedResponse = await request.send().timeout(
        Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);

      print('Upload response status: ${response.statusCode}');
      print('Upload response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Wish submitted successfully');
      } else if (response.statusCode == 401) {
        // Token expired or invalid, clear and try again
        print('Token invalid, clearing and retrying...');
        await _clearStoredToken();
        throw Exception('Token หมดอายุ กรุณาลองใหม่อีกครั้ง');
      } else {
        throw Exception(
          'Server error: ${response.statusCode} - ${response.body}',
        );
      }
    } on TimeoutException {
      print('Request timeout');
      throw Exception(
        'การเชื่อมต่อหมดเวลา กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต',
      );
    } on SocketException {
      print('Network error');
      throw Exception(
        'ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้ กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต',
      );
    } catch (e) {
      print('API Error: $e');
      rethrow;
    }
  }

  Future<String> _generateGuestToken(String username) async {
    try {
      print('Generating guest token for: $username');
      final response = await http
          .post(
            Uri.parse(ApiConfig.guestTokens),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'username': username}),
          )
          .timeout(Duration(seconds: 10));

      print('Token generation response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        print(
          'Token generated successfully for user: ${data['user']['username']}',
        );
        return token;
      } else {
        print('Token generation failed: ${response.body}');
        throw Exception('ไม่สามารถสร้าง token ได้: ${response.statusCode}');
      }
    } catch (e) {
      print('Error generating token: $e');
      rethrow;
    }
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

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: kPrimaryColor,
        duration: Duration(seconds: 2),
      ),
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

  // Token management methods
  Future<String?> _getStoredToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(TOKEN_KEY);
    } catch (e) {
      print('Error getting stored token: $e');
      return null;
    }
  }

  Future<void> _saveToken(String token, String username) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(TOKEN_KEY, token);
      await prefs.setString(USERNAME_KEY, username);
      print('Token saved for username: $username');
    } catch (e) {
      print('Error saving token: $e');
    }
  }

  Future<String?> _getStoredUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(USERNAME_KEY);
    } catch (e) {
      print('Error getting stored username: $e');
      return null;
    }
  }

  Future<void> _clearStoredToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(TOKEN_KEY);
      await prefs.remove(USERNAME_KEY);
      print('Token cleared from storage');
    } catch (e) {
      print('Error clearing token: $e');
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
          // For web, read as bytes and store filename
          final bytes = await image.readAsBytes();
          setState(() {
            _selectedImagesData.add(bytes);
            _selectedImageNames.add(image.name);
          });
        } else {
          // For mobile, use File
          setState(() {
            _selectedImages.add(File(image.path));
          });
        }
      }
    } catch (e) {
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

  Widget _buildLoadingPopup() {
    return Container(
      color: Colors.black.withOpacity(0.5),
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
      color: Colors.black.withOpacity(0.5),
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
