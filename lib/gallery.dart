import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:electronic_card_app/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'config/api_config.dart';

// Global color constant
const Color kPrimaryColor = Color(0xFF7E8B78);

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage>
    with AutomaticKeepAliveClientMixin {
  List<String> galleryImages = [];
  bool _isLoadingImages = true;
  bool _showGif = false; // Track if showing GIF

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadGalleryImages();
  }

  Future<void> _loadGalleryImages() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.images}?prefix=journey-of-us-images&limit=100'),
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers':
              'Origin, Content-Type, Accept, Authorization, X-Request-With',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> images = responseData['images'] ?? [];

        setState(() {
          galleryImages = images
              .where(
                (image) =>
                    image['contentType'] == 'image/jpeg' && image['size'] > 0,
              )
              .map<String>((image) => image['publicUrl'] as String)
              .toList();
          _isLoadingImages = false;
        });
      } else {
        setState(() {
          _isLoadingImages = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingImages = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Scaffold(
      backgroundColor: const Color(0xFFBFC6B4), // Sage green background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // Gallery Title
              Text(
                'Journey of Us',
                style: AppFonts.ttHovesPro(
                  fontSize: 60,
                  color: Colors.white,
                  fontWeight: AppFonts.regular,
                  fontStyle: FontStyle.italic,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                    ),
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      offset: const Offset(4, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Photo Card
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      maxWidth: 400, // Maximum width for desktop
                      maxHeight: 600, // Maximum height for desktop
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
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
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          // Photo Container
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey[200],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showGif = !_showGif;
                                  });
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: _showGif
                                      ? Image.asset(
                                          'assets/images/gallery-preview.GIF',
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            // If GIF fails to load, fallback to JPEG
                                            return Image.asset(
                                              'assets/images/gallery-preview.jpeg',
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        const Color(
                                                          0xFFBFC6B4,
                                                        ).withValues(
                                                          alpha: 0.3,
                                                        ),
                                                        const Color(
                                                          0xFF7E8B78,
                                                        ).withValues(
                                                          alpha: 0.1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .photo_camera_outlined,
                                                          size: 80,
                                                          color: kPrimaryColor
                                                              .withValues(
                                                                alpha: 0.6,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                          'Wedding Photos',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                kPrimaryColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          'Coming Soon',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: kPrimaryColor
                                                                .withValues(
                                                                  alpha: 0.7,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          'assets/images/gallery-preview.jpeg',
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        const Color(
                                                          0xFFBFC6B4,
                                                        ).withValues(
                                                          alpha: 0.3,
                                                        ),
                                                        const Color(
                                                          0xFF7E8B78,
                                                        ).withValues(
                                                          alpha: 0.1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .photo_camera_outlined,
                                                          size: 80,
                                                          color: kPrimaryColor
                                                              .withValues(
                                                                alpha: 0.6,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                          'Wedding Photos',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                kPrimaryColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          'Coming Soon',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: kPrimaryColor
                                                                .withValues(
                                                                  alpha: 0.7,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // View All Photos Button
              Center(
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    maxWidth: 400, // Maximum width for desktop
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: _isLoadingImages || galleryImages.isEmpty
                        ? null
                        : () {
                            _showFullGallery(context);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      _isLoadingImages
                          ? 'กำลังโหลด...'
                          : galleryImages.isEmpty
                          ? 'ไม่มีรูปภาพ'
                          : 'ดูรูปทั้งหมด',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showFullGallery(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
            ),
            child: FullGalleryModal(images: galleryImages),
          );
        },
      ),
    );
  }
}

class FullGalleryModal extends StatelessWidget {
  final List<String> images;

  const FullGalleryModal({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Close Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.close, color: kPrimaryColor, size: 28),
                  ),
                ),
              ),
            ),

            // Gallery Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildMasonryGrid(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasonryGrid(BuildContext context) {
    if (images.isEmpty) {
      return const Center(
        child: Text(
          'ไม่มีรูปภาพ',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    if (isDesktop) {
      return _buildDesktopGrid(context);
    } else {
      return _buildMobileGrid(context);
    }
  }

  Widget _buildDesktopGrid(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showImageViewer(context, index),
          child: Hero(
            tag: 'gallery_image_$index',
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl:
                      '${ApiConfig.cards}/image-proxy?url=${Uri.encodeComponent(images[index])}',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          kPrimaryColor,
                        ),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          kPrimaryColor.withValues(alpha: 0.3),
                          kPrimaryColor.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.photo,
                        color: kPrimaryColor.withValues(alpha: 0.6),
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileGrid(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column 1
          Expanded(
            child: Column(children: _buildBalancedColumnImages(context, 0)),
          ),
          const SizedBox(width: 8),
          // Column 2
          Expanded(
            child: Column(children: _buildBalancedColumnImages(context, 1)),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBalancedColumnImages(
    BuildContext context,
    int columnIndex,
  ) {
    List<Widget> columnImages = [];
    List<int> column1Indices = [];
    List<int> column2Indices = [];

    // Distribute images more evenly between columns
    for (int i = 0; i < images.length; i++) {
      if (i % 2 == 0) {
        column1Indices.add(i);
      } else {
        column2Indices.add(i);
      }
    }

    // Balance the columns by moving images if one column has too many
    if (column1Indices.length > column2Indices.length + 2) {
      // Move some images from column 1 to column 2
      int toMove = (column1Indices.length - column2Indices.length) ~/ 2;
      for (int i = 0; i < toMove; i++) {
        column2Indices.add(column1Indices.removeLast());
      }
    } else if (column2Indices.length > column1Indices.length + 2) {
      // Move some images from column 2 to column 1
      int toMove = (column2Indices.length - column1Indices.length) ~/ 2;
      for (int i = 0; i < toMove; i++) {
        column1Indices.add(column2Indices.removeLast());
      }
    }

    List<int> targetIndices = columnIndex == 0
        ? column1Indices
        : column2Indices;

    for (int imageIndex in targetIndices) {
      double aspectRatio = _getAspectRatio(imageIndex);

      columnImages.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: _buildImageItem(context, imageIndex, aspectRatio),
        ),
      );
    }

    return columnImages;
  }

  double _getAspectRatio(int index) {
    // Create varied aspect ratios to mimic real photo gallery layout
    List<double> aspectRatios = [
      1.0, // Square
      0.75, // Portrait
      1.33, // Landscape
      0.8, // Tall portrait
      1.5, // Wide landscape
      0.9, // Near square
      1.2, // Wide
      0.7, // Very tall
      1.4, // Very wide
      1.1, // Slightly wide
      0.85, // Slightly tall
      1.25, // Medium wide
    ];
    return aspectRatios[index % aspectRatios.length];
  }

  Widget _buildImageItem(BuildContext context, int index, double aspectRatio) {
    return GestureDetector(
      onTap: () => _showImageViewer(context, index),
      child: Hero(
        tag: 'gallery_image_$index',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: CachedNetworkImage(
                imageUrl:
                    '${ApiConfig.cards}/image-proxy?url=${Uri.encodeComponent(images[index])}',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        kPrimaryColor.withValues(alpha: 0.3),
                        kPrimaryColor.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.photo,
                      color: kPrimaryColor.withValues(alpha: 0.6),
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showImageViewer(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.9),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: ImageViewerModal(images: images, initialIndex: initialIndex),
          );
        },
      ),
    );
  }
}

class ImageViewerModal extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ImageViewerModal({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<ImageViewerModal> createState() => _ImageViewerModalState();
}

class _ImageViewerModalState extends State<ImageViewerModal> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.95),
      body: Stack(
        children: [
          // Image PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Center(
                child: Hero(
                  tag: 'gallery_image_$index',
                  child: InteractiveViewer(
                    child: CachedNetworkImage(
                      imageUrl:
                          '${ApiConfig.cards}/image-proxy?url=${Uri.encodeComponent(widget.images[index])}',
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.photo,
                            color: kPrimaryColor,
                            size: 64,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Close Button
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
          ),

          // Previous Button
          if (currentIndex > 0)
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),

          // Next Button
          if (currentIndex < widget.images.length - 1)
            Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),

          // Image Counter
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${currentIndex + 1} / ${widget.images.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
