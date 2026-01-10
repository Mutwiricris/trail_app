import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/screens/routes/route_browser_screen.dart';
import 'package:zuritrails/screens/gems/gem_details_screen.dart';
import 'package:zuritrails/screens/safaris/safari_details_screen.dart';
import 'package:zuritrails/screens/discover/comprehensive_browse_screen.dart';
import 'package:zuritrails/screens/search/comprehensive_search_screen.dart';
import 'package:zuritrails/widgets/explore/travel_collections_section.dart';
import 'package:zuritrails/widgets/explore/trending_section.dart';
import 'package:zuritrails/widgets/explore/operators_section.dart';
import 'package:zuritrails/widgets/explore/seasonal_recommendations.dart';

/// Redesigned modern home/discover screen
class HomeScreenRedesigned extends StatefulWidget {
  const HomeScreenRedesigned({super.key});

  @override
  State<HomeScreenRedesigned> createState() => _HomeScreenRedesignedState();
}

class _HomeScreenRedesignedState extends State<HomeScreenRedesigned> {
  String _selectedCategory = 'All';

  // Sample data
  final List<Map<String, String>> _quickActions = [
    {'icon': '🗺️', 'label': 'Map', 'color': '0xFFFF9800'},
    {'icon': '💎', 'label': 'Gems', 'color': '0xFFD63384'},
    {'icon': '🏕️', 'label': 'Camps', 'color': '0xFF2196F3'},
    {'icon': '🎯', 'label': 'Tours', 'color': '0xFF4CAF50'},
  ];

  final List<String> _categories = [
    'All',
    'Wildlife',
    'Beach',
    'Mountain',
    'Culture',
    'Adventure'
  ];

  final List<Map<String, dynamic>> _featuredPlaces = [
    {
      'title': 'Maasai Mara Safari',
      'location': 'Narok County',
      'image': 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800',
      'rating': 4.9,
      'price': 'KSh 45,000',
      'category': 'Wildlife',
      'reviews': 487,
    },
    {
      'title': 'Diani Beach Resort',
      'location': 'South Coast',
      'image': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800',
      'rating': 4.8,
      'price': 'KSh 28,000',
      'category': 'Beach',
      'reviews': 298,
    },
    {
      'title': 'Mount Kenya Lodge',
      'location': 'Central Kenya',
      'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      'rating': 4.7,
      'price': 'KSh 18,000',
      'category': 'Mountain',
      'reviews': 156,
    },
  ];

