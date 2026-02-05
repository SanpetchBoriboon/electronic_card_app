import 'package:electronic_card_app/font_styles.dart';
import 'package:flutter/material.dart';

// Global color constant
const Color kPrimaryColor = Color(0xFF7E8B78);

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  // Sample gallery images - you can replace with actual image paths
  final List<String> galleryImages = [
    "gallery/journey-images/000045_Original.jpg",
    "gallery/journey-images/000047_Original.jpg",
    "gallery/journey-images/000048_Original.jpg",
    "gallery/journey-images/000053_Original.jpg",
    "gallery/journey-images/25660507-_TTL5949_Original.jpg",
    "gallery/journey-images/25660507-_TTL5960_Original.jpg",
    "gallery/journey-images/25660507-_TTL5961_Original.jpg",
    "gallery/journey-images/25660507-_TTL5963_Original.jpg",
    "gallery/journey-images/25660521-_DSF0156_Original.jpg",
    "gallery/journey-images/25660521-_DSF0161_Original.jpg",
    "gallery/journey-images/25660521-_DSF0166_Original.jpg",
    "gallery/journey-images/25660813-DSCF0384_Original.jpg",
    "gallery/journey-images/25660813-DSCF0390_Original.jpg",
    "gallery/journey-images/25660813-DSCF0391_Original.jpg",
    "gallery/journey-images/25660813-DSCF0394_Original.jpg",
    "gallery/journey-images/25660813-DSCF0395_Original.jpg",
    "gallery/journey-images/25660813-DSCF0487_Original.jpg",
    "gallery/journey-images/25660813-DSCF0489_Original.jpg",
    "gallery/journey-images/25660813-DSCF0490_Original.jpg",
    "gallery/journey-images/Road-Trip-425_Original.jpg",
    "gallery/journey-images/Road-Trip-451_Original.jpg",
    "gallery/journey-images/Road-Trip-453_Original.jpg",
    "gallery/journey-images/_DSF0068_Original.jpg",
    "gallery/journey-images/_DSF0069-2_Original.jpg",
    "gallery/journey-images/fuji-25661229-154549_Original.jpg",
    "gallery/journey-images/fuji-25661229-154711_Original.jpg",
    "gallery/journey-images/fuji-25661229-154713_Original.jpg",
    "gallery/journey-images/fuji-25661229-154719_Original.jpg",
    "gallery/journey-images/fuji-25670720-084941_Original.jpg",
    "gallery/journey-images/fuji-25670720-085143_Original.jpg",
    "gallery/journey-images/fuji-25670720-085239_Original.jpg",
    "gallery/journey-images/fuji-25670720-085311_Original.jpg",
    "gallery/journey-images/fuji-25670720-085324_Original.jpg",
    "gallery/journey-images/fuji-25670720-142216_Original.jpg",
    "gallery/journey-images/fuji-25670720-142226_Original.jpg",
    "gallery/journey-images/fuji-25670720-142235_Original.jpg",
    "gallery/journey-images/fuji-25670720-182054_Original.jpg",
    "gallery/journey-images/fuji-25670720-183905_Original.jpg",
    "gallery/journey-images/fujiflim-0062_Original.jpg",
    "gallery/journey-images/fujiflim-0318_Original.jpg",
    "gallery/journey-images/fujiflim-0319_Original.jpg",
    "gallery/journey-images/fujiflim-0320_Original.jpg",
    "gallery/journey-images/fujiflim-0321_Original.jpg",
    "gallery/journey-images/fujiflim-0324_Original.jpg",
    "gallery/journey-images/fujiflim-0325_Original.jpg",
    "gallery/journey-images/fujixt20-0161_Original.jpg",
    "gallery/journey-images/fujixt20-0221_Original.jpg",
  ];

  @override
  Widget build(BuildContext context) {
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
                child: Container(
                  width: double.infinity,
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'assets/images/gallery-preview.jpeg',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          const Color(
                                            0xFFBFC6B4,
                                          ).withValues(alpha: 0.3),
                                          const Color(
                                            0xFF7E8B78,
                                          ).withValues(alpha: 0.1),
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.photo_camera_outlined,
                                            size: 80,
                                            color: kPrimaryColor.withValues(
                                              alpha: 0.6,
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Text(
                                            'Wedding Photos',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: kPrimaryColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Coming Soon',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: kPrimaryColor.withValues(
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
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // View All Photos Button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () {
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
                    'ดูรูปทั้งหมด',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: kPrimaryColor,
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
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
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
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset(
                              '/images/${images[index]}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
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
                                      color: kPrimaryColor.withValues(
                                        alpha: 0.6,
                                      ),
                                      size: 32,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
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
                    child: Image.asset(
                      '/images/${widget.images[index]}',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
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
                        );
                      },
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
