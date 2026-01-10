import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zuritrails/screens/navigation/gem_route_screen.dart';
import 'package:zuritrails/services/visit_tracking_service.dart';
import 'package:zuritrails/models/visit_record.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/utils/app_elevation.dart';
import 'package:zuritrails/widgets/details/enhanced_gallery.dart';
import 'package:zuritrails/widgets/details/info_card.dart';
import 'package:zuritrails/widgets/details/expandable_section.dart';
import 'package:zuritrails/widgets/details/highlights_grid.dart';
import 'package:zuritrails/widgets/details/tips_card.dart';
import 'package:zuritrails/widgets/details/weather_card.dart';
import 'package:zuritrails/widgets/details/nearby_section.dart';
import 'package:zuritrails/widgets/details/similar_destinations.dart';
import 'package:zuritrails/widgets/common/save_bottom_sheet.dart';
import 'package:zuritrails/widgets/common/stacked_avatars.dart';

class GemDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> gem;

  const GemDetailsScreen({
    super.key,
    required this.gem,
  });

  @override
  State<GemDetailsScreen> createState() => _GemDetailsScreenState();
}

class _GemDetailsScreenState extends State<GemDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showTitle) {
      setState(() => _showTitle = true);
    } else if (_scrollController.offset <= 200 && _showTitle) {
      setState(() => _showTitle = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String get _gemType => widget.gem['type'] ?? 'Nature';

  Map<String, dynamic> get _entryFeeInfo {
    if (widget.gem['entryFee'] != null) {
      return widget.gem['entryFee'];
    }
    return {
      'isFree': false,
      'citizens': 'KSh 500',
      'residents': 'KSh 800',
      'nonResidents': '\$15',
      'children': 'KSh 250',
    };
  }

  List<Map<String, dynamic>> get _amenities {
    if (widget.gem['amenities'] != null) {
      return List<Map<String, dynamic>>.from(widget.gem['amenities']);
    }
    return [
      {'icon': Icons.restaurant, 'name': 'Restaurant', 'available': true},
      {'icon': Icons.local_parking, 'name': 'Parking', 'available': true},
      {'icon': Icons.wifi, 'name': 'WiFi', 'available': false},
      {'icon': Icons.wc, 'name': 'Restrooms', 'available': true},
      {'icon': Icons.hotel, 'name': 'Accommodation', 'available': _gemType.toLowerCase().contains('hotel')},
      {'icon': Icons.local_cafe, 'name': 'Café', 'available': true},
      {'icon': Icons.shopping_bag, 'name': 'Gift Shop', 'available': true},
      {'icon': Icons.accessible, 'name': 'Wheelchair Access', 'available': false},
    ];
  }

  List<String> get _categories {
    if (widget.gem['categories'] != null) {
      return List<String>.from(widget.gem['categories']);
    }
    return [_gemType, 'Hidden Gem', 'Adventure'];
  }

  List<String> get _whatToBring {
    if (widget.gem['whatToBring'] != null) {
      return List<String>.from(widget.gem['whatToBring']);
    }
    return [
      'Comfortable hiking shoes',
      'Water bottle (2L minimum)',
      'Sunscreen & hat',
      'Camera for photos',
      'Light jacket',
      'Snacks',
      'First aid kit',
      'Insect repellent',
    ];
  }

  List<String> get _bestFor {
    if (widget.gem['bestFor'] != null) {
      return List<String>.from(widget.gem['bestFor']);
    }
    return ['Solo Travelers', 'Couples', 'Families', 'Groups', 'Photography'];
  }

  List<String> get _galleryImages {
    if (widget.gem['gallery'] != null && widget.gem['gallery'].length > 0) {
      return List<String>.from(widget.gem['gallery']);
    }
    return [
      widget.gem['image'] ?? '',
      'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=800',
      'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800',
      'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800',
    ];
  }

  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Sarah Johnson',
      'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      'rating': 5.0,
      'date': '2 days ago',
      'comment': 'Absolutely breathtaking! The views were incredible and the hiking trails were well maintained.',
    },
    {
      'name': 'Michael Chen',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'rating': 4.5,
      'date': '1 week ago',
      'comment': 'Great hidden gem! Not too crowded and the local guides were very knowledgeable.',
    },
    {
      'name': 'Emma Williams',
      'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
      'rating': 5.0,
      'date': '2 weeks ago',
      'comment': 'Perfect spot for photography. The sunset here was one of the best I\'ve ever seen!',
    },
  ];

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.success;
      case 'moderate':
        return AppColors.warning;
      case 'hard':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'hotel':
      case 'resort':
      case 'lodge':
        return Icons.hotel;
      case 'nature':
      case 'park':
      case 'forest':
        return Icons.forest;
      case 'beach':
      case 'coast':
        return Icons.beach_access;
      case 'mountain':
      case 'hiking':
        return Icons.terrain;
      case 'chill spot':
      case 'relaxation':
        return Icons.spa;
      case 'adventure':
        return Icons.hiking;
      case 'cultural':
      case 'heritage':
        return Icons.account_balance;
      default:
        return Icons.place;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Image Carousel Header
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: AppColors.white,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.bookmark_border, color: AppColors.berryCrush),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => SaveBottomSheet(
                            itemId: widget.gem['id'] ?? '',
                            itemName: widget.gem['name'] ?? 'Hidden Gem',
                            itemType: SaveItemType.gem,
                            itemData: widget.gem,
                          ),
                        );
                      },
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: _showTitle
                      ? Text(
                          widget.gem['title'] ?? widget.gem['name'] ?? '',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                  background: EnhancedGallery(
                    images: _galleryImages,
                    height: 400,
                    autoScroll: true,
                    autoScrollSeconds: 4,
                    showThumbnails: true,
                    showPhotoCount: true,
                    showGradient: true,
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.greyLight.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            widget.gem['title'] ?? widget.gem['name'] ?? 'Hidden Gem',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Type and location subtitle
                          Text(
                            '${widget.gem['type'] ?? 'Hidden Gem'} in ${widget.gem['location'] ?? 'Kenya'}',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Rating and reviews
                          if (widget.gem['rating'] != null)
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: AppColors.textPrimary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.gem['rating']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '·',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${_reviews.length} reviews',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                          // Visitors with stacked avatars
                          if (widget.gem['visitors'] != null && widget.gem['visitors'] > 0) ...[
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                StackedAvatars(
                                  totalCount: widget.gem['visitors'],
                                  size: 32,
                                  overlap: 14,
                                  maxVisible: 4,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'visited this place',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Operator/Host Section (always show)
                    _buildOperatorOrUserSection(),

                    // Quick Info Section
                    _buildQuickInfoCards(),

                    // Description Section (if available)
                    if (widget.gem['description'] != null)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.greyLight.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          widget.gem['description'],
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                            height: 1.6,
                          ),
                        ),
                      ),

                    // Map Section
                    _buildMapSection(),

                    // Amenities Section
                    _buildAmenitiesSection(),

                    // What to Bring Section
                    _buildWhatToBringSection(),

                    // Perfect For Section
                    _buildBestForSection(),

                    // Entry Fee Section
                    _buildEntryFeeSection(),

                    // Weather & Best Seasons
                    const WeatherCard(
                      title: 'Weather & Best Time to Visit',
                      useMockData: true,
                    ),

                    // Nearby Attractions
                    NearbySectionWidget(
                      title: 'Nearby Attractions',
                      places: [
                        NearbyPlace(
                          name: 'Karura Forest',
                          distance: '2.3 km',
                          imageUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400',
                          category: 'Nature',
                          categoryIcon: Icons.nature,
                        ),
                        NearbyPlace(
                          name: 'Giraffe Centre',
                          distance: '5.1 km',
                          imageUrl: 'https://images.unsplash.com/photo-1564760055775-d63b17a55c44?w=400',
                          category: 'Wildlife',
                          categoryIcon: Icons.pets,
                        ),
                        NearbyPlace(
                          name: 'Bomas of Kenya',
                          distance: '8.7 km',
                          imageUrl: 'https://images.unsplash.com/photo-1523805009345-7448845a9e53?w=400',
                          category: 'Culture',
                          categoryIcon: Icons.museum,
                        ),
                      ],
                    ),

                    // Local Tips & Cultural Insights
                    TipsCard(
                      title: 'Local Tips & Insights',
                      headerIcon: Icons.local_fire_department,
                      accentColor: AppColors.berryCrush,
                      tips: const [
                        TipItem(
                          title: 'Best Photography Time',
                          description: 'Golden hour (6-7am and 5:30-6:30pm) offers the most stunning lighting for photos.',
                          icon: Icons.camera_alt,
                          isImportant: true,
                        ),
                        TipItem(
                          title: 'Local Guides',
                          description: 'Hiring a local guide enhances your experience and supports the community.',
                          icon: Icons.person,
                        ),
                        TipItem(
                          title: 'Respect Wildlife',
                          description: 'Maintain a safe distance from animals. Do not feed or disturb them.',
                          icon: Icons.pets,
                          isImportant: true,
                        ),
                        TipItem(
                          title: 'Leave No Trace',
                          description: 'Carry out all trash. Help preserve this beautiful location for future visitors.',
                          icon: Icons.recycling,
                        ),
                      ],
                    ),

                    // Getting There
                    const GettingThereCard(
                      options: [
                        TransportOption(
                          method: 'By Private Car',
                          description: 'Most flexible option. Follow GPS coordinates or use Waze/Google Maps.',
                          icon: Icons.directions_car,
                          color: AppColors.info,
                          duration: '30 min from city center',
                        ),
                        TransportOption(
                          method: 'By Uber/Bolt',
                          description: 'Convenient ride-hailing service directly to the entrance.',
                          icon: Icons.local_taxi,
                          color: AppColors.warning,
                          duration: '25-35 min',
                        ),
                        TransportOption(
                          method: 'By Matatu',
                          description: 'Affordable public transport. Ask conductor for the nearest stop.',
                          icon: Icons.directions_bus,
                          color: AppColors.success,
                          duration: '45 min',
                        ),
                      ],
                      parkingInfo: 'Secure parking available on-site. KSh 200 for the day. Attendant present 7am-7pm.',
                    ),

                    // Reviews Section
                    _buildReviewsSection(),

                    // Similar Destinations
                    SimilarDestinationsWidget(
                      title: 'You might also like',
                      destinations: const [
                        SimilarDestination(
                          name: 'Ngong Hills',
                          imageUrl: 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=400',
                          location: 'Ngong',
                          rating: 4.7,
                          price: 'KSh 500',
                        ),
                        SimilarDestination(
                          name: 'Hell\'s Gate',
                          imageUrl: 'https://images.unsplash.com/photo-1549366021-9f761d450615?w=400',
                          location: 'Naivasha',
                          rating: 4.9,
                          price: 'KSh 350',
                        ),
                        SimilarDestination(
                          name: 'Ol Donyo Sabuk',
                          imageUrl: 'https://images.unsplash.com/photo-1682687220063-4742bd7fd538?w=400',
                          location: 'Thika',
                          rating: 4.5,
                          price: 'Free',
                        ),
                        SimilarDestination(
                          name: 'Paradise Lost',
                          imageUrl: 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=400',
                          location: 'Kiambu',
                          rating: 4.6,
                          price: 'KSh 300',
                        ),
                      ],
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),

          // Bottom Action Button
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    final location = widget.gem['location'] ?? 'Kenya';
    final locationDetails = widget.gem['locationDetails'] ?? widget.gem['location'] ?? 'Kenya';
    // Mock coordinates - in real app, these would come from the gem data
    final latitude = widget.gem['latitude'] ?? '-1.2921';
    final longitude = widget.gem['longitude'] ?? '36.8219';

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: AppElevation.lowShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Where You\'ll Be',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Location info
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 20,
                color: AppColors.berryCrush,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  location,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (locationDetails != location) ...[
            const SizedBox(height: 12),
            Text(
              locationDetails,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ],
          const SizedBox(height: 16),

          // Interactive Map Preview
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.beige.withValues(alpha: 0.3),
                    AppColors.berryCrush.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Grid pattern to simulate map
                  CustomPaint(
                    size: Size.infinite,
                    painter: _GemMapGridPainter(),
                  ),
                  // Location marker
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.berryCrush,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.berryCrush.withValues(alpha: 0.3),
                            blurRadius: 12,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.location_on,
                        size: 32,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  // Open in Maps button
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Material(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.small),
                      elevation: 2,
                      child: InkWell(
                        onTap: () async {
                          // Open location in maps app
                          final url = Uri.parse('https://maps.google.com/?q=$latitude,$longitude');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          }
                        },
                        borderRadius: BorderRadius.circular(AppRadius.small),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.map,
                                size: 18,
                                color: AppColors.berryCrush,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Open in Maps',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.berryCrush,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Coordinates display
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(AppRadius.small),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        '$latitude, $longitude',
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'monospace',
                          color: AppColors.textSecondary,
                        ),
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

  Widget _buildEntryFeeSection() {
    final isFree = _entryFeeInfo['isFree'] == true;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyLight.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Entry Fee',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          if (!isFree) ...[
            _buildFeeRow('Kenyan Citizens', _entryFeeInfo['citizens'] ?? 'KSh 500'),
            _buildFeeRow('East African Residents', _entryFeeInfo['residents'] ?? 'KSh 800'),
            _buildFeeRow('Non-Residents', _entryFeeInfo['nonResidents'] ?? '\$15'),
            _buildFeeRow('Children (3-12 years)', _entryFeeInfo['children'] ?? 'KSh 250'),
          ] else ...[
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 20,
                  color: AppColors.success,
                ),
                const SizedBox(width: 12),
                Text(
                  'Free entry',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeeRow(String label, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperatorOrUserSection() {
    final operator = widget.gem['operator'];
    final submittedBy = widget.gem['submittedBy'];

    // Determine if this is operator-hosted or user-submitted
    final isOperatorHosted = operator != null;
    final isUserSubmitted = submittedBy != null;

    String displayName;
    String labelText;
    bool isVerified = false;
    String? badge;
    IconData iconData;

    if (isOperatorHosted) {
      // Operator-hosted gem (cottage, lodge, or destination with operator)
      displayName = operator['name'] ?? 'Local Operator';
      labelText = 'Hosted by $displayName';
      isVerified = operator['verified'] == true;
      badge = operator['badge'];
      iconData = Icons.business;
    } else if (isUserSubmitted) {
      // User-submitted hidden gem
      displayName = submittedBy['name'] ?? submittedBy['username'] ?? 'Explorer';
      labelText = 'Shared by $displayName';
      isVerified = submittedBy['verified'] == true;
      badge = submittedBy['badge'];
      iconData = Icons.person;
    } else {
      // Fallback - show as public/community destination
      displayName = 'ZuriTrails Community';
      labelText = 'Shared by $displayName';
      isVerified = false;
      badge = 'Community Discovery';
      iconData = Icons.explore;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: AppElevation.lowShadow,
      ),
      child: Row(
        children: [
          // Avatar/icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.berryCrush.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Icon(
              iconData,
              size: 26,
              color: AppColors.berryCrush,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        displayName,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isVerified) ...[
                      const SizedBox(width: 6),
                      Icon(
                        Icons.verified,
                        size: 18,
                        color: AppColors.info,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  badge ?? (isOperatorHosted ? 'Tour Operator' : 'Explorer'),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoCards() {
    final duration = widget.gem['duration'] ?? '3-4 hours';
    final difficulty = widget.gem['difficulty'] ?? 'Moderate';
    final bestTime = widget.gem['bestTime'] ?? '6am - 6pm';
    final distance = widget.gem['distance'];

    // Get difficulty color
    Color difficultyColor;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        difficultyColor = AppColors.success;
        break;
      case 'moderate':
        difficultyColor = AppColors.warning;
        break;
      case 'hard':
      case 'difficult':
        difficultyColor = AppColors.error;
        break;
      default:
        difficultyColor = AppColors.info;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyLight.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: InfoCardGrid(
        cards: [
          InfoCardData(
            icon: Icons.access_time,
            label: 'Duration',
            value: duration,
          ),
          InfoCardData(
            icon: Icons.trending_up,
            label: 'Difficulty',
            value: difficulty,
            iconColor: difficultyColor,
            iconBackgroundColor: difficultyColor.withValues(alpha: 0.1),
          ),
          InfoCardData(
            icon: Icons.wb_sunny,
            label: 'Best Time',
            value: bestTime,
          ),
          if (distance != null)
            InfoCardData(
              icon: Icons.route,
              label: 'Distance',
              value: distance,
            ),
        ],
        crossAxisCount: 2,
        spacing: 12,
        compact: false,
      ),
    );
  }

  Widget _buildAmenitiesSection() {
    final availableAmenities = _amenities.where((a) => a['available'] == true).toList();
    final unavailableAmenities = _amenities.where((a) => a['available'] != true).toList();
    final displayCount = 6;
    final initialAmenities = [...availableAmenities.take(displayCount)];
    final remainingAmenities = [
      ...availableAmenities.skip(displayCount),
      ...unavailableAmenities,
    ];
    final hasMore = remainingAmenities.isNotEmpty;

    Widget buildAmenityItem(Map<String, dynamic> amenity) {
      final isAvailable = amenity['available'] == true;
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Icon(
              amenity['icon'],
              size: 24,
              color: isAvailable
                  ? AppColors.textPrimary
                  : AppColors.textSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 16),
            Text(
              amenity['name'],
              style: TextStyle(
                fontSize: 16,
                color: isAvailable
                    ? AppColors.textPrimary
                    : AppColors.textSecondary.withValues(alpha: 0.6),
                decoration: isAvailable ? null : TextDecoration.lineThrough,
              ),
            ),
          ],
        ),
      );
    }

    if (!hasMore) {
      // If 6 or fewer amenities, show all without expandable
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.greyLight.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What this place offers',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            ..._amenities.map(buildAmenityItem),
          ],
        ),
      );
    }

    // Show first 6, rest in expandable section
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What this place offers',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              ...initialAmenities.map(buildAmenityItem),
            ],
          ),
        ),
        ExpandableSection(
          title: 'Show all amenities',
          badgeText: '${remainingAmenities.length} more',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: remainingAmenities.map(buildAmenityItem).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildWhatToBringSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyLight.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What to bring',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ..._whatToBring.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 24,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
        ],
      ),
    );
  }

  Widget _buildBestForSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyLight.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Perfect for',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ..._bestFor.map((item) {
            IconData icon;
            switch (item.toLowerCase()) {
              case 'solo travelers':
              case 'solo':
                icon = Icons.person_outline;
                break;
              case 'couples':
                icon = Icons.favorite_border;
                break;
              case 'families':
                icon = Icons.family_restroom;
                break;
              case 'groups':
                icon = Icons.groups;
                break;
              case 'photography':
                icon = Icons.camera_alt_outlined;
                break;
              default:
                icon = Icons.check_circle_outline;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 24,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    item,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    final displayCount = 3;
    final hasMore = _reviews.length > displayCount;

    Widget buildReviewItem(Map<String, dynamic> review) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(review['avatar']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            review['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ...List.generate(
                            5,
                            (i) => Icon(
                              i < (review['rating'] ?? 5).floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 14,
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        review['date'],
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review['comment'],
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    if (!hasMore) {
      // Show all reviews if 3 or fewer
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.greyLight.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 22,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.gem['rating'] ?? 4.8} · ${_reviews.length} reviews',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ..._reviews.map(buildReviewItem),
          ],
        ),
      );
    }

    // Show first 3, rest expandable
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 22,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.gem['rating'] ?? 4.8} · ${_reviews.length} reviews',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ..._reviews.take(displayCount).map(buildReviewItem),
            ],
          ),
        ),
        ExpandableSection(
          title: 'Show all reviews',
          badgeText: '${_reviews.length - displayCount} more',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _reviews.skip(displayCount).map(buildReviewItem).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar() {
    final hasOperator = widget.gem['operator'] != null;
    final isFree = _entryFeeInfo['isFree'] == true;
    final isBookable = hasOperator || widget.gem['bookable'] == true;

    // Determine if this is a natural/free hidden gem or a bookable experience
    final isNaturalGem = !isBookable && isFree;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(
              color: AppColors.greyLight.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              if (!isNaturalGem) ...[
                // Show price info for bookable experiences
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              isFree ? 'Free entry' : (_entryFeeInfo['citizens'] ?? 'KSh 500'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isFree) ...[
                            Text(
                              ' / person',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (widget.gem['rating'] != null)
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 12,
                              color: AppColors.textPrimary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${widget.gem['rating']}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '(${_reviews.length} reviews)',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ] else ...[
                // For natural gems, show rating without price
                if (widget.gem['rating'] != null)
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.gem['rating']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${_reviews.length})',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const Spacer(),
                const SizedBox(width: 16),
              ],

              // Navigate button (Primary action - Open in-app navigation)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.berryCrush,
                        AppColors.berryCrushLight,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GemRouteScreen(gem: widget.gem),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.navigation,
                              size: 18,
                              color: AppColors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Navigate',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Mark as Visited button (Secondary - after physical visit)
              Consumer<VisitTrackingService>(
                builder: (context, visitService, _) {
                  final gemId = widget.gem['id'] ?? '';
                  final isVisited = visitService.hasVisited(gemId, 'gem');

                  return Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isVisited
                          ? AppColors.success
                          : AppColors.white,
                      border: Border.all(
                        color: isVisited
                            ? AppColors.success
                            : AppColors.greyLight,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isVisited
                            ? null
                            : () => _handleMarkAsVisited(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Center(
                          child: Icon(
                            isVisited ? Icons.check_circle : Icons.check_circle_outline,
                            size: 28,
                            color: isVisited
                                ? AppColors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handle marking gem as visited
  Future<void> _handleMarkAsVisited(BuildContext context) async {
    final gemId = widget.gem['id'] ?? '';
    final gemName = widget.gem['name'] ?? 'Hidden Gem';

    // Show confirmation dialog with option to add notes
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _MarkAsVisitedDialog(gemName: gemName),
    );

    if (result != null && mounted) {
      try {
        final visitService = context.read<VisitTrackingService>();

        // Record the visit
        await visitService.markAsVisited(
          placeId: gemId,
          placeType: 'gem',
          placeName: gemName,
          userId: 'current_user', // TODO: Get from auth service
          notes: result['notes'],
          userRating: result['rating'],
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Marked "$gemName" as visited!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'View',
                textColor: AppColors.white,
                onPressed: () {
                  // TODO: Navigate to visit history
                },
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error marking as visited: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}

/// Dialog for marking a gem as visited
class _MarkAsVisitedDialog extends StatefulWidget {
  final String gemName;

  const _MarkAsVisitedDialog({required this.gemName});

  @override
  State<_MarkAsVisitedDialog> createState() => _MarkAsVisitedDialogState();
}

class _MarkAsVisitedDialogState extends State<_MarkAsVisitedDialog> {
  final _notesController = TextEditingController();
  double _rating = 0;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Mark as Visited',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flow reminder
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.info.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Mark this only after you\'ve physically visited ${widget.gemName}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Rating
            const Text(
              'How was your experience?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0;
                    });
                  },
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: 32,
                    color: AppColors.warning,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // Notes (optional)
            const Text(
              'Add notes (optional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Share your thoughts about this place...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'notes': _notesController.text.trim().isEmpty
                  ? null
                  : _notesController.text.trim(),
              'rating': _rating > 0 ? _rating : null,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            foregroundColor: AppColors.white,
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

// Custom painter for map grid pattern
class _GemMapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.greyLight.withValues(alpha: 0.2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
