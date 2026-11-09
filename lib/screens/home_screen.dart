import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../providers/market_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/modern_floating_nav_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner.dart';
import 'boutique_screen.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'supermarket_switcher_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _navIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openStoreSwitcher(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SupermarketSwitcherSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketProvider>();
    final supermarket = provider.activeSupermarket;
    final primaryColor = supermarket.primaryColor;
    final products = provider.filteredProducts;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar (Oakory Style)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo + Store Name + Slogan
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _openStoreSwitcher(context),
                      child: supermarket.logoAsset != null
                          ? Row(
                              children: [
                                Image.asset(
                                  supermarket.logoAsset!,
                                  height: 52,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 20,
                                  color: Colors.grey.shade600,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: supermarket.primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.storefront_rounded,
                                    color: supermarket.primaryColor,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              supermarket.name,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                                color: supermarket.primaryColor,
                                                letterSpacing: -0.3,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            size: 16,
                                            color: Colors.grey.shade500,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        supermarket.slogan,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  // Shopping Cart with brand circular badge
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            size: 26,
                            color: supermarket.primaryColor,
                          ),
                        ),
                        if (provider.cartCount > 0)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: supermarket.accentColor,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                              child: Center(
                                child: Text(
                                  '${provider.cartCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar Row (Search pill + Filter button)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
              child: Row(
                children: [
                  // Rounded search pill input
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search_rounded, color: Colors.grey.shade500, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (val) => provider.setSearchQuery(val),
                              decoration: InputDecoration(
                                hintText: 'Rechercher un produit, boutique...',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                provider.setSearchQuery('');
                              },
                              child: Icon(Icons.close, size: 16, color: Colors.grey.shade500),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filter / Tune button
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune_rounded, size: 20, color: Color(0xFF112620)),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (ctx) => Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Filtrer les articles',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                ListTile(
                                  leading: const Icon(Icons.local_offer_outlined, color: Colors.red),
                                  title: const Text('Afficher uniquement les promotions'),
                                  onTap: () {
                                    Navigator.pop(ctx);
                                    provider.selectCategory('all');
                                    provider.setSearchQuery('promo');
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.refresh_rounded),
                                  title: const Text('Réinitialiser les filtres'),
                                  onTap: () {
                                    Navigator.pop(ctx);
                                    provider.selectCategory('all');
                                    provider.setSearchQuery('');
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Promotional Banner (hide if searching)
                  if (provider.searchQuery.isEmpty) ...[
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),
                    SliverToBoxAdapter(
                      child: PromoBanner(
                        primaryColor: primaryColor,
                        accentColor: supermarket.accentColor,
                      ),
                    ),
                  ],

                  // Categories Section Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF112620),
                              letterSpacing: -0.3,
                            ),
                          ),
                          if (provider.selectedCategoryId != 'all')
                            GestureDetector(
                              onTap: () => provider.selectCategory('all'),
                              child: const Text(
                                'Tout afficher',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF112620),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Categories Cards List (Style 3D Cards)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 104,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: MockData.categories.length,
                        itemBuilder: (context, index) {
                          final cat = MockData.categories[index];
                          final isSelected = provider.selectedCategoryId == cat.id;
                          return CategoryChip(
                            category: cat,
                            isSelected: isSelected,
                            activeColor: supermarket.primaryColor,
                            onTap: () => provider.selectCategory(cat.id),
                          );
                        },
                      ),
                    ),
                  ),

                  // Section Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            provider.selectedCategoryId == 'all'
                                ? 'Toute la Boutique'
                                : MockData.categories
                                    .firstWhere((c) => c.id == provider.selectedCategoryId)
                                    .name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${products.length} articles',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Products Grid
                  if (products.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Icon(Icons.search_off_rounded, size: 50, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            const Text(
                              'Aucun article trouvé',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Essayez un autre mot-clé ou changez de catégorie.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => ProductCard(product: products[index]),
                          childCount: products.length,
                        ),
                      ),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            ),
          ],
        ),
      ),

      // Modern Floating Navigation Bar (matching user's reference image)
      bottomNavigationBar: ModernFloatingNavBar(
        selectedIndex: _navIndex,
        primaryColor: supermarket.primaryColor,
        accentColor: supermarket.accentColor,
        onItemSelected: (index) {
          setState(() => _navIndex = index);
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BoutiqueScreen()),
            ).then((_) {
              if (mounted) setState(() => _navIndex = 0);
            });
          }
          if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const FavoritesScreen()),
            ).then((_) {
              if (mounted) setState(() => _navIndex = 0);
            });
          }
          if (index == 3) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ).then((_) {
              if (mounted) setState(() => _navIndex = 0);
            });
          }
        },
      ),
    );
  }
}

