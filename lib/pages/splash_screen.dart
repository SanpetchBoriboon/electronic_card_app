import 'package:flutter/material.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _whiteFadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _whiteFadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _whiteFadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    _whiteFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _whiteFadeController, curve: Curves.easeInOut),
    );

    // Preload images
    _preloadImages();

    // Start initial animation
    _animationController.forward();
  }

  Future<void> _preloadImages() async {
    try {
      // List of critical images to preload
      final imagesToPreload = [
        'assets/images/main-logo.png',
        'assets/images/mini-logo.png',
        'assets/images/thank-you-logo.png',
        'assets/images/tag-thank-you.png',
        'assets/images/qr-code.jpg',
        'assets/images/perview/gallery-preview.GIF',
        'assets/icons/wedding-invitation.png',
      ];

      // Preload all images
      await Future.wait(
        imagesToPreload.map((imagePath) {
          return precacheImage(AssetImage(imagePath), context).catchError((_) {
            // Ignore errors for individual images
            return null;
          });
        }),
      );
    } catch (e) {
      debugPrint('Error preloading images: $e');
    }

    // Navigate after images are loaded and animation completes
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      _whiteFadeController.forward().then((_) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const MyHomePage(),
              transitionDuration: const Duration(milliseconds: 1000),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _whiteFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4F0),
      body: Stack(
        children: [
          // Main content
          Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Mini logo
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width / 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                spreadRadius: 5,
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width / 4,
                            ),
                            child: Image.asset(
                              'assets/images/mini-logo.png',
                              fit: BoxFit.cover,
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
          // White fade overlay
          AnimatedBuilder(
            animation: _whiteFadeController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _whiteFadeAnimation,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
