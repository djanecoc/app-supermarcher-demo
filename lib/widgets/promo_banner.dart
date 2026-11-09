import 'dart:async';
import 'package:flutter/material.dart';

class PromoBanner extends StatefulWidget {
  final Color primaryColor;
  final Color accentColor;
  final VoidCallback? onCtaTap;

  const PromoBanner({
    super.key,
    required this.primaryColor,
    required this.accentColor,
    this.onCtaTap,
  });

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> banners = [
    {
      'title': 'La Fraîcheur.\nAu Meilleur Prix.',
      'subtitle': 'Découvrez nos arrivages de fruits et légumes frais chaque matin.',
      'cta': 'Commander',
      'image': 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&q=80',
      'bgColor': '0xFF475E54', // subtle teal green like the image armchair
    },
    {
      'title': 'Pack Essentiel.\nÉconomies Garanties.',
      'subtitle': 'Riz parfumé, huile raffinée et produits d\'épicerie à prix grossiste.',
      'cta': 'Découvrir',
      'image': 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=800&q=80',
      'bgColor': '0xFF3E5165', // sleek slate blue
    },
    {
      'title': 'Livraison Rapide.\nDirect chez vous.',
      'subtitle': 'Recevez vos courses à domicile en moins de 45 minutes.',
      'cta': 'En profiter',
      'image': 'https://images.unsplash.com/photo-1583258292688-d0213dc5a3a8?w=800&q=80',
      'bgColor': '0xFF5C4D3C', // warm refined beige/brown
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 185,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              final baseColor = Color(int.parse(banner['bgColor']!));

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: baseColor,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image on right side
                    Positioned(
                      right: 10,
                      top: 0,
                      bottom: 0,
                      width: 150,
                      child: Image.network(
                        banner['image']!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.shopping_bag_rounded,
                            size: 90,
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                      ),
                    ),
                    // Gradient overlay to blend smoothly into background color
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            baseColor,
                            baseColor.withValues(alpha: 0.95),
                            baseColor.withValues(alpha: 0.6),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 0.75, 1.0],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                    // Content Text & Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            banner['title']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 180,
                            child: Text(
                              banner['subtitle']!,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 11,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Pill Button "Shop Now ->"
                          GestureDetector(
                            onTap: widget.onCtaTap,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    banner['cta']!,
                                    style: const TextStyle(
                                      color: Color(0xFF112620),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14,
                                    color: Color(0xFF112620),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Dots Indicator (like in reference image)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentPage == index ? const Color(0xFF112620) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
