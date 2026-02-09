import 'dart:convert';

import 'package:electronic_card_app/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Global color constant
const Color kPrimaryColor = Color(0xFF7E8B78);
const Color kAccentColor = Color(0xFFD4C5B0); // Beige/Tan color

// Image metadata model
class ImageMetadata {
  final String path;
  final String title;
  final String description;

  ImageMetadata({
    required this.path,
    required this.title,
    required this.description,
  });

  factory ImageMetadata.fromJson(Map<String, dynamic> json) {
    // Image.asset() automatically adds 'assets/' prefix, so we don't need it
    return ImageMetadata(
      path: json['path'],
      title: json['title'],
      description: json['description'],
    );
  }
}

// Year group model for timeline
class YearGroup {
  final String year;
  final String title;
  final String description;
  final List<ImageMetadata> images;

  YearGroup({
    required this.year,
    required this.title,
    required this.description,
    required this.images,
  });

  factory YearGroup.fromJson(Map<String, dynamic> json) {
    return YearGroup(
      year: json['year'],
      title: json['title'],
      description: json['description'],
      images: (json['images'] as List)
          .map((img) => ImageMetadata.fromJson(img))
          .toList(),
    );
  }
}

// Journey metadata model
class JourneyItem {
  final int id;
  final String imagePath;
  final String title;
  final String description;
  final String category;
  final String time;

  JourneyItem({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.category,
    required this.time,
  });

  factory JourneyItem.fromJson(Map<String, dynamic> json) {
    return JourneyItem(
      id: json['id'],
      imagePath: json['imagePath'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      time: json['time'] ?? '',
    );
  }
}

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage>
    with AutomaticKeepAliveClientMixin {
  List<String> galleryImages = [];
  List<JourneyItem> journeyItems = [];
  List<YearGroup> yearGroups = [];
  bool _isLoadingImages = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadGalleryImages();
  }

  Future<void> _loadGalleryImages() async {
    try {
      // Load timeline metadata JSON
      final jsonString = await rootBundle.loadString(
        'assets/images/journey-of-us/timeline_metadata.json',
      );
      final jsonData = json.decode(jsonString);
      final List<dynamic> timelineList = jsonData['timeline'];

      // Parse year groups from JSON
      yearGroups = timelineList
          .map((item) => YearGroup.fromJson(item))
          .where(
            (group) => group.images.isNotEmpty,
          ) // Only include years with images
          .toList();

      // Flatten all images for gallery
      galleryImages = [];
      for (var group in yearGroups) {
        galleryImages.addAll(group.images.map((img) => img.path));
      }

      setState(() {
        _isLoadingImages = false;
      });
    } catch (e) {
      print('Error loading gallery images: $e');
      setState(() {
        _isLoadingImages = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0xFFBFC6B4),
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
                  fontSize: MediaQuery.of(context).size.width < 375 ? 45 : 60,
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

              const SizedBox(height: 20),

              // Photo Card
              Expanded(
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width < 400
                          ? MediaQuery.of(context).size.width - 20
                          : 400,
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          'assets/images/perview/gallery-preview.GIF',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/gallery-preview.jpeg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 300,
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
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // View All Photos Button
              Center(
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                    minWidth: 300,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
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

              const SizedBox(height: 20),
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
            child: WeddingTimelineModal(
              images: galleryImages,
              journeyItems: journeyItems,
              yearGroups: yearGroups,
            ),
          );
        },
      ),
    );
  }
}

class WeddingTimelineModal extends StatelessWidget {
  final List<String> images;
  final List<JourneyItem> journeyItems;
  final List<YearGroup> yearGroups;

