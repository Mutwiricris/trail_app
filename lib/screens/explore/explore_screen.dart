import 'package:flutter/material.dart';
import 'package:zuritrails/screens/gems/gem_details_screen.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/widgets/home/search_bar_widget.dart';
import 'package:zuritrails/screens/routes/route_browser_screen.dart';
import 'package:zuritrails/screens/map/nearby_destinations_map.dart';
import 'package:zuritrails/widgets/explore/search_modal.dart';
import 'package:zuritrails/widgets/explore/travel_collections_section.dart';
import 'package:zuritrails/widgets/explore/trending_section.dart';
import 'package:zuritrails/widgets/explore/quick_booking_cards.dart';
import 'package:zuritrails/widgets/explore/operators_section.dart';
import 'package:zuritrails/widgets/explore/seasonal_recommendations.dart';

/// Modern explore screen for discovering hidden gems
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedCategory = 'All';
  bool _isGridView = false;

  final List<String> _categories = [
    'All',
    'Mountains',
    'Beach',
    'Forest',
    'Adventure',
    'Wildlife',
    'Cultural',
  ];

  final List<Map<String, dynamic>> _hiddenGems = [
    {
      'title': 'Chyulu Hills',
      'location': 'Makueni County',
      'image': 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=800',
      'description': 'Volcanic hills with stunning views and wildlife',
      'distance': '2.3 km',
      'category': 'Mountains',
      'rating': 4.8,
      'reviews': 234,
    },
    {
      'title': 'Hell\'s Gate Gorge',
      'location': 'Naivasha',
      'image': 'https://images.unsplash.com/photo-1516026672322-bc52d61a55d5?w=800',
      'description': 'Dramatic cliffs and natural hot springs',
      'distance': '5.1 km',
      'category': 'Adventure',
      'rating': 4.9,
      'reviews': 456,
    },
    {
      'title': 'Kisite-Mpunguti Marine Park',
      'location': 'South Coast',
      'image': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800',
      'description': 'Pristine coral reefs and dolphins',
      'distance': '12.5 km',
      'category': 'Beach',
      'rating': 4.7,
      'reviews': 189,
    },
    {
      'title': 'Kakamega Forest',
      'location': 'Western Kenya',
      'image': 'https://images.unsplash.com/photo-1511497584788-876760111969?w=800',
      'description': 'Last remaining rainforest in Kenya',
      'distance': '8.7 km',
      'category': 'Forest',
      'rating': 4.6,
      'reviews': 312,
    },
  ];

  List<Map<String, dynamic>> get _filteredGems {
    if (_selectedCategory == 'All') return _hiddenGems;
    return _hiddenGems
        .where((gem) => gem['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Explore',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          // View toggle
                          IconButton(
                            icon: Icon(
                              _isGridView ? Icons.view_list : Icons.grid_view,
                              color: AppColors.textPrimary,
                            ),
                            onPressed: () {
                              setState(() {
                                _isGridView = !_isGridView;
                              });
                            },
                          ),
                          // Map view button
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.beige,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.map_outlined,
                                color: AppColors.berryCrush,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Discover ${_filteredGems.length} hidden gems nearby',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SearchBarWidget(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => SearchModal(
                          allItems: _hiddenGems,
                          onItemTap: (item) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GemDetailsScreen(gem: item),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    hintText: 'Search destinations...',
                  ),
                ],
              ),
            ),

            // Category chips
            Container(
              height: 50,
              color: AppColors.white,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _CategoryChip(
                      label: category,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // Gems list/grid
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 1));
                },
                color: AppColors.berryCrush,
                child: _isGridView
                    ? _buildGridView()
                    : _buildListView(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.berryCrush.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          heroTag: 'scan_surroundings_fab',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NearbyDestinationsMap(),
              ),
            );
          },
          backgroundColor: AppColors.berryCrush,
          elevation: 0,
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.explore, color: AppColors.white, size: 20),
          ),
          label: const Text(
            'Explore Nearby',
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Routes banner
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: _buildRoutesBanner(),
        ),

        // Travel Collections Section
        const SizedBox(height: 8),
        const TravelCollectionsSection(),

        // Trending Destinations
        const SizedBox(height: 8),
        const TrendingSection(),

        // Quick Booking Cards
        const SizedBox(height: 8),
        const QuickBookingCards(),

        // Tour Operators
        const SizedBox(height: 8),
        const OperatorsSection(),

        // Seasonal Recommendations
        const SizedBox(height: 8),
        const SeasonalRecommendations(),

        // Hidden Gems Section Header
        const SizedBox(height: 16),
        Container(
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hidden Gems Near You',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_filteredGems.length} places discovered',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.berryCrush.withValues(alpha: 0.15),
                      AppColors.berryCrush.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.berryCrush.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  _selectedCategory == 'All' ? 'All' : _selectedCategory,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.berryCrush,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Gem cards
        ..._filteredGems.map((gem) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _ModernGemCard(gem: gem),
        )),

        // Bottom padding
        const SizedBox(height: 80),
      ],
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

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _filteredGems.length,
      itemBuilder: (context, index) {
        return _GridGemCard(gem: _filteredGems[index]);
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.berryCrush : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.berryCrush
                : AppColors.greyLight.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ModernGemCard extends StatelessWidget {
  final Map<String, dynamic> gem;

  const _ModernGemCard({required this.gem});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with gradient overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  gem['image'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: AppColors.beige.withValues(alpha: 0.3),
                      child: Icon(
                        Icons.landscape,
                        size: 48,
                        color: AppColors.berryCrush.withValues(alpha: 0.5),
                      ),
                    );
                  },
                ),
              ),
              // Gradient overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
              ),
              // Category badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getCategoryIcon(gem['category']),
                        size: 14,
                        color: AppColors.berryCrush,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        gem['category'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.berryCrush,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bookmark button
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    iconSize: 20,
                    color: AppColors.textPrimary,
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gem['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        gem['location'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  gem['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Rating
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            gem['rating'].toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            ' (${gem['reviews']})',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Distance
                    Row(
                      children: [
                        Icon(
                          Icons.directions_walk,
                          size: 16,
                          color: AppColors.berryCrush,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          gem['distance'],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.berryCrush,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Mountains':
        return Icons.terrain;
      case 'Beach':
        return Icons.beach_access;
      case 'Forest':
        return Icons.forest;
      case 'Adventure':
        return Icons.hiking;
      case 'Wildlife':
        return Icons.pets;
      case 'Cultural':
        return Icons.account_balance;
      default:
        return Icons.place;
    }
  }
}

class _GridGemCard extends StatelessWidget {
  final Map<String, dynamic> gem;

  const _GridGemCard({required this.gem});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  gem['image'],
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 140,
                      color: AppColors.beige.withValues(alpha: 0.3),
                      child: Icon(
                        Icons.landscape,
                        size: 32,
                        color: AppColors.berryCrush.withValues(alpha: 0.5),
                      ),
                    );
                  },
                ),
              ),
              // Bookmark
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    iconSize: 18,
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                    color: AppColors.textPrimary,
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gem['title'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          gem['location'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        gem['rating'].toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        gem['distance'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.berryCrush,
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
    );
  }
}
