import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/services/location_service.dart';
import 'package:zuritrails/widgets/map/interactive_map.dart';
import 'package:zuritrails/screens/gems/gem_details_screen.dart';
import 'package:zuritrails/screens/activities/create_activity/activity_flow_coordinator.dart';
import 'package:zuritrails/models/activity_data.dart';
import 'package:zuritrails/widgets/activities/activity_preview_sheet.dart';
import 'package:zuritrails/widgets/common/stacked_avatars.dart';
import 'package:zuritrails/screens/social/nearby_travelers_screen.dart';
import 'package:zuritrails/screens/gems/create_gem/gem_flow_coordinator.dart';

/// Map-based explore screen for discovering hidden gems, tours, and destinations
class MapExploreScreen extends StatefulWidget {
  const MapExploreScreen({super.key});

  @override
  State<MapExploreScreen> createState() => _MapExploreScreenState();
}

class _MapExploreScreenState extends State<MapExploreScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  final LocationService _locationService = LocationService();

  LatLng _currentPosition = const LatLng(-1.2921, 36.8219); // Default to Nairobi
  bool _isLoadingLocation = true;
  int _travelersNearby = 0;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  double _currentZoom = 12.0;
  bool _isFabExpanded = false;
  final List<ActivityData> _createdActivities = [];

  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;
  late AnimationController _fabExpandController;
  late Animation<double> _fabExpandAnimation;

  final List<String> _filters = [
    'All',
    'Hidden Gems',
    'Tours',
    'Historic',
    'Destinations',
    'Nature',
  ];

  // Comprehensive places data with different types
  final List<Map<String, dynamic>> _allPlaces = [
    // Hidden Gems
    {
      'title': 'Chyulu Hills',
      'location': 'Makueni County',
      'coordinates': const LatLng(-2.6833, 37.8833),
      'category': 'Mountains',
      'rating': 4.8,
      'description': 'Volcanic hills with stunning views and wildlife',
      'type': 'Hidden Gems',
      'images': [
        'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=800',
        'https://images.unsplash.com/photo-1516026672322-bc52d61a55d5?w=800',
        'https://images.unsplash.com/photo-1523805009345-7448845a9e53?w=800',
      ],
    },
    {
      'title': 'Hell\'s Gate Gorge',
      'location': 'Naivasha',
      'coordinates': const LatLng(-0.9140, 36.3100),
      'category': 'Adventure',
      'rating': 4.9,
      'description': 'Dramatic cliffs and natural hot springs',
      'type': 'Hidden Gems',
      'images': [
        'https://images.unsplash.com/photo-1516026672322-bc52d61a55d5?w=800',
        'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=800',
        'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?w=800',
      ],
    },
    {
      'title': 'Karura Forest',
      'location': 'Nairobi',
      'coordinates': const LatLng(-1.2420, 36.8560),
      'category': 'Forest',
      'rating': 4.7,
      'description': 'Urban forest with hiking trails',
      'type': 'Hidden Gems',
      'images': [
        'https://images.unsplash.com/photo-1511497584788-876760111969?w=800',
        'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=800',
        'https://images.unsplash.com/photo-1448375240586-882707db888b?w=800',
      ],
    },
    {
      'title': 'Fourteen Falls',
      'location': 'Thika',
      'coordinates': const LatLng(-1.0833, 37.1667),
      'category': 'Waterfall',
      'rating': 4.5,
      'description': 'Series of beautiful waterfalls',
      'type': 'Hidden Gems',
      'images': [
        'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9?w=800',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
        'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=800',
      ],
    },

    // Tours
    {
      'title': 'Maasai Mara Safari',
      'location': 'Maasai Mara',
      'coordinates': const LatLng(-1.4061, 35.0061),
      'category': 'Safari',
      'rating': 4.9,
      'description': 'World-famous wildlife reserve',
      'type': 'Tours',
      'images': [
        'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800',
        'https://images.unsplash.com/photo-1535338454770-7a26e296c78a?w=800',
        'https://images.unsplash.com/photo-1493246507139-91e8fad9978e?w=800',
      ],
    },
    {
      'title': 'Lake Naivasha Boat Tour',
      'location': 'Naivasha',
      'coordinates': const LatLng(-0.7708, 36.3564),
      'category': 'Water',
      'rating': 4.6,
      'description': 'Freshwater lake with hippos and birds',
      'type': 'Tours',
      'images': [
        'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800',
        'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800',
        'https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=800',
      ],
    },
    {
      'title': 'Amboseli Elephant Safari',
      'location': 'Amboseli',
      'coordinates': const LatLng(-2.6527, 37.2606),
      'category': 'Safari',
      'rating': 4.8,
      'description': 'Elephants with Mt. Kilimanjaro backdrop',
      'type': 'Tours',
      'images': [
        'https://images.unsplash.com/photo-1564760055775-d63b17a55c44?w=800',
        'https://images.unsplash.com/photo-1549366021-9f761d450615?w=800',
        'https://images.unsplash.com/photo-1551316679-9c6ae9dec224?w=800',
      ],
    },

    // Historic Sites
    {
      'title': 'Fort Jesus',
      'location': 'Mombasa',
      'coordinates': const LatLng(-4.0619, 39.6774),
      'category': 'Monument',
      'rating': 4.7,
      'description': 'UNESCO World Heritage Portuguese fort',
      'type': 'Historic',
      'images': [
        'https://images.unsplash.com/photo-1555881400-74d7acaacd8b?w=800',
        'https://images.unsplash.com/photo-1568849676085-51415703900f?w=800',
        'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      ],
    },
    {
      'title': 'Gedi Ruins',
      'location': 'Kilifi',
      'coordinates': const LatLng(-3.3000, 40.0167),
      'category': 'Ruins',
      'rating': 4.4,
      'description': 'Ancient Swahili town ruins',
      'type': 'Historic',
      'images': [
        'https://images.unsplash.com/photo-1513415756133-14a9266d1c6a?w=800',
        'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=800',
        'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=800',
      ],
    },
    {
      'title': 'Karen Blixen Museum',
      'location': 'Nairobi',
      'coordinates': const LatLng(-1.3475, 36.7078),
      'category': 'Museum',
      'rating': 4.5,
      'description': 'Out of Africa author\'s home',
      'type': 'Historic',
      'images': [
        'https://images.unsplash.com/photo-1580655653885-65763b2597d0?w=800',
        'https://images.unsplash.com/photo-1582562124811-c09040d0a901?w=800',
        'https://images.unsplash.com/photo-1566043536725-d645e33d57c5?w=800',
      ],
    },

    // Destinations
    {
      'title': 'Diani Beach',
      'location': 'South Coast',
      'coordinates': const LatLng(-4.2967, 39.5775),
      'category': 'Beach',
      'rating': 4.8,
      'description': 'Pristine white sand beaches',
      'type': 'Destinations',
      'images': [
        'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800',
        'https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=800',
        'https://images.unsplash.com/photo-1473496169904-658ba7c44d8a?w=800',
      ],
    },
    {
      'title': 'Mount Kenya',
      'location': 'Central Kenya',
      'coordinates': const LatLng(-0.1521, 37.3084),
      'category': 'Mountain',
      'rating': 4.9,
      'description': 'Africa\'s second highest peak',
      'type': 'Destinations',
      'images': [
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
        'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800',
        'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?w=800',
      ],
    },
    {
      'title': 'Lamu Old Town',
      'location': 'Lamu',
      'coordinates': const LatLng(-2.2717, 40.9020),
      'category': 'Town',
      'rating': 4.7,
      'description': 'UNESCO Swahili settlement',
      'type': 'Destinations',
      'images': [
        'https://images.unsplash.com/photo-1585214165382-0f5b7e8fa73f?w=800',
        'https://images.unsplash.com/photo-1578331815944-28678e50f306?w=800',
        'https://images.unsplash.com/photo-1571201086995-ef2d15c0f76c?w=800',
      ],
    },

    // Nature
    {
      'title': 'Kakamega Forest',
      'location': 'Western Kenya',
      'coordinates': const LatLng(0.3000, 34.8500),
      'category': 'Forest',
      'rating': 4.6,
      'description': 'Last remaining rainforest',
      'type': 'Nature',
      'images': [
        'https://images.unsplash.com/photo-1511497584788-876760111969?w=800',
        'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=800',
        'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800',
      ],
    },
    {
      'title': 'Tsavo National Park',
      'location': 'Coast Province',
      'coordinates': const LatLng(-3.0000, 38.5000),
      'category': 'Park',
      'rating': 4.7,
      'description': 'Largest national park in Kenya',
      'type': 'Nature',
      'images': [
        'https://images.unsplash.com/photo-1547970810-dc1e684757a3?w=800',
        'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800',
        'https://images.unsplash.com/photo-1535338454770-7a26e296c78a?w=800',
      ],
    },
  ];

  List<Map<String, dynamic>> get _filteredPlaces {
    var places = _allPlaces;

    // Filter by type
    if (_selectedFilter != 'All') {
      places = places.where((place) => place['type'] == _selectedFilter).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      places = places.where((place) {
        final title = place['title'].toString().toLowerCase();
        final location = place['location'].toString().toLowerCase();
        final description = place['description'].toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) ||
               location.contains(query) ||
               description.contains(query);
      }).toList();
    }

    return places;
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
    _generateRandomTravelersCount();

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _fabExpandController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _fabExpandAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabExpandController,
        curve: Curves.easeOut,
      ),
    );

    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _fabExpandController.dispose();
    super.dispose();
  }

  void _toggleFab() {
    setState(() {
      _isFabExpanded = !_isFabExpanded;
      if (_isFabExpanded) {
        _fabExpandController.forward();
      } else {
        _fabExpandController.reverse();
      }
    });
  }

  void _showAddHiddenGemDialog() {
    _toggleFab(); // Close FAB
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GemFlowCoordinator(),
      ),
    );
  }

  void _showCreateActivityDialog() {
    _toggleFab(); // Close FAB
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ActivityFlowCoordinator(
          onActivityCreated: (activity) {
            setState(() {
              _createdActivities.add(activity);
            });
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }

  void _generateRandomTravelersCount() {
    setState(() {
      _travelersNearby = Random().nextInt(10) + 1;
    });
  }

  Future<void> _loadCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();
      if (mounted && position != null) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });
        _mapController.move(_currentPosition, 12.0);
      }
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _centerOnUserLocation() async {
    if (_isLoadingLocation) return;

    final position = await _locationService.getCurrentPosition();
    if (position != null && mounted) {
      final newLocation = LatLng(position.latitude, position.longitude);
      _mapController.move(newLocation, 14.0);
      setState(() {
        _currentPosition = newLocation;
      });
    }
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    // User location marker
    markers.add(
      Marker(
        point: _currentPosition,
        width: 50,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.info,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.info.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.navigation,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );

    // Show filtered places based on zoom level
    final placesToShow = _currentZoom >= 8.0 ? _filteredPlaces : _filteredPlaces;

    for (final place in placesToShow) {
      markers.add(
        Marker(
          point: place['coordinates'] as LatLng,
          width: 80,
          height: 80,
          child: GestureDetector(
            onTap: () => _showGemBottomSheet(place),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getMarkerColor(place['type']),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getMarkerIcon(place['category']),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    place['title'].toString().split(' ')[0],
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Add activity markers
    for (final activity in _createdActivities) {
      if (activity.latitude != null && activity.longitude != null) {
        markers.add(
          Marker(
            point: LatLng(activity.latitude!, activity.longitude!),
            width: 80,
            height: 80,
            child: GestureDetector(
              onTap: () => _showActivityPreview(activity),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.warning.withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      _getActivityIcon(activity.type),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Text(
                      'Activity',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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

    return markers;
  }

  IconData _getActivityIcon(String? type) {
    switch (type) {
      case 'food_drinks':
        return Icons.restaurant;
      case 'nightlife':
        return Icons.nightlife;
      case 'outdoor':
        return Icons.hiking;
      case 'sightseeing':
        return Icons.tour;
      case 'entertainment':
        return Icons.theater_comedy;
      case 'shopping':
        return Icons.shopping_bag;
      default:
        return Icons.groups;
    }
  }

  void _showActivityPreview(ActivityData activity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ActivityPreviewSheet(activity: activity),
    );
  }

  Color _getMarkerColor(String type) {
    switch (type) {
      case 'Hidden Gems':
        return AppColors.berryCrush;
      case 'Tours':
        return AppColors.categoryAdventure;
      case 'Historic':
        return AppColors.categoryCulture;
      case 'Destinations':
        return AppColors.info;
      case 'Nature':
        return AppColors.categoryNature;
      default:
        return AppColors.berryCrush;
    }
  }

  IconData _getMarkerIcon(String category) {
    switch (category) {
      case 'Mountains':
      case 'Mountain':
        return Icons.terrain;
      case 'Beach':
        return Icons.beach_access;
      case 'Forest':
        return Icons.forest;
      case 'Adventure':
        return Icons.hiking;
      case 'Park':
        return Icons.park;
      case 'Safari':
        return Icons.pets;
      case 'Water':
      case 'Waterfall':
        return Icons.water;
      case 'Monument':
      case 'Museum':
        return Icons.account_balance;
      case 'Ruins':
        return Icons.castle;
      case 'Town':
        return Icons.location_city;
      default:
        return Icons.place;
    }
  }

  void _showGemBottomSheet(Map<String, dynamic> gem) {
    final PageController pageController = PageController();
    int currentPage = 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          margin: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Scrollable image gallery
              if (gem['images'] != null && (gem['images'] as List).isNotEmpty)
                Column(
                  children: [
                    SizedBox(
                      height: 220,
                      child: PageView.builder(
                        controller: pageController,
                        onPageChanged: (index) {
                          setState(() {
                            currentPage = index;
                          });
                        },
                        itemCount: (gem['images'] as List).length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                gem['images'][index],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.beige,
                                    child: Icon(
                                      Icons.landscape,
                                      size: 64,
                                      color: AppColors.berryCrush.withOpacity(0.5),
                                    ),
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: AppColors.beige,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                        color: AppColors.berryCrush,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        (gem['images'] as List).length,
                        (index) => Container(
                          width: currentPage == index ? 24 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? AppColors.berryCrush
                                : AppColors.greyLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _getMarkerColor(gem['type']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getMarkerIcon(gem['category']),
                            color: _getMarkerColor(gem['type']),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gem['title'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 14,
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
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Type badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getMarkerColor(gem['type']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getMarkerColor(gem['type']).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        gem['type'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getMarkerColor(gem['type']),
                        ),
                      ),
                    ),

                    // Visitors with stacked avatars
                    if (gem['visitors'] != null && gem['visitors'] > 0) ...[
                      const SizedBox(height: 12),
                      StackedAvatarsWithLabel(
                        totalCount: gem['visitors'],
                        label: 'visited',
                        size: 26,
                      ),
                    ],

                    const SizedBox(height: 12),
                    Text(
                      gem['description'],
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GemDetailsScreen(gem: gem),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.berryCrush,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'View Full Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }

  void _showListBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  children: [
                    const Text(
                      'Hidden Gems Nearby',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.berryCrush.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_filteredPlaces.length} places',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.berryCrush,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // List
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredPlaces.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final place = _filteredPlaces[index];
                    return _buildListItem(place);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(Map<String, dynamic> gem) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.greyLight.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pop(context); // Close bottom sheet
            _showGemBottomSheet(gem);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _getMarkerColor(gem['type']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getMarkerIcon(gem['category']),
                    color: _getMarkerColor(gem['type']),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gem['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
                            size: 14,
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 12,
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
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.beige,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              gem['category'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Arrow
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition,
              initialZoom: 12.0,
              minZoom: 5.0,
              maxZoom: 18.0,
              onPositionChanged: (position, hasGesture) {
                if (position.zoom != null) {
                  setState(() {
                    _currentZoom = position.zoom!;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.zuritrails.app',
              ),
              MarkerLayer(
                markers: _buildMarkers(),
              ),
            ],
          ),

          // Top overlay with header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search bar
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search places...',
                        hintStyle: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.textSecondary,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),

                  // Filter chips
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      itemBuilder: (context, index) {
                        final filter = _filters[index];
                        final isSelected = filter == _selectedFilter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            backgroundColor: AppColors.white,
                            selectedColor: AppColors.berryCrush,
                            labelStyle: TextStyle(
                              color: isSelected ? AppColors.white : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            elevation: 2,
                            shadowColor: Colors.black.withOpacity(0.1),
                          ),
                        );
                      },
                    ),
                  ),

                  // Top bar
                  Row(
                    children: [
                      // Discover/Sparkles button
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.auto_awesome),
                          color: AppColors.berryCrush,
                          onPressed: () {
                            // Trigger discovery scan
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Scanning for hidden gems nearby...'),
                                backgroundColor: AppColors.berryCrush,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ),

                      const Spacer(),

                      // Travelers Here chip
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NearbyTravelersScreen(
                                count: _travelersNearby > 0 ? _travelersNearby : 8,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: AppColors.berryCrush.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 16,
                                      color: AppColors.berryCrush,
                                    ),
                                  ),
                                  if (_travelersNearby > 0)
                                    Positioned(
                                      right: -4,
                                      top: -4,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: AppColors.error,
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 16,
                                          minHeight: 16,
                                        ),
                                        child: Text(
                                          _travelersNearby.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Travelers Here',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.chevron_right,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Bottom controls
                  Row(
                    children: [
                      // List view toggle
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: _showListBottomSheet,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.view_list,
                                    size: 20,
                                    color: AppColors.textPrimary,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'List',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Expandable FAB with options
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Option 1: Add Hidden Gem
                          ScaleTransition(
                            scale: _fabExpandAnimation,
                            child: FadeTransition(
                              opacity: _fabExpandAnimation,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _showAddHiddenGemDialog,
                                    borderRadius: BorderRadius.circular(24),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.15),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.diamond,
                                            size: 20,
                                            color: AppColors.berryCrush,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Add Hidden Gem',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Option 2: Create Activity
                          ScaleTransition(
                            scale: _fabExpandAnimation,
                            child: FadeTransition(
                              opacity: _fabExpandAnimation,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _showCreateActivityDialog,
                                    borderRadius: BorderRadius.circular(24),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.15),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.groups,
                                            size: 20,
                                            color: AppColors.categoryAdventure,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Create Activity',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Main FAB
                          ScaleTransition(
                            scale: _fabScaleAnimation,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.berryCrush.withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: FloatingActionButton(
                                heroTag: 'map_scan_fab',
                                onPressed: _toggleFab,
                                backgroundColor: AppColors.berryCrush,
                                elevation: 0,
                                child: AnimatedRotation(
                                  duration: const Duration(milliseconds: 250),
                                  turns: _isFabExpanded ? 0.125 : 0, // 45 degree rotation
                                  child: Icon(
                                    _isFabExpanded ? Icons.close : Icons.add,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 16),

                      // Center on location button
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.my_location),
                          color: AppColors.berryCrush,
                          onPressed: _centerOnUserLocation,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Loading indicator
          if (_isLoadingLocation)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.berryCrush,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
