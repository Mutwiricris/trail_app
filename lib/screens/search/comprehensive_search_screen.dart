import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/screens/safaris/safari_details_screen.dart';
import 'package:zuritrails/screens/gems/gem_details_screen.dart';

/// Comprehensive search screen that searches across all content types
class ComprehensiveSearchScreen extends StatefulWidget {
  const ComprehensiveSearchScreen({super.key});

  @override
  State<ComprehensiveSearchScreen> createState() => _ComprehensiveSearchScreenState();
}

class _ComprehensiveSearchScreenState extends State<ComprehensiveSearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String _searchQuery = '';
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Auto-focus search when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // MOCK DATA - same as browse screen but combined
  final List<Map<String, dynamic>> _allDestinations = [
    {'title': 'Maasai Mara Safari', 'location': 'Narok County', 'rating': 4.9, 'price': 'From \$450', 'category': 'Wildlife', 'reviews': 487, 'type': 'destination'},
    {'title': 'Diani Beach Resort', 'location': 'South Coast', 'rating': 4.8, 'price': 'From \$120', 'category': 'Beach', 'reviews': 298, 'type': 'destination'},
    {'title': 'Mount Kenya Hiking', 'location': 'Central Kenya', 'rating': 4.7, 'price': 'From \$280', 'category': 'Mountain', 'reviews': 156, 'type': 'destination'},
    {'title': 'Lamu Island Culture', 'location': 'Lamu', 'rating': 4.6, 'price': 'From \$200', 'category': 'Culture', 'reviews': 223, 'type': 'destination'},
    {'title': 'Tsavo Wildlife Safari', 'location': 'Tsavo', 'rating': 4.8, 'price': 'From \$350', 'category': 'Wildlife', 'reviews': 342, 'type': 'destination'},
    {'title': 'Nairobi City Tour', 'location': 'Nairobi', 'rating': 4.5, 'price': 'From \$80', 'category': 'City', 'reviews': 445, 'type': 'destination'},
    {'title': 'Amboseli Elephant Safari', 'location': 'Amboseli', 'rating': 4.9, 'price': 'From \$420', 'category': 'Wildlife', 'reviews': 389, 'type': 'destination'},
    {'title': 'Hell\'s Gate Adventure', 'location': 'Nakuru', 'rating': 4.7, 'price': 'From \$150', 'category': 'Adventure', 'reviews': 267, 'type': 'destination'},
  ];

  final List<Map<String, dynamic>> _allGems = [
    {'title': 'Chyulu Hills', 'location': 'Makueni County', 'difficulty': 'Moderate', 'rating': 4.8, 'reviews': 234, 'type': 'gem', 'description': 'Ancient volcanic hills'},
    {'title': 'Hell\'s Gate Gorge', 'location': 'Nakuru', 'difficulty': 'Easy', 'rating': 4.7, 'reviews': 445, 'type': 'gem', 'description': 'Spectacular gorges'},
    {'title': 'Kakamega Forest', 'location': 'Western Kenya', 'difficulty': 'Moderate', 'rating': 4.6, 'reviews': 189, 'type': 'gem', 'description': 'Tropical rainforest'},
    {'title': 'Ngare Ndare Forest', 'location': 'Meru', 'difficulty': 'Moderate', 'rating': 4.9, 'reviews': 312, 'type': 'gem', 'description': 'Canopy walks and waterfalls'},
    {'title': 'Oldonyo Sabuk', 'location': 'Machakos', 'difficulty': 'Challenging', 'rating': 4.5, 'reviews': 156, 'type': 'gem', 'description': 'Mountain sanctuary'},
    {'title': 'Shimba Hills', 'location': 'Kwale', 'difficulty': 'Easy', 'rating': 4.7, 'reviews': 267, 'type': 'gem', 'description': 'Coastal forest'},
    {'title': 'Mount Longonot', 'location': 'Naivasha', 'difficulty': 'Difficult', 'rating': 4.8, 'reviews': 523, 'type': 'gem', 'description': 'Dormant volcano'},
    {'title': 'Karura Forest', 'location': 'Nairobi', 'difficulty': 'Easy', 'rating': 4.6, 'reviews': 678, 'type': 'gem', 'description': 'Urban forest sanctuary'},
  ];

  final List<Map<String, dynamic>> _allOperators = [
    {'name': 'Safari Experts', 'logo': '🦁', 'tours': 45, 'rating': 4.9, 'reviews': 1240, 'verified': true, 'specialty': 'Wildlife', 'type': 'operator'},
    {'name': 'Mountain Guides Co', 'logo': '⛰️', 'tours': 32, 'rating': 4.8, 'reviews': 856, 'verified': true, 'specialty': 'Mountain', 'type': 'operator'},
    {'name': 'Beach Adventures', 'logo': '🏖️', 'tours': 28, 'rating': 4.7, 'reviews': 634, 'verified': true, 'specialty': 'Beach', 'type': 'operator'},
    {'name': 'Culture Tours Kenya', 'logo': '🎭', 'tours': 38, 'rating': 4.9, 'reviews': 945, 'verified': true, 'specialty': 'Culture', 'type': 'operator'},
    {'name': 'Adrenaline Rush', 'logo': '🪂', 'tours': 24, 'rating': 4.6, 'reviews': 423, 'verified': false, 'specialty': 'Adventure', 'type': 'operator'},
    {'name': 'Urban Explorer', 'logo': '🏙️', 'tours': 18, 'rating': 4.5, 'reviews': 567, 'verified': true, 'specialty': 'City', 'type': 'operator'},
    {'name': 'Wilderness Expeditions', 'logo': '🦒', 'tours': 52, 'rating': 4.9, 'reviews': 1456, 'verified': true, 'specialty': 'Wildlife', 'type': 'operator'},
  ];

  List<Map<String, dynamic>> get _allResults {
    if (_searchQuery.isEmpty) return [];

    final query = _searchQuery.toLowerCase();
    List<Map<String, dynamic>> results = [];

    // Search destinations
    results.addAll(_allDestinations.where((d) =>
        d['title'].toString().toLowerCase().contains(query) ||
        d['location'].toString().toLowerCase().contains(query) ||
        d['category'].toString().toLowerCase().contains(query)));

    // Search gems
    results.addAll(_allGems.where((g) =>
        g['title'].toString().toLowerCase().contains(query) ||
        g['location'].toString().toLowerCase().contains(query) ||
        g['description'].toString().toLowerCase().contains(query)));

    // Search operators
    results.addAll(_allOperators.where((o) =>
        o['name'].toString().toLowerCase().contains(query) ||
        o['specialty'].toString().toLowerCase().contains(query)));

    return results;
  }

  List<Map<String, dynamic>> get _destinationResults {
    if (_searchQuery.isEmpty) return [];
    final query = _searchQuery.toLowerCase();
    return _allDestinations.where((d) =>
        d['title'].toString().toLowerCase().contains(query) ||
        d['location'].toString().toLowerCase().contains(query) ||
        d['category'].toString().toLowerCase().contains(query)).toList();
  }

  List<Map<String, dynamic>> get _gemResults {
    if (_searchQuery.isEmpty) return [];
    final query = _searchQuery.toLowerCase();
    return _allGems.where((g) =>
        g['title'].toString().toLowerCase().contains(query) ||
        g['location'].toString().toLowerCase().contains(query) ||
        g['description'].toString().toLowerCase().contains(query)).toList();
  }

  List<Map<String, dynamic>> get _operatorResults {
    if (_searchQuery.isEmpty) return [];
    final query = _searchQuery.toLowerCase();
    return _allOperators.where((o) =>
        o['name'].toString().toLowerCase().contains(query) ||
        o['specialty'].toString().toLowerCase().contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          // Clear focus when going back
          _searchFocusNode.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search destinations, gems, operators...',
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.6),
                fontSize: 16,
              ),
            ),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
          ),
          actions: [
            if (_searchQuery.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _searchController.clear();
                  });
                },
              ),
          ],
          bottom: _searchQuery.isNotEmpty
              ? TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.berryCrush,
                  indicatorWeight: 3,
                  labelColor: AppColors.berryCrush,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  isScrollable: true,
                  tabs: [
                    Tab(text: 'All (${_allResults.length})'),
                    Tab(text: 'Destinations (${_destinationResults.length})'),
                    Tab(text: 'Gems (${_gemResults.length})'),
                    Tab(text: 'Operators (${_operatorResults.length})'),
                  ],
                )
              : null,
        ),
        body: _searchQuery.isEmpty
            ? _buildEmptySearchState()
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildAllResults(),
                  _buildDestinationResults(),
                  _buildGemResults(),
                  _buildOperatorResults(),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptySearchState() {
    final popularSearches = [
      'Safari',
      'Beach',
      'Maasai Mara',
      'Hidden gems',
      'Mountain hiking',
      'Wildlife',
      'Nairobi',
      'Culture tours',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Icon(
              Icons.search,
              size: 80,
              color: AppColors.grey.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Search ZuriTrails',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Find destinations, hidden gems, and tour operators',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Popular Searches',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popularSearches.map((search) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _searchQuery = search;
                    _searchController.text = search;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.beige.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.greyLight.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 16,
                        color: AppColors.berryCrush.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        search,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAllResults() {
    final results = _allResults;
    if (results.isEmpty) {
      return _buildNoResults();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        final type = item['type'] as String;

        switch (type) {
          case 'destination':
            return _buildDestinationCard(item);
          case 'gem':
            return _buildGemCard(item);
          case 'operator':
            return _buildOperatorCard(item);
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildDestinationResults() {
    final results = _destinationResults;
    if (results.isEmpty) return _buildNoResults();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) => _buildDestinationCard(results[index]),
    );
  }

  Widget _buildGemResults() {
    final results = _gemResults;
    if (results.isEmpty) return _buildNoResults();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) => _buildGemCard(results[index]),
    );
  }

  Widget _buildOperatorResults() {
    final results = _operatorResults;
    if (results.isEmpty) return _buildNoResults();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) => _buildOperatorCard(results[index]),
    );
  }

  Widget _buildDestinationCard(Map<String, dynamic> dest) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SafariDetailsScreen(
              safari: {
                'name': dest['title'],
                'location': dest['location'],
                'rating': dest['rating'],
                'price': dest['price'],
                'description': 'Experience ${dest['title']}',
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.beige.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              child: const Icon(Icons.landscape, size: 32, color: AppColors.greyLight),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.berryCrush.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          dest['category'],
                          style: const TextStyle(
                            color: AppColors.berryCrush,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, size: 14, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text(
                        '${dest['rating']}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dest['title'],
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
                      const Icon(Icons.location_on, size: 12, color: AppColors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          dest['location'],
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
                  const SizedBox(height: 6),
                  Text(
                    dest['price'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.berryCrush,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGemCard(Map<String, dynamic> gem) {
    final difficultyColor = _getDifficultyColor(gem['difficulty']);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GemDetailsScreen(
              gem: {
                'name': gem['title'],
                'location': gem['location'],
                'rating': gem['rating'],
                'difficulty': gem['difficulty'],
                'description': gem['description'],
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.beige.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              child: const Icon(Icons.diamond, size: 32, color: AppColors.warning),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: difficultyColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          gem['difficulty'],
                          style: TextStyle(
                            color: difficultyColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, size: 14, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text(
                        '${gem['rating']}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
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
                      const Icon(Icons.location_on, size: 12, color: AppColors.grey),
                      const SizedBox(width: 4),
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
                  const SizedBox(height: 4),
                  Text(
                    gem['description'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
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
    );
  }

  Widget _buildOperatorCard(Map<String, dynamic> op) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SafariDetailsScreen(
              safari: {
                'name': '${op['name']} Tours',
                'location': 'Multiple Locations',
                'rating': op['rating'],
                'price': 'Custom Pricing',
                'description': 'Verified tour operator with ${op['tours']} tours',
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  op['logo'] as String,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          op['name'] as String,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (op['verified'] == true)
                        const Icon(Icons.verified, size: 16, color: AppColors.info),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    op['specialty'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 13, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text(
                        '${op['rating']}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${op['reviews']})',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.tour, size: 13, color: AppColors.berryCrush),
                      const SizedBox(width: 4),
                      Text(
                        '${op['tours']} tours',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
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

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 60,
            color: AppColors.grey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for "${_searchQuery}"',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return AppColors.success;
      case 'Moderate':
        return AppColors.info;
      case 'Challenging':
        return AppColors.warning;
      case 'Difficult':
        return AppColors.error;
      default:
        return AppColors.grey;
    }
  }
}