  const WeddingTimelineModal({
    super.key,
    required this.images,
    required this.journeyItems,
    required this.yearGroups,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                const SizedBox(height: 70),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 60 : 20,
                      vertical: 20,
                    ),
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: isDesktop ? 1400 : double.infinity,
                        ),
                        child: Column(
                          children: [
                            // Timeline by Year
                            if (yearGroups.isNotEmpty)
                              _buildYearTimeline(context, isDesktop)
                            else if (journeyItems.isNotEmpty)
                              _buildWeddingTimeline(context, isDesktop)
                            else
                              _buildPhotoGrid(context, isDesktop),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Close Button (Fixed)
            Positioned(
              top: 16,
              right: 16,
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
                        color: Colors.black.withValues(alpha: 0.15),
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
          ],
        ),
      ),
    );
  }

  Widget _buildYearTimeline(BuildContext context, bool isDesktop) {
    return Column(
      children: yearGroups.map((yearGroup) {
        return Column(
          children: [
            // Year Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    kPrimaryColor.withValues(alpha: 0.8),
                    kPrimaryColor.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: isDesktop ? 28 : 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        yearGroup.year,
                        style: AppFonts.ttHovesPro(
                          fontSize: isDesktop ? 36 : 28,
                          color: Colors.white,
                          fontWeight: AppFonts.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    yearGroup.title,
                    style: AppFonts.ttHovesPro(
                      fontSize: isDesktop ? 20 : 16,
                      color: Colors.white,
                      fontWeight: AppFonts.medium,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (yearGroup.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      yearGroup.description,
                      style: TextStyle(
                        fontSize: isDesktop ? 14 : 12,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            // Images for this year
            if (isDesktop)
              _buildYearImagesGrid(context, yearGroup)
            else
              _buildYearImagesCarousel(context, yearGroup),

            const SizedBox(height: 48),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildYearImagesGrid(BuildContext context, YearGroup yearGroup) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: yearGroup.images.asMap().entries.map((entry) {
        final imageMetadata = entry.value;
        final globalIndex = images.indexOf(imageMetadata.path);
        return GestureDetector(
          onTap: () => _showImageViewer(context, globalIndex),
          child: Hero(
            tag: 'gallery_image_$globalIndex',
            child: Container(
              width: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    spreadRadius: 0,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: Image.asset(
                      imageMetadata.path,
                      width: 280,
                      height: 350,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 280,
                        height: 350,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[600],
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          imageMetadata.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          imageMetadata.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildYearImagesCarousel(BuildContext context, YearGroup yearGroup) {
    return Column(
      children: yearGroup.images.asMap().entries.map((entry) {
        final imageMetadata = entry.value;
        final globalIndex = images.indexOf(imageMetadata.path);
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () => _showImageViewer(context, globalIndex),
            child: Hero(
              tag: 'gallery_image_$globalIndex',
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      spreadRadius: 0,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.asset(
                        imageMetadata.path,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: double.infinity,
                          height: 300,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[600],
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                    if (imageMetadata.title.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          imageMetadata.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeddingTimeline(BuildContext context, bool isDesktop) {
    if (isDesktop) {
      // Desktop: Show grid/wrap layout
      return LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: journeyItems.map((item) {
              return _buildTimelineCard(context, item, isDesktop);
            }).toList(),
          );
        },
      );
    } else {
      // Mobile: Show one large image at a time with PageView
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: PageView.builder(
          itemCount: journeyItems.length,
          itemBuilder: (context, index) {
            final item = journeyItems[index];
            return GestureDetector(
              onTap: () => _showImageViewer(context, index),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    // Large Image
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              spreadRadius: 0,
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Hero(
                            tag: 'gallery_image_${item.id}',
                            child: Image.asset(
                              item.imagePath,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          kAccentColor.withValues(alpha: 0.3),
                                          kAccentColor.withValues(alpha: 0.1),
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.photo_camera_outlined,
                                        color: kAccentColor.withValues(
                                          alpha: 0.6,
                                        ),
                                        size: 64,
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Info below image
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            spreadRadius: 0,
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (item.time.isNotEmpty)
                            Text(
                              item.time,
                              style: TextStyle(
                                fontSize: 13,
                                color: kAccentColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C2C2C),
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Page counter (text instead of dots)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: kAccentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${index + 1} / ${journeyItems.length}',
                        style: TextStyle(
                          fontSize: 13,
                          color: kAccentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Widget _buildTimelineCard(
    BuildContext context,
    JourneyItem item,
    bool isDesktop,
  ) {
    final cardWidth = isDesktop ? 280.0 : 160.0;
    final imageHeight = isDesktop ? 350.0 : 200.0;

    return GestureDetector(
      onTap: () => _showImageViewer(context, journeyItems.indexOf(item)),
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              spreadRadius: 0,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
              child: Hero(
                tag: 'gallery_image_${item.id}',
                child: Image.asset(
                  item.imagePath,
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: imageHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          kAccentColor.withValues(alpha: 0.3),
                          kAccentColor.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.photo_camera_outlined,
                      color: kAccentColor.withValues(alpha: 0.6),
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(isDesktop ? 20.0 : 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    item.title.toUpperCase(),
                    style: TextStyle(
                      fontSize: isDesktop ? 14 : 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C2C2C),
                      letterSpacing: 0.5,
                      height: 1.3,
                    ),
                  ),
                  if (isDesktop) ...[
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(BuildContext context, bool isDesktop) {
    if (isDesktop) {
      // Desktop: Show grid layout
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(images[index], fit: BoxFit.cover),
                ),
              ),
            ),
          );
        },
      );
    } else {
      // Mobile: Show one image at a time with PageView
      return SizedBox(
        height: 500,
        child: PageView.builder(
          itemCount: images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _showImageViewer(context, index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      spreadRadius: 0,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
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
      );
    }
  }

  void _showImageViewer(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.9),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: ImageViewerModal(
              images: images,
              initialIndex: initialIndex,
              journeyItems: journeyItems,
            ),
          );
        },
      ),
    );
  }
}

class ImageViewerModal extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final List<JourneyItem> journeyItems;

  const ImageViewerModal({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.journeyItems,
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
                  tag:
                      'gallery_image_${widget.journeyItems.isNotEmpty ? widget.journeyItems[index].id : index}',
                  child: InteractiveViewer(
                    child: Image.asset(
                      widget.images[index],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
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

          // Bottom Info
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Year info from image path
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getYearFromPath(widget.images[currentIndex]),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Image counter
                  Container(
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
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getYearFromPath(String path) {
    // Extract year from path: assets/images/journey-of-us/2024/image.jpg
    final parts = path.split('/');
    if (parts.length >= 5) {
      return parts[3];
    }
    if (parts.length >= 4) {
      return parts[2];
    }
    return '';
  }
}
