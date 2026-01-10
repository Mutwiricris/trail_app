import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/screens/safaris/safari_details_screen.dart';
import 'package:zuritrails/screens/gems/gem_details_screen.dart';
import 'package:zuritrails/screens/search/comprehensive_search_screen.dart';

/// Comprehensive browse screen with tabs for all content types
class ComprehensiveBrowseScreen extends StatefulWidget {
  final int initialTab;

  const ComprehensiveBrowseScreen({
    super.key,
    this.initialTab = 0,
  });

  @override
  State<ComprehensiveBrowseScreen> createState() => _ComprehensiveBrowseScreenState();
}

class _ComprehensiveBrowseScreenState extends State<ComprehensiveBrowseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  bool _isGridView = true;

  // Destinations filters
  String _destCategory = 'All';
  String _priceRange = 'All';
  String _destSort = 'Popular';

  // Gems filters
  String _gemDifficulty = 'All';
  String _gemRegion = 'All';
  String _gemSort = 'Popular';

  // Operators filters
  String _opSpecialty = 'All';
  bool _verifiedOnly = false;
  String _opSort = 'Top Rated';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _tabController.addListener(() {
      setState(() {
        _searchQuery = '';
        _searchController.clear();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // MOCK DATA
  final List<Map<String, dynamic>> _allDestinations = [
    {
      'title': 'Maasai Mara Safari',
      'location': 'Narok County',
      'image': 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800',
      'rating': 4.9,
      'price': 450,
      'priceDisplay': 'From \$450',
      'category': 'Wildlife',
      'reviews': 487,
      'popular': true,
    },
    {
      'title': 'Diani Beach Resort',
      'location': 'South Coast',
      'image': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800',
      'rating': 4.8,
      'price': 120,
      'priceDisplay': 'From \$120',
      'category': 'Beach',
      'reviews': 298,
      'popular': true,
    },
    {
      'title': 'Mount Kenya Hiking',
      'location': 'Central Kenya',
      'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      'rating': 4.7,
      'price': 280,
      'priceDisplay': 'From \$280',
      'category': 'Mountain',
      'reviews': 156,
      'popular': false,
    },
    {
      'title': 'Lamu Island Culture',
      'location': 'Lamu',
      'image': 'https://images.unsplash.com/photo-1523805009345-7448845a9e53?w=800',
      'rating': 4.6,
      'price': 200,
      'priceDisplay': 'From \$200',
      'category': 'Culture',
      'reviews': 223,
      'popular': false,
    },
    {
      'title': 'Tsavo Wildlife Safari',
      'location': 'Tsavo National Park',
      'image': 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=800',
      'rating': 4.8,
      'price': 350,
      'priceDisplay': 'From \$350',
      'category': 'Wildlife',
      'reviews': 342,
      'popular': true,
    },
    {
      'title': 'Nairobi City Tour',
      'location': 'Nairobi',
      'image': 'https://images.unsplash.com/photo-1611348524140-53c9a25263d6?w=800',
      'rating': 4.5,
      'price': 80,
      'priceDisplay': 'From \$80',
      'category': 'City',
      'reviews': 445,
      'popular': true,
    },
    {
      'title': 'Amboseli Elephant Safari',
      'location': 'Amboseli',
      'image': 'https://images.unsplash.com/photo-1564760055775-d63b17a55c44?w=800',
      'rating': 4.9,
      'price': 420,
      'priceDisplay': 'From \$420',
      'category': 'Wildlife',
      'reviews': 389,
      'popular': true,
    },
    {
      'title': 'Hell\'s Gate Adventure',
      'location': 'Nakuru',
      'image': 'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?w=800',
      'rating': 4.7,
      'price': 150,
      'priceDisplay': 'From \$150',
      'category': 'Adventure',
      'reviews': 267,
      'popular': false,
    },
  ];

  final List<Map<String, dynamic>> _allGems = [
    {
      'title': 'Chyulu Hills',
      'location': 'Makueni County',
      'image': 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=800',
      'difficulty': 'Moderate',
      'difficultyLevel': 2,
      'rating': 4.8,
      'reviews': 234,
      'region': 'Eastern',
      'popular': true,
      'description': 'Ancient volcanic hills',
    },
    {
      'title': 'Hell\'s Gate Gorge',
      'location': 'Nakuru',
      'image': 'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?w=800',
      'difficulty': 'Easy',
      'difficultyLevel': 1,
      'rating': 4.7,
      'reviews': 445,
      'region': 'Rift Valley',
      'popular': true,
      'description': 'Spectacular gorges',
    },
    {
      'title': 'Kakamega Forest',
      'location': 'Western Kenya',
      'image': 'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=800',
      'difficulty': 'Moderate',
      'difficultyLevel': 2,
      'rating': 4.6,
      'reviews': 189,
      'region': 'Western',
      'popular': false,
      'description': 'Tropical rainforest',
    },
    {
      'title': 'Ngare Ndare Forest',
      'location': 'Meru',
      'image': 'https://images.unsplash.com/photo-1511497584788-876760111969?w=800',
      'difficulty': 'Moderate',
      'difficultyLevel': 2,
      'rating': 4.9,
      'reviews': 312,
      'region': 'Central',
      'popular': true,
      'description': 'Canopy walks and waterfalls',
    },
    {
      'title': 'Oldonyo Sabuk',
      'location': 'Machakos',
      'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      'difficulty': 'Challenging',
      'difficultyLevel': 3,
      'rating': 4.5,
      'reviews': 156,
      'region': 'Central',
      'popular': false,
      'description': 'Mountain sanctuary',
    },
    {
      'title': 'Shimba Hills',
      'location': 'Kwale',
      'image': 'https://images.unsplash.com/photo-1590614147843-ab3d0bfa0c33?w=800',
      'difficulty': 'Easy',
      'difficultyLevel': 1,
      'rating': 4.7,
      'reviews': 267,
      'region': 'Coast',
      'popular': true,
      'description': 'Coastal forest',
    },
    {
      'title': 'Mount Longonot',
      'location': 'Naivasha',
      'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      'difficulty': 'Difficult',
      'difficultyLevel': 4,
      'rating': 4.8,
      'reviews': 523,
      'region': 'Rift Valley',
      'popular': true,
      'description': 'Dormant volcano',
    },
    {
      'title': 'Karura Forest',
      'location': 'Nairobi',
      'image': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800',
      'difficulty': 'Easy',
      'difficultyLevel': 1,
      'rating': 4.6,
      'reviews': 678,
      'region': 'Central',
      'popular': true,
      'description': 'Urban forest sanctuary',
    },
  ];

  final List<Map<String, dynamic>> _allOperators = [
    {
      'name': 'Safari Experts',
      'logo': '🦁',
      'tours': 45,
      'rating': 4.9,
      'reviews': 1240,
      'verified': true,
      'specialty': 'Wildlife',
      'description': 'Leading wildlife safari operator',
    },
    {
      'name': 'Mountain Guides Co',
      'logo': '⛰️',
      'tours': 32,
      'rating': 4.8,
      'reviews': 856,
      'verified': true,
      'specialty': 'Mountain',
      'description': 'Expert mountain guides',
    },
    {
      'name': 'Beach Adventures',
      'logo': '🏖️',
      'tours': 28,
      'rating': 4.7,
      'reviews': 634,
      'verified': true,
      'specialty': 'Beach',
      'description': 'Coastal adventures specialists',
    },
    {
      'name': 'Culture Tours Kenya',
      'logo': '🎭',
      'tours': 38,
      'rating': 4.9,
      'reviews': 945,
      'verified': true,
      'specialty': 'Culture',
      'description': 'Authentic cultural experiences',
    },
    {
      'name': 'Adrenaline Rush',
      'logo': '🪂',
      'tours': 24,
      'rating': 4.6,
      'reviews': 423,
      'verified': false,
      'specialty': 'Adventure',
      'description': 'Extreme sports adventures',
    },
    {
      'name': 'Urban Explorer',
      'logo': '🏙️',
      'tours': 18,
      'rating': 4.5,
      'reviews': 567,
      'verified': true,
      'specialty': 'City',
      'description': 'City tours and nightlife',
    },
    {
      'name': 'Wilderness Expeditions',
      'logo': '🦒',
      'tours': 52,
      'rating': 4.9,
      'reviews': 1456,
      'verified': true,
      'specialty': 'Wildlife',
      'description': 'Premium luxury safaris',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // Custom App Bar with Search
            Container(
              color: AppColors.white,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Top bar with title and actions
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Browse',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Search button
                        IconButton(
                          icon: const Icon(Icons.search, color: AppColors.textPrimary),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ComprehensiveSearchScreen(),
                              ),
                            );
                          },
                        ),
                        // Grid/List toggle
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
                        const SizedBox(width: 8),
                      ],
                    ),
                    // Tab Bar
                    TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.berryCrush,
                      indicatorWeight: 3,
                      labelColor: AppColors.berryCrush,
                      unselectedLabelColor: AppColors.textSecondary,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        Tab(text: 'Destinations'),
                        Tab(text: 'Hidden Gems'),
                        Tab(text: 'Operators'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Search Bar
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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
                    color: AppColors.beige.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.greyLight.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: AppColors.grey.withValues(alpha: 0.7), size: 20),
                      const SizedBox(width: 12),
                      Text(
                        'Search ${_getTabName()}...',
                        style: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Expanded(
              child: _buildTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  String _getTabName() {
    switch (_tabController.index) {
      case 0:
        return 'destinations';
      case 1:
        return 'hidden gems';
      case 2:
        return 'operators';
      default:
        return 'everything';
    }
  }

  Widget _buildTabContent() {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          // Filters Section
          _buildFiltersSection(),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDestinationsTab(),
                _buildGemsTab(),
                _buildOperatorsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SizedBox(
        height: 110,
        child: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildDestinationFilters(),
            _buildGemFilters(),
            _buildOperatorFilters(),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationFilters() {
    final categories = ['All', 'Wildlife', 'Beach', 'Mountain', 'Culture', 'Adventure', 'City'];
    final priceRanges = ['All', 'Budget (< \$100)', 'Mid (\$100-300)', 'Luxury (> \$300)'];
    final sortOptions = ['Popular', 'Price: Low-High', 'Price: High-Low', 'Rating'];

    return Column(
      children: [
        // Category chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((cat) {
              final isSelected = cat == _destCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) => setState(() => _destCategory = cat),
                  backgroundColor: AppColors.white,
                  selectedColor: AppColors.berryCrush.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.berryCrush : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 12,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.berryCrush : AppColors.greyLight,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        // Price and Sort
        Row(
          children: [
            Expanded(child: _buildDropdown(_priceRange, priceRanges, (v) => setState(() => _priceRange = v))),
            const SizedBox(width: 12),
            Expanded(child: _buildDropdown(_destSort, sortOptions, (v) => setState(() => _destSort = v), icon: Icons.sort)),
          ],
        ),
      ],
    );
  }

  Widget _buildGemFilters() {
    final difficulties = ['All', 'Easy', 'Moderate', 'Challenging', 'Difficult'];
    final regions = ['All', 'Central', 'Coast', 'Rift Valley', 'Western', 'Eastern'];
    final sortOptions = ['Popular', 'Rating', 'Easy-Hard', 'Hard-Easy'];

    return Column(
      children: [
        // Difficulty chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: difficulties.map((diff) {
              final isSelected = diff == _gemDifficulty;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(diff),
                  selected: isSelected,
                  onSelected: (selected) => setState(() => _gemDifficulty = diff),
                  backgroundColor: AppColors.white,
                  selectedColor: _getDifficultyColor(diff).withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? _getDifficultyColor(diff) : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 12,
                  ),
                  side: BorderSide(
                    color: isSelected ? _getDifficultyColor(diff) : AppColors.greyLight,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        // Region and Sort
        Row(
          children: [
            Expanded(child: _buildDropdown(_gemRegion, regions, (v) => setState(() => _gemRegion = v))),
            const SizedBox(width: 12),
            Expanded(child: _buildDropdown(_gemSort, sortOptions, (v) => setState(() => _gemSort = v), icon: Icons.sort)),
          ],
        ),
      ],
    );
  }

  Widget _buildOperatorFilters() {
    final specialties = ['All', 'Wildlife', 'Mountain', 'Beach', 'Culture', 'Adventure', 'City'];
    final sortOptions = ['Top Rated', 'Most Tours', 'A-Z'];

    return Column(
      children: [
        // Specialty chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: specialties.map((spec) {
              final isSelected = spec == _opSpecialty;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(spec),
                  selected: isSelected,
                  onSelected: (selected) => setState(() => _opSpecialty = spec),
                  backgroundColor: AppColors.white,
                  selectedColor: AppColors.berryCrush.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.berryCrush : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 12,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.berryCrush : AppColors.greyLight,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        // Verified and Sort
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                value: _verifiedOnly,
                onChanged: (v) => setState(() => _verifiedOnly = v ?? false),
                title: const Text('Verified Only', style: TextStyle(fontSize: 12)),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
                activeColor: AppColors.info,
              ),
            ),
            Expanded(child: _buildDropdown(_opSort, sortOptions, (v) => setState(() => _opSort = v), icon: Icons.sort)),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(String value, List<String> items, Function(String) onChanged, {IconData? icon}) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      itemBuilder: (context) => items.map((item) => PopupMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 13)))).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyLight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(icon ?? Icons.arrow_drop_down, size: 18),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy': return AppColors.success;
      case 'Moderate': return AppColors.info;
      case 'Challenging': return AppColors.warning;
      case 'Difficult': return AppColors.error;
      default: return AppColors.grey;
    }
  }

  Widget _buildDestinationsTab() {
    var filtered = _allDestinations.where((d) {
      if (_searchQuery.isNotEmpty && !d['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !d['location'].toString().toLowerCase().contains(_searchQuery.toLowerCase())) return false;
      if (_destCategory != 'All' && d['category'] != _destCategory) return false;
      if (_priceRange != 'All') {
        final price = d['price'] as int;
        if (_priceRange.contains('< \$100') && price >= 100) return false;
        if (_priceRange.contains('\$100-300') && (price < 100 || price > 300)) return false;
        if (_priceRange.contains('> \$300') && price <= 300) return false;
      }
      return true;
    }).toList();

    // Sort
    if (_destSort == 'Price: Low-High') filtered.sort((a, b) => (a['price'] as int).compareTo(b['price'] as int));
    else if (_destSort == 'Price: High-Low') filtered.sort((a, b) => (b['price'] as int).compareTo(a['price'] as int));
    else if (_destSort == 'Rating') filtered.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
    else filtered.sort((a, b) => a['popular'] == b['popular'] ? 0 : (a['popular'] == true ? -1 : 1));

    return _buildContentView(
      filtered,
      (item) => _buildDestinationCard(item),
      'destination',
    );
  }

  Widget _buildGemsTab() {
    var filtered = _allGems.where((g) {
      if (_searchQuery.isNotEmpty && !g['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !g['location'].toString().toLowerCase().contains(_searchQuery.toLowerCase())) return false;
      if (_gemDifficulty != 'All' && g['difficulty'] != _gemDifficulty) return false;
      if (_gemRegion != 'All' && g['region'] != _gemRegion) return false;
      return true;
    }).toList();

    // Sort
    if (_gemSort == 'Rating') filtered.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
    else if (_gemSort == 'Easy-Hard') filtered.sort((a, b) => (a['difficultyLevel'] as int).compareTo(b['difficultyLevel'] as int));
    else if (_gemSort == 'Hard-Easy') filtered.sort((a, b) => (b['difficultyLevel'] as int).compareTo(a['difficultyLevel'] as int));
    else filtered.sort((a, b) => a['popular'] == b['popular'] ? 0 : (a['popular'] == true ? -1 : 1));

    return _buildContentView(
      filtered,
      (item) => _buildGemCard(item),
      'gem',
    );
  }

  Widget _buildOperatorsTab() {
    var filtered = _allOperators.where((o) {
      if (_searchQuery.isNotEmpty && !o['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())) return false;
      if (_opSpecialty != 'All' && o['specialty'] != _opSpecialty) return false;
      if (_verifiedOnly && o['verified'] != true) return false;
      return true;
    }).toList();

    // Sort
    if (_opSort == 'Top Rated') filtered.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
    else if (_opSort == 'Most Tours') filtered.sort((a, b) => (b['tours'] as int).compareTo(a['tours'] as int));
    else if (_opSort == 'A-Z') filtered.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));

    return _buildContentView(
      filtered,
      (item) => _buildOperatorCard(item),
      'operator',
    );
  }

  Widget _buildContentView(List<Map<String, dynamic>> items, Widget Function(Map<String, dynamic>) cardBuilder, String type) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: AppColors.grey.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text('No ${type}s found', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            const Text('Try adjusting filters', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Text(
                '${items.length} ${type}${items.length == 1 ? '' : 's'} found',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isGridView
              ? GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) => cardBuilder(items[index]),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) => cardBuilder(items[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildDestinationCard(Map<String, dynamic> dest) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SafariDetailsScreen(
            safari: {
              'name': dest['title'],
              'location': dest['location'],
              'image': dest['image'],
              'rating': dest['rating'],
              'price': dest['priceDisplay'],
              'description': 'Experience ${dest['title']}',
            },
          ),
        ),
      ),
      child: Container(
        margin: _isGridView ? EdgeInsets.zero : const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _isGridView ? _buildDestGridContent(dest) : _buildDestListContent(dest),
      ),
    );
  }

  Widget _buildDestGridContent(Map<String, dynamic> dest) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.medium)),
              child: Container(
                height: 120,
                width: double.infinity,
                color: AppColors.beige.withValues(alpha: 0.3),
                child: const Icon(Icons.landscape, size: 40, color: AppColors.greyLight),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.berryCrush, borderRadius: BorderRadius.circular(12)),
                child: Text(dest['category'], style: const TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 10, color: AppColors.warning),
                    const SizedBox(width: 2),
                    Text('${dest['rating']}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dest['title'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 10, color: AppColors.grey),
                        const SizedBox(width: 2),
                        Expanded(child: Text(dest['location'], style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dest['priceDisplay'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.berryCrush)),
                    Text('${dest['reviews']} reviews', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDestListContent(Map<String, dynamic> dest) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppRadius.medium)),
          child: Container(
            width: 100,
            height: 100,
            color: AppColors.beige.withValues(alpha: 0.3),
            child: const Icon(Icons.landscape, size: 40, color: AppColors.greyLight),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.berryCrush.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(dest['category'], style: const TextStyle(color: AppColors.berryCrush, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const Spacer(),
                    const Icon(Icons.star, size: 14, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text('${dest['rating']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(dest['title'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: AppColors.grey),
                    const SizedBox(width: 4),
                    Expanded(child: Text(dest['location'], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(dest['priceDisplay'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.berryCrush)),
                    Text('${dest['reviews']} reviews', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGemCard(Map<String, dynamic> gem) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GemDetailsScreen(
            gem: {
              'name': gem['title'],
              'location': gem['location'],
              'image': gem['image'],
              'rating': gem['rating'],
              'difficulty': gem['difficulty'],
              'description': gem['description'],
            },
          ),
        ),
      ),
      child: Container(
        margin: _isGridView ? EdgeInsets.zero : const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _isGridView ? _buildGemGridContent(gem) : _buildGemListContent(gem),
      ),
    );
  }

  Widget _buildGemGridContent(Map<String, dynamic> gem) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.beige.withValues(alpha: 0.3),
            child: const Icon(Icons.landscape, size: 50, color: AppColors.greyLight),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, AppColors.black.withValues(alpha: 0.7)],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: _getDifficultyColor(gem['difficulty']), borderRadius: BorderRadius.circular(8)),
                      child: Text(gem['difficulty'], style: const TextStyle(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const Spacer(),
                    const Icon(Icons.star, size: 12, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text('${gem['rating']}', style: const TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(gem['title'], style: const TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 10, color: AppColors.white),
                    const SizedBox(width: 4),
                    Expanded(child: Text(gem['location'], style: TextStyle(color: AppColors.white.withValues(alpha: 0.9), fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGemListContent(Map<String, dynamic> gem) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppRadius.medium)),
            child: Container(
              width: 100,
              height: 100,
              color: AppColors.beige.withValues(alpha: 0.3),
              child: const Icon(Icons.landscape, size: 40, color: AppColors.greyLight),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: _getDifficultyColor(gem['difficulty']).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                        child: Text(gem['difficulty'], style: TextStyle(color: _getDifficultyColor(gem['difficulty']), fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, size: 14, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text('${gem['rating']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(gem['title'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: AppColors.grey),
                      const SizedBox(width: 4),
                      Expanded(child: Text(gem['location'], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('${gem['reviews']} reviews', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperatorCard(Map<String, dynamic> op) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SafariDetailsScreen(
            safari: {
              'name': '${op['name']} Tours',
              'location': 'Multiple Locations',
              'rating': op['rating'],
              'price': 'Custom Pricing',
              'description': op['description'],
            },
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.beige.withValues(alpha: 0.5), AppColors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: AppColors.greyLight.withValues(alpha: 0.3)),
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
                boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: 0.08), blurRadius: 8)],
              ),
              child: Center(child: Text(op['logo'] as String, style: const TextStyle(fontSize: 30))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(op['name'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      if (op['verified'] == true) const Icon(Icons.verified, size: 16, color: AppColors.info),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(op['specialty'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 13, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text('${op['rating']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text('(${op['reviews']})', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.tour, size: 13, color: AppColors.berryCrush),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text('${op['tours']} tours', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
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
}