  final List<Map<String, dynamic>> _trendingGems = [
    {
      'title': 'Chyulu Hills',
      'location': 'Makueni County',
      'image': 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=800',
      'difficulty': 'Moderate',
      'rating': 4.8,
    },
    {
      'title': 'Hell\'s Gate Gorge',
      'location': 'Nakuru',
      'image': 'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?w=800',
      'difficulty': 'Easy',
      'rating': 4.7,
    },
    {
      'title': 'Kakamega Forest',
      'location': 'Western Kenya',
      'image': 'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=800',
      'difficulty': 'Moderate',
      'rating': 4.6,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          _buildAppBar(),

          // Personalized Greeting & Stats
          _buildHeroSection(),

          // Quick Actions
          _buildQuickActions(),

          // Search Bar
          _buildSearchBar(),

          // === 1. DESTINATIONS ===

          // Category Tabs for filtering
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          _buildCategoryTabs(),

          // Featured Destinations Carousel
          _buildFeaturedSection(),

          // Tour Operators for Destinations
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                OperatorsSection(
                  onOperatorTap: (operator) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SafariDetailsScreen(
                          safari: {
                            'name': '${operator['name']} Tours',
                            'location': 'Multiple Locations',
                            'rating': operator['rating'],
                            'price': 'Custom Pricing',
                            'description': 'Verified tour operator with ${operator['tours']} amazing tours. Explore Kenya with experienced professionals.',
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // === 2. HIDDEN GEMS ===

          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          _buildHiddenGemsSection(),

          // === 3. TRAVEL COLLECTIONS ===

          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                TravelCollectionsSection(
                  onCollectionTap: (collection) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SafariDetailsScreen(
                          safari: {
                            'name': collection['title'],
                            'location': 'Curated Collection',
                            'description': collection['description'],
                            'price': 'From KSh 15,000',
                            'rating': 4.8,
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // === 4. TOURS ===

          // Trending Tours & Destinations
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                TrendingSection(
                  onDestinationTap: (destination) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SafariDetailsScreen(
                          safari: {
                            'name': destination['name'],
                            'location': destination['location'],
                            'image': destination['image'],
                            'rating': destination['rating'],
                            'price': destination['price'],
                            'description': 'Explore this amazing destination with experienced guides.',
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Seasonal Tour Recommendations
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                SeasonalRecommendations(
                  onPlaceTap: (place) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SafariDetailsScreen(
                          safari: {
                            'name': place['name'],
                            'location': 'Kenya',
                            'description': place['description'],
                            'price': place['price'],
                            'rating': 4.8,
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Routes & Trails
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: _buildRoutesBanner(),
            ),
          ),

          // Bottom Padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: AppColors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      title: Row(
        children: [
          // Profile Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.berryCrush,
                  AppColors.berryCrush.withOpacity(0.7),
                ],
              ),
            ),
            child: const Icon(Icons.person, color: AppColors.white, size: 20),
          ),
          const SizedBox(width: 12),
          // Logo
          const Text(
            'ZuriTrails',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        // Search
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ComprehensiveSearchScreen(),
              ),
            );
          },
          icon: const Icon(Icons.search, color: AppColors.textPrimary),
        ),
        // Notifications
        Stack(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined,
                  color: AppColors.textPrimary),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.berryCrush,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.berryCrush,
              AppColors.berryCrush.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.berryCrush.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello, Explorer! 👋',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ready for your next adventure?',
              style: TextStyle(
                color: AppColors.white.withOpacity(0.9),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildStatItem('5', 'Day Streak', Icons.local_fire_department),
                const SizedBox(width: 20),
                _buildStatItem('12', 'Badges', Icons.emoji_events),
                const SizedBox(width: 20),
                _buildStatItem('2.4K', 'Points', Icons.stars),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: AppColors.white.withOpacity(0.8),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _quickActions.map((action) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  // Navigate based on action label
                  if (action['label'] == 'Map') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RouteBrowserScreen(),
                      ),
                    );
                  } else if (action['label'] == 'Gems') {
                    // Scroll to hidden gems section (already on this page)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Scroll down to view Hidden Gems'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                  // Tours and Camps could navigate to filtered views
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        action['icon']!,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        action['label']!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ComprehensiveSearchScreen(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.grey),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Search destinations, wildlife...',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.berryCrush.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.tune,
                    color: AppColors.berryCrush,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SliverToBoxAdapter(
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(top: 8, bottom: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            final isSelected = category == _selectedCategory;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.berryCrush : AppColors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.berryCrush.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text(
                  'Featured Destinations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ComprehensiveBrowseScreen(initialTab: 0),
                      ),
                    );
                  },
                  child: const Text('See all'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _featuredPlaces.length,
              itemBuilder: (context, index) {
                final place = _featuredPlaces[index];
                return _buildFeaturedCard(place);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(Map<String, dynamic> place) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SafariDetailsScreen(
              safari: {
                'name': place['title'],
                'location': place['location'],
                'image': place['image'],
                'rating': place['rating'],
                'price': place['price'],
                'description': 'Experience the best of ${place['title']} with our curated tours and activities.',
              },
            ),
          ),
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  place['image'],
                  height: 200,
                  width: 280,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    size: 20,
                    color: AppColors.berryCrush,
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.berryCrush,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    place['category'],
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: AppColors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        place['location'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text(
                      '${place['rating']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${place['reviews']})',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      place['price'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.berryCrush,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildHiddenGemsSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.warning.withOpacity(0.2),
                        AppColors.berryCrush.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.diamond, color: AppColors.warning, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Hidden Gems',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ComprehensiveBrowseScreen(initialTab: 1),
                      ),
                    );
                  },
                  child: const Text('See all'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _trendingGems.length,
              itemBuilder: (context, index) {
                final gem = _trendingGems[index];
                return _buildGemCard(gem);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGemCard(Map<String, dynamic> gem) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GemDetailsScreen(
              gem: {
                'name': gem['title'],
                'location': gem['location'],
                'image': gem['image'],
                'rating': gem['rating'],
                'difficulty': gem['difficulty'],
                'description': 'Discover this hidden gem and explore the beauty of Kenya.',
              },
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              gem['image'],
              height: 240,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          // Content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gem['title'],
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 12, color: AppColors.white),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          gem['location'],
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          gem['difficulty'],
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, size: 14, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text(
                        '${gem['rating']}',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildPopularSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.trending_up, color: AppColors.info, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Popular This Week',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              final place = _featuredPlaces[index];
              return _buildPopularListItem(place, index + 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPopularListItem(Map<String, dynamic> place, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.berryCrush,
                  AppColors.berryCrush.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              place['image'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place['title'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  place['location'],
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text(
                      '${place['rating']}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      place['price'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.berryCrush,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.grey),
        ],
      ),
    );
  }

  Widget _buildRoutesBanner() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const RouteBrowserScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.berryCrush,
              AppColors.berryCrushDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.berryCrush.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.route,
                color: AppColors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Discover Curated Routes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Explore scenic drives, hiking trails & hidden segments',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
