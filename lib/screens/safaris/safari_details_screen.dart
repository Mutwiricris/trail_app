import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/utils/app_elevation.dart';
import 'package:zuritrails/widgets/details/enhanced_gallery.dart';
import 'package:zuritrails/widgets/details/info_card.dart';
import 'package:zuritrails/widgets/details/expandable_section.dart';
import 'package:zuritrails/widgets/common/save_bottom_sheet.dart';

class SafariDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> safari;

  const SafariDetailsScreen({
    super.key,
    required this.safari,
  });

  @override
  State<SafariDetailsScreen> createState() => _SafariDetailsScreenState();
}

class _SafariDetailsScreenState extends State<SafariDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  // Sample data - in real app this would come from widget.safari
  late List<String> _galleryImages;
  late List<Map<String, dynamic>> _itinerary;
  late List<String> _included;
  late List<String> _excluded;
  late List<Map<String, dynamic>> _reviews;
  late List<Map<String, dynamic>> _accommodations;
  late List<String> _languages;
  late List<String> _highlights;
  late Map<String, dynamic> _transport;
  late Map<String, dynamic> _mealInfo;
  late List<Map<String, dynamic>> _faqs;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initializeData();
  }

  void _initializeData() {
    // Gallery images
    _galleryImages = widget.safari['gallery'] ?? [
      widget.safari['image'] ?? 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800',
      'https://images.unsplash.com/photo-1549366021-9f761d450615?w=800',
      'https://images.unsplash.com/photo-1534067783941-51c9c23ecefd?w=800',
      'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800',
    ];

    // Itinerary
    _itinerary = widget.safari['itinerary'] ?? [
      {
        'day': 'Day 1',
        'title': 'Arrival & Game Drive',
        'description': 'Pick up from Nairobi. Drive to Maasai Mara. Evening game drive.',
        'meals': ['Lunch', 'Dinner'],
      },
      {
        'day': 'Day 2',
        'title': 'Full Day Safari',
        'description': 'Full day game viewing across the plains. Visit to Mara River.',
        'meals': ['Breakfast', 'Lunch', 'Dinner'],
      },
      {
        'day': 'Day 3',
        'title': 'Morning Drive & Departure',
        'description': 'Early morning game drive. Return to Nairobi.',
        'meals': ['Breakfast', 'Lunch'],
      },
    ];

    // What's included
    _included = widget.safari['included'] ?? [
      'All park entry fees',
      'Professional safari guide',
      'Game drives in 4x4 vehicle',
      'Accommodation for 2 nights',
      'All meals as per itinerary',
      'Bottled water during game drives',
      'Airport/hotel pickup & drop-off',
    ];

    // What's excluded
    _excluded = widget.safari['excluded'] ?? [
      'International flights',
      'Travel insurance',
      'Personal expenses',
      'Tips and gratuities',
      'Alcoholic beverages',
      'Optional activities',
    ];

    // Reviews
    _reviews = widget.safari['reviews'] ?? [
      {
        'name': 'Sarah M.',
        'date': 'March 2024',
        'rating': 5.0,
        'comment': 'Incredible experience! Our guide was knowledgeable and we saw the Big Five. The lodge was comfortable and food was excellent.',
        'avatar': 'https://i.pravatar.cc/150?img=1',
      },
      {
        'name': 'John K.',
        'date': 'February 2024',
        'rating': 5.0,
        'comment': 'Best safari ever! Well organized, amazing wildlife sightings, and the sunset over the Mara was unforgettable.',
        'avatar': 'https://i.pravatar.cc/150?img=2',
      },
    ];

    // Accommodations
    _accommodations = widget.safari['accommodations'] ?? [
      {
        'name': 'Mara Serena Safari Lodge',
        'type': 'Luxury Lodge',
        'rating': 4.8,
        'roomType': 'Standard Double Room',
        'beds': '1 King bed or 2 Twin beds',
        'amenities': ['Private bathroom', 'Hot shower', 'Balcony with view', 'Mosquito net', 'Safe', 'Wi-Fi in lounge'],
        'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      },
      {
        'name': 'Luxury Tented Camp',
        'type': 'Tented Camp',
        'rating': 4.7,
        'roomType': 'Deluxe Safari Tent',
        'beds': '1 Queen bed',
        'amenities': ['En-suite bathroom', 'Solar-powered lighting', 'Eco-friendly', 'Private deck'],
        'image': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
      },
    ];

    // Transport details
    _transport = widget.safari['transport'] ?? {
      'type': 'Toyota Land Cruiser 4x4',
      'features': ['Pop-up roof for game viewing', 'Air conditioning', 'Charging ports', 'Cooler box'],
      'seats': 'Maximum 6 passengers per vehicle',
    };

    // Meal information
    _mealInfo = widget.safari['mealInfo'] ?? {
      'dietary': 'Vegetarian, vegan, and special dietary requirements accommodated',
      'style': 'Buffet breakfast and dinner, packed lunch on safari',
      'beverages': 'Tea, coffee, and water included. Soft drinks and alcohol available for purchase',
    };

    // Languages
    _languages = widget.safari['languages'] ?? ['English', 'Swahili', 'German'];

    // Tour highlights
    _highlights = widget.safari['highlights'] ?? [
      'Big Five game viewing',
      'Great Migration (seasonal)',
      'Sundowner at Mara River',
      'Visit to Maasai village',
      'Professional photography guide',
      'Luxury safari accommodation',
    ];

    // FAQs
    _faqs = widget.safari['faqs'] ?? [
      {
        'question': 'What is the best time to visit?',
        'answer': 'The Great Migration typically occurs from July to October. However, Maasai Mara offers excellent wildlife viewing year-round.',
      },
      {
        'question': 'Is this tour suitable for children?',
        'answer': 'Yes, children of all ages are welcome. However, please note that game drives can be long. We recommend this tour for children 5 years and older.',
      },
      {
        'question': 'What should I wear?',
        'answer': 'Neutral-colored clothing (khaki, brown, green) is recommended. Bring layers as mornings can be cool. Comfortable walking shoes are essential.',
      },
      {
        'question': 'Do I need vaccinations?',
        'answer': 'Yellow fever vaccination is recommended. Consult your doctor about malaria prophylaxis. Ensure routine vaccinations are up to date.',
      },
    ];
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

  // Helper method to create modern section cards
  Widget _buildModernCard({
    required String title,
    required Widget child,
    EdgeInsets? margin,
    EdgeInsets? padding,
  }) {
    return Container(
      margin: margin ?? const EdgeInsets.all(16),
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: AppElevation.lowShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
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
              // App bar with image carousel
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: AppColors.white,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.favorite_border, color: AppColors.textPrimary),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.share, color: AppColors.textPrimary),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.zero,
                  title: _showTitle
                      ? Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.only(left: 60, bottom: 16),
                          child: Text(
                            widget.safari['title'] ?? 'Safari',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
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
                    _buildTitleSection(),

                    // Operator Section (always show)
                    _buildOperatorSection(),

                    // Quick Info
                    _buildQuickInfo(),

                    // Description
                    if (widget.safari['description'] != null)
                      _buildDescriptionSection(),

                    // Map Section
                    _buildMapSection(),

                    // Highlights
                    _buildHighlightsSection(),

                    // Itinerary
                    _buildItinerarySection(),

                    // Accommodation Details
                    _buildAccommodationSection(),

                    // Transport Details
                    _buildTransportSection(),

                    // Meals Information
                    _buildMealsSection(),

                    // What's Included
                    _buildIncludedSection(),

                    // What's Excluded
                    _buildExcludedSection(),

                    // What to Bring
                    if (widget.safari['whatToBring'] != null)
                      _buildWhatToBringSection(),

                    // Meeting Point
                    _buildMeetingPointSection(),

                    // Languages
                    _buildLanguagesSection(),

                    // Health & Safety
                    _buildHealthSafetySection(),

                    // Cancellation Policy
                    _buildCancellationPolicy(),

                    // FAQs
                    _buildFAQsSection(),

                    // Reviews
                    _buildReviewsSection(),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),

          // Bottom booking bar
          _buildBottomBookingBar(),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
            widget.safari['title'] ?? 'Safari Tour',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                widget.safari['location'] ?? 'Kenya',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.access_time_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                widget.safari['duration'] ?? '3 Days',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (widget.safari['rating'] != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 20,
                  color: Colors.amber,
                ),
                const SizedBox(width: 6),
                Text(
                  '${widget.safari['rating']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '(${widget.safari['reviewCount'] ?? _reviews.length})',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOperatorSection() {
    final operator = widget.safari['operator'];
    final operatorName = operator?['name'] ?? 'Local Tour Operator';
    final isVerified = operator?['verified'] == true;
    final badge = operator?['badge'];

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
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.berryCrush.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Icon(
              Icons.business,
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
                        operatorName,
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
                  badge ?? 'Tour Operator',
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

  Widget _buildQuickInfo() {
    final duration = widget.safari['duration'] ?? '3 Days';
    final groupSize = widget.safari['groupSize'] ?? 'Max 6 people';
    final difficulty = widget.safari['difficulty'] ?? 'Moderate';
    final tourType = widget.safari['tourType'] ?? 'Safari';

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
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        boxShadow: AppElevation.lowShadow,
      ),
      child: InfoCardGrid(
        cards: [
          InfoCardData(
            icon: Icons.calendar_today,
            label: 'Duration',
            value: duration,
          ),
          InfoCardData(
            icon: Icons.group,
            label: 'Group Size',
            value: groupSize,
          ),
          InfoCardData(
            icon: Icons.trending_up,
            label: 'Difficulty',
            value: difficulty,
            iconColor: difficultyColor,
            iconBackgroundColor: difficultyColor.withValues(alpha: 0.1),
          ),
          InfoCardData(
            icon: Icons.explore,
            label: 'Tour Type',
            value: tourType,
          ),
        ],
        crossAxisCount: 2,
        spacing: 12,
        compact: false,
      ),
    );
  }

  Widget _buildDescriptionSection() {
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
            'About This Tour',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.safari['description'],
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    final location = widget.safari['location'] ?? 'Kenya';
    final locationDetails = widget.safari['locationDetails'] ?? widget.safari['location'] ?? 'Kenya';
    // Mock coordinates - in real app, these would come from the safari data
    final latitude = widget.safari['latitude'] ?? '-1.2921';
    final longitude = widget.safari['longitude'] ?? '36.8219';

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
                    painter: _MapGridPainter(),
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
                  // View in Maps button
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

  Widget _buildHighlightsSection() {
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
            'Tour highlights',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ..._highlights.map((highlight) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.stars,
                      size: 20,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        highlight,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildItinerarySection() {
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
            'Itinerary',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(_itinerary.length, (index) {
            final day = _itinerary[index];
            final isLast = index == _itinerary.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline
                  Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.berryCrush,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 60,
                          color: AppColors.berryCrush.withOpacity(0.3),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day['day'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          day['title'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          day['description'],
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        if (day['meals'] != null) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: (day['meals'] as List).map((meal) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.beige.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  meal,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAccommodationSection() {
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
            'Where you\'ll stay',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(_accommodations.length, (index) {
            final accommodation = _accommodations[index];
            final isLast = index == _accommodations.length - 1;

            return Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Accommodation image
                  if (accommodation['image'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        accommodation['image'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Name and rating
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          accommodation['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (accommodation['rating'] != null) ...[
                        Icon(Icons.star, size: 16, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Text(
                          '${accommodation['rating']}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Type and room details
                  Text(
                    '${accommodation['type']} • ${accommodation['roomType']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    accommodation['beds'],
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  // Amenities
                  if (accommodation['amenities'] != null) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (accommodation['amenities'] as List).map((amenity) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.beige.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            amenity,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTransportSection() {
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
            'Transport',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.directions_car, size: 24, color: AppColors.textPrimary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _transport['type'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _transport['seats'],
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
          const SizedBox(height: 16),
          ...(_transport['features'] as List).map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMealsSection() {
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
            'Meals',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(Icons.restaurant, 'Meal style', _mealInfo['style']),
          const SizedBox(height: 16),
          _buildDetailRow(Icons.local_drink, 'Beverages', _mealInfo['beverages']),
          const SizedBox(height: 16),
          _buildDetailRow(Icons.dining, 'Dietary options', _mealInfo['dietary']),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: AppColors.textPrimary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIncludedSection() {
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
            'What\'s included',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ..._included.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildExcludedSection() {
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
            'What\'s not included',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ..._excluded.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.cancel,
                      size: 20,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildWhatToBringSection() {
    final items = widget.safari['whatToBring'] ?? [];

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
          ...items.map<Widget>((item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMeetingPointSection() {
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
            'Meeting point',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.safari['meetingPoint'] ?? 'Pickup from your hotel in Nairobi or Jomo Kenyatta International Airport',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Pickup time: ${widget.safari['pickupTime'] ?? '6:00 AM'}',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagesSection() {
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
            'Languages',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _languages.map((language) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.beige.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.berryCrush.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  language,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthSafetySection() {
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
            'Health & safety',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _buildDetailRow(
            Icons.vaccines,
            'Vaccinations',
            'Yellow fever recommended. Consult your doctor about malaria prophylaxis.',
          ),
          const SizedBox(height: 20),
          _buildDetailRow(
            Icons.health_and_safety,
            'Travel insurance',
            'Comprehensive travel insurance strongly recommended.',
          ),
          const SizedBox(height: 20),
          _buildDetailRow(
            Icons.fitness_center,
            'Fitness level',
            'Moderate fitness required. Activities involve walking and sitting for extended periods.',
          ),
        ],
      ),
    );
  }

  Widget _buildCancellationPolicy() {
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
            'Cancellation policy',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Free cancellation up to 7 days before the tour starts. 50% refund if cancelled 3-7 days before. No refund for cancellations made less than 3 days before.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQsSection() {
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
            'Frequently asked questions',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          ..._faqs.map((faq) {
            return ExpandableListItem(
              title: faq['question'],
              content: faq['answer'],
              initiallyExpanded: false,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
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
                '${widget.safari['rating'] ?? 4.9} · ${widget.safari['reviewCount'] ?? _reviews.length} reviews',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) {
              final review = _reviews[index];
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
                              Text(
                                review['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
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
            },
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.textPrimary,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Show all ${_reviews.length} reviews',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBookingBar() {
    final price = widget.safari['price'] ?? 'KSh 45,000';
    final priceUnit = widget.safari['priceUnit'] ?? 'person';

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          ' / $priceUnit',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (widget.safari['rating'] != null)
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 12,
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${widget.safari['rating']}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '(${widget.safari['reviewCount'] ?? _reviews.length} reviews)',
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
              const SizedBox(width: 12),
              // Save button
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.berryCrush,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => SaveBottomSheet(
                          itemId: widget.safari['id'] ?? '',
                          itemName: widget.safari['title'] ?? 'Safari Tour',
                          itemType: SaveItemType.safari,
                          itemData: widget.safari,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Icon(
                        Icons.bookmark_border,
                        size: 20,
                        color: AppColors.berryCrush,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.berryCrush,
                      AppColors.berryCrushLight,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      child: Text(
                        'Book now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for map grid pattern
class _MapGridPainter extends CustomPainter {
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
