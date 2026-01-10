import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/widgets/home/safari_card.dart';
import 'package:zuritrails/widgets/home/category_chip.dart';
import 'package:zuritrails/widgets/home/verified_provider_card.dart';
import 'package:zuritrails/widgets/home/live_update_card.dart';
import 'package:zuritrails/widgets/home/section_header.dart';
import 'package:zuritrails/widgets/home/user_stats_bar.dart';
import 'package:zuritrails/widgets/home/gem_of_week_card.dart';
import 'package:zuritrails/screens/safaris/safari_details_screen.dart';
import 'package:zuritrails/widgets/home/explorer_card.dart';
import 'package:zuritrails/widgets/home/challenge_card.dart';
import 'package:zuritrails/widgets/home/trending_destination_card.dart';
import 'package:zuritrails/widgets/home/featured_carousel.dart';
import 'package:zuritrails/widgets/home/hidden_gems_carousel.dart';
import 'package:zuritrails/widgets/home/smart_search_bar.dart';
import 'package:zuritrails/widgets/home/story_avatar.dart';
import 'package:zuritrails/screens/stories/story_viewer_screen.dart';
import 'package:zuritrails/screens/stories/add_story_screen.dart';
import 'package:zuritrails/widgets/home/match_percentage_badge.dart';
import 'package:zuritrails/widgets/home/countdown_timer.dart';
import 'package:zuritrails/widgets/home/trend_indicator.dart';
import 'package:zuritrails/widgets/common/circular_progress_ring.dart';
import 'package:zuritrails/screens/gems/gem_details_screen.dart';
import 'package:zuritrails/screens/routes/route_browser_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Safaris';
  bool _isFabExpanded = false;

  // User stats
  final Map<String, dynamic> _userStats = {
    'streak': 5,
    'badges': 12,
    'trips': 8,
    'points': 2450,
  };

  // Featured carousel items
  final List<Map<String, dynamic>> _featuredItems = [
    {
      'title': 'Maasai Mara Safari Camp',
      'location': 'Narok County, Kenya',
      'description': 'Witness millions of wildebeest crossing the Mara River',
      'image': 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800',
      'type': 'Safari Tour',
      'price': 'KSh 45,000',
      'priceUnit': 'person',
      'rating': 4.9,
      'reviewCount': 487,
      'operator': {
        'name': 'Mara Expeditions',
        'verified': true,
        'badge': 'Verified operator',
      },
    },
    {
      'title': 'Mountain Lodge - Mount Kenya',
      'location': 'Central Kenya',
      'description': 'Conquer Africa\'s second-highest mountain',
      'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      'type': 'Mountain Lodge',
      'propertyType': 'Entire lodge',
      'guests': '6 guests',
      'beds': '3 bedrooms',
      'price': 'KSh 18,000',
      'priceUnit': 'night',
      'rating': 4.8,
      'reviewCount': 156,
      'operator': {
        'name': 'Highland Retreats',
        'verified': true,
        'badge': 'Verified operator',
      },
    },
    {
      'title': 'Beachfront Villa - Diani',
      'location': 'South Coast, Kwale',
      'description': 'Crystal-clear waters and pristine white sand beaches',
      'image': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800',
      'type': 'Beach Villa',
      'propertyType': 'Entire villa',
      'guests': '8 guests',
      'beds': '4 bedrooms',
      'price': 'KSh 28,000',
      'priceUnit': 'night',
      'rating': 4.7,
      'reviewCount': 298,
      'operator': {
        'name': 'Coastal Villas Kenya',
        'verified': true,
        'badge': 'Luxury Host',
      },
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.apps},
    {'name': 'Wildlife', 'icon': Icons.pets},
    {'name': 'Beaches', 'icon': Icons.beach_access},
    {'name': 'Mountains', 'icon': Icons.terrain},
    {'name': 'Culture', 'icon': Icons.temple_buddhist},
    {'name': 'Adventure', 'icon': Icons.hiking},
  ];

  final List<Map<String, dynamic>> _stories = [
    {
      'username': 'Sarah M.',
      'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      'hasStory': true,
      'location': 'Maasai Mara',
      'viewed': false,
      'progress': 0.0,
      'content': [
        {
          'type': 'image',
          'image': 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=800',
          'caption': 'Sunrise at Maasai Mara - absolutely breathtaking! 🌅',
          'timestamp': '2h ago',
        },
        {
          'type': 'image',
          'image': 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800',
          'caption': 'Spotted this beautiful giraffe on our morning drive',
          'timestamp': '2h ago',
        },
      ],
    },
    {
      'username': 'John D.',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'hasStory': true,
      'location': 'Amboseli',
      'viewed': false,
      'progress': 0.0,
      'content': [
        {
          'type': 'image',
          'image': 'https://images.unsplash.com/photo-1564760055775-d63b17a55c44?w=800',
          'caption': 'Elephants with Mt. Kilimanjaro in the background 🐘',
          'timestamp': '5h ago',
        },
      ],
    },
    {
      'username': 'Emma K.',
      'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
      'hasStory': true,
      'location': 'Lake Nakuru',
      'viewed': true,
      'progress': 1.0,
      'content': [
        {
          'type': 'image',
          'image': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800',
          'caption': 'Pink flamingos everywhere! Nature is amazing 💕',
          'timestamp': '1d ago',
        },
      ],
    },
    {
      'username': 'Mike R.',
      'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      'hasStory': true,
      'location': 'Tsavo',
      'viewed': false,
      'progress': 0.5,
      'content': [
        {
          'type': 'image',
          'image': 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800',
          'caption': 'Red elephants of Tsavo 🐘',
          'timestamp': '8h ago',
        },
        {
          'type': 'image',
          'image': 'https://images.unsplash.com/photo-1549366021-9f761d450615?w=800',
          'caption': 'Camping under the stars tonight',
          'timestamp': '8h ago',
        },
      ],
    },
  ];

  // Hidden Gem of the Week
  final Map<String, dynamic> _gemOfWeek = {
    'title': 'Chyulu Hills Green Paradise',
    'location': 'Makueni County',
    'image': 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=800',
    'description': 'Ancient volcanic hills with breathtaking views and diverse wildlife. Perfect for hiking and photography.',
    'distance': '45 km away',
    'visitors': 234,
    'rating': 4.8,
    'difficulty': 'Moderate',
  };

  // People exploring nearby
  final List<Map<String, dynamic>> _nearbyExplorers = [
    {
      'name': 'Alex M.',
      'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      'location': 'Hell\'s Gate',
      'time': '2 hours ago',
      'activity': 'hiking',
    },
    {
      'name': 'Lisa K.',
      'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
      'location': 'Lake Naivasha',
      'time': '5 hours ago',
      'activity': 'boat ride',
    },
    {
      'name': 'David R.',
      'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      'location': 'Mount Longonot',
      'time': 'Yesterday',
      'activity': 'climbing',
    },
  ];

  // Active challenges
  final List<Map<String, dynamic>> _challenges = [
    {
      'title': 'Big Five Spotter',
      'description': 'Spot all Big Five animals',
      'progress': 3,
      'total': 5,
      'reward': 500,
      'icon': Icons.camera_alt,
      'color': AppColors.warning,
    },
    {
      'title': 'Hidden Gem Hunter',
      'description': 'Visit 3 hidden gems this month',
      'progress': 1,
      'total': 3,
      'reward': 300,
      'icon': Icons.diamond,
      'color': AppColors.info,
    },
  ];

  final List<Map<String, dynamic>> _verifiedProviders = [
    {
      'name': 'Safari Seekers Kenya',
      'logo': 'https://images.unsplash.com/photo-1580674285054-bed31e145f59?w=200',
      'rating': 4.9,
      'tours': 48,
      'verified': true,
      'badge': 'Premium Partner',
    },
    {
      'name': 'Maasai Trails Co.',
      'logo': 'https://images.unsplash.com/photo-1517976487492-5750f3195933?w=200',
      'rating': 4.8,
      'tours': 32,
      'verified': true,
      'badge': 'Local Expert',
    },
  ];

  final List<Map<String, dynamic>> _liveUpdates = [
    {
      'type': 'sighting',
      'title': 'Lion Pride Spotted',
      'location': 'Maasai Mara',
      'time': '12 min ago',
      'icon': Icons.visibility,
      'color': AppColors.warning,
    },
    {
      'type': 'weather',
      'title': 'Perfect Safari Weather',
      'location': 'Amboseli Park',
      'time': '25 min ago',
      'icon': Icons.wb_sunny,
      'color': AppColors.info,
    },
    {
      'type': 'tip',
      'title': 'Best Time for Photos',
      'location': 'Lake Nakuru',
      'time': '1 hour ago',
      'icon': Icons.lightbulb,
      'color': AppColors.berryCrush,
    },
  ];

  // Recommended tours (personalized)
  final List<Map<String, dynamic>> _recommendedTours = [
    {
      'title': 'Luxury Safari Lodge - Maasai Mara',
      'provider': 'Safari Seekers Kenya',
      'location': 'Maasai Mara, Kenya',
      'image': 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800',
      'price': 'KSh 24,500',
      'priceUnit': 'night',
      'rating': 4.9,
      'reviewCount': 234,
      'verified': true,
      'type': 'Safari Lodge',
      'propertyType': 'Entire lodge',
      'guests': '4 guests',
      'beds': '2 bedrooms',
      'operator': {
        'name': 'Safari Seekers Kenya',
        'verified': true,
        'badge': 'Verified operator',
      },
    },
    {
      'title': 'Cozy Cottage - Lake Naivasha',
      'provider': 'Lake View Cottages',
      'location': 'Naivasha, Kenya',
      'image': 'https://images.unsplash.com/photo-1549366021-9f761d450615?w=800',
      'price': 'KSh 8,900',
      'priceUnit': 'night',
      'rating': 4.8,
      'reviewCount': 189,
      'verified': true,
      'type': 'Cottage',
      'propertyType': 'Entire cottage',
      'guests': '2 guests',
      'beds': '1 bedroom',
      'operator': {
        'name': 'Lake View Cottages',
        'verified': true,
        'badge': 'Verified operator',
      },
    },
    {
      'title': 'Beach Resort - Diani Beach',
      'provider': 'Coastal Paradise Resorts',
      'location': 'Diani, Kwale',
      'image': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800',
      'price': 'KSh 15,600',
      'priceUnit': 'night',
      'rating': 4.9,
      'reviewCount': 312,
      'verified': true,
      'type': 'Beach Resort',
      'propertyType': 'Hotel room',
      'guests': '2 guests',
      'beds': '1 king bed',
      'operator': {
        'name': 'Coastal Paradise',
        'verified': true,
        'badge': 'Luxury Host',
      },
    },
  ];

  // Trending destinations
  final List<Map<String, dynamic>> _trendingDestinations = [
    {
      'name': 'Amboseli National Park',
      'location': 'Kajiado County',
      'image': 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800',
      'trend': '+24%',
      'rating': 4.9,
      'isHotspot': true,
    },
    {
      'name': 'Diani Beach',
      'location': 'South Coast, Kwale',
      'image': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800',
      'trend': '+18%',
      'rating': 4.8,
      'isHotspot': true,
    },
    {
      'name': 'Mount Kenya',
      'location': 'Central Kenya',
      'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      'trend': '+15%',
      'rating': 4.7,
      'isHotspot': false,
    },
  ];

  // Hidden Gems - Undiscovered treasures of Kenya
  final List<Map<String, dynamic>> _hiddenGems = [
    {
      'title': 'Chyulu Hills Green Paradise',
      'location': 'Makueni County',
      'image': 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=800',
      'description': 'Ancient volcanic hills with breathtaking views and diverse wildlife. Perfect for hiking and photography enthusiasts seeking untouched landscapes.',
      'difficulty': 'Moderate',
      'rating': 4.8,
      'reviewCount': 124,
      'type': 'Nature Park',
      'operator': {
        'name': 'Makueni Eco Tours',
        'verified': true,
        'badge': 'Local Guide',
      },
      'duration': '4-5 hours',
      'bestTime': '6am - 4pm',
      'categories': ['Nature Park', 'Hidden Gem', 'Hiking', 'Photography'],
      'entryFee': {
        'isFree': false,
        'citizens': 'KSh 300',
        'residents': 'KSh 600',
        'nonResidents': '\$10',
        'children': 'KSh 150',
      },
      'amenities': [
        {'icon': Icons.restaurant, 'name': 'Restaurant', 'available': true},
        {'icon': Icons.local_parking, 'name': 'Parking', 'available': true},
        {'icon': Icons.wifi, 'name': 'WiFi', 'available': false},
        {'icon': Icons.wc, 'name': 'Restrooms', 'available': true},
        {'icon': Icons.hotel, 'name': 'Camping Sites', 'available': true},
        {'icon': Icons.local_cafe, 'name': 'Picnic Areas', 'available': true},
        {'icon': Icons.shopping_bag, 'name': 'Gift Shop', 'available': false},
        {'icon': Icons.accessible, 'name': 'Wheelchair Access', 'available': false},
      ],
      'whatToBring': [
        'Sturdy hiking boots',
        'Water bottle (3L recommended)',
        'Sunscreen SPF 50+',
        'Wide-brimmed hat',
        'Camera with extra batteries',
        'Light windbreaker jacket',
        'Energy snacks & lunch',
        'First aid kit',
        'Binoculars for wildlife',
        'Insect repellent',
      ],
      'bestFor': ['Solo Travelers', 'Couples', 'Photography', 'Groups', 'Nature Lovers'],
      'gallery': [
        'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=800',
        'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800',
        'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800',
        'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=800',
      ],
    },
    {
      'title': 'Hell\'s Gate Gorge',
      'location': 'Nakuru County',
      'image': 'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?w=800',
      'description': 'Dramatic volcanic gorge with towering cliffs and natural geothermal hot springs.',
      'difficulty': 'Easy',
      'rating': 4.7,
      'reviewCount': 89,
      'type': 'Adventure Park',
      'operator': {
        'name': 'Rift Valley Adventures',
        'verified': true,
        'badge': 'Verified operator',
      },
      'duration': '3-4 hours',
      'categories': ['Adventure', 'Hidden Gem', 'Cycling', 'Rock Climbing'],
      'entryFee': {
        'isFree': false,
        'citizens': 'KSh 250',
        'residents': 'KSh 500',
        'nonResidents': '\$26',
        'children': 'KSh 125',
      },
      'bestFor': ['Families', 'Cyclists', 'Rock Climbers', 'Groups'],
    },
    {
      'title': 'Kisite-Mpunguti Marine Park',
      'location': 'South Coast, Kwale',
      'image': 'https://images.unsplash.com/photo-1582967788606-a171c1080cb0?w=800',
      'description': 'Pristine coral reefs teeming with tropical fish, dolphins, and sea turtles.',
      'difficulty': 'Easy',
      'rating': 4.9,
      'reviewCount': 203,
      'type': 'Beach & Marine',
      'operator': {
        'name': 'Coastal Diving Kenya',
        'verified': true,
        'badge': 'Marine Expert',
      },
      'duration': '5-6 hours',
      'categories': ['Beach', 'Hidden Gem', 'Diving', 'Snorkeling'],
      'entryFee': {
        'isFree': false,
        'citizens': 'KSh 500',
        'residents': 'KSh 800',
        'nonResidents': '\$20',
        'children': 'KSh 250',
      },
      'amenities': [
        {'icon': Icons.restaurant, 'name': 'Seafood Restaurant', 'available': true},
        {'icon': Icons.hotel, 'name': 'Beach Resort', 'available': true},
        {'icon': Icons.local_cafe, 'name': 'Beach Bar', 'available': true},
      ],
      'bestFor': ['Couples', 'Families', 'Divers', 'Snorkelers'],
    },
    {
      'title': 'Kakamega Forest',
      'location': 'Western Kenya',
      'image': 'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=800',
      'description': 'Kenya\'s only tropical rainforest - home to rare birds, butterflies, and primates.',
      'difficulty': 'Moderate',
      'rating': 4.6,
      'reviewCount': 67,
      'type': 'Rainforest',
      'operator': {
        'name': 'Forest Conservancy',
        'verified': true,
        'badge': 'Eco Guide',
      },
      'categories': ['Forest', 'Hidden Gem', 'Birdwatching', 'Nature'],
      'entryFee': {
        'isFree': true,
      },
      'bestFor': ['Birdwatchers', 'Nature Lovers', 'Researchers', 'Families'],
    },
    {
      'title': 'Lake Bogoria Hot Springs',
      'location': 'Baringo County',
      'image': 'https://images.unsplash.com/photo-1523805009345-7448845a9e53?w=800',
      'description': 'Stunning alkaline lake with geysers, hot springs, and thousands of pink flamingos.',
      'difficulty': 'Easy',
      'rating': 4.7,
      'reviewCount': 156,
      'type': 'Chill Spot',
      'operator': {
        'name': 'Baringo Explorations',
        'verified': true,
        'badge': 'Local Expert',
      },
      'duration': '2-3 hours',
      'categories': ['Chill Spot', 'Hidden Gem', 'Relaxation', 'Nature'],
      'entryFee': {
        'isFree': false,
        'citizens': 'KSh 400',
        'residents': 'KSh 700',
        'nonResidents': '\$15',
        'children': 'KSh 200',
      },
      'amenities': [
        {'icon': Icons.spa, 'name': 'Natural Hot Springs', 'available': true},
        {'icon': Icons.local_cafe, 'name': 'Café', 'available': true},
        {'icon': Icons.hotel, 'name': 'Campsites', 'available': true},
      ],
      'bestFor': ['Couples', 'Relaxation', 'Photography', 'Solo Travelers'],
    },
  ];

  Widget _buildIconTab({
    required IconData icon,
    required String label,
    bool isNew = false,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                    ? AppColors.berryCrush.withOpacity(0.1)
                    : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: isSelected ? AppColors.berryCrush : AppColors.textSecondary,
                ),
              ),
              if (isNew)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.berryCrush,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'NEW',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 24,
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard({
    required String title,
    required String description,
    required int progress,
    required int total,
    required int reward,
    required IconData icon,
    required Color color,
  }) {
    final progressPercent = total > 0 ? (progress / total) : 0.0;
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyLight.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                '${(progressPercent * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressPercent,
              backgroundColor: AppColors.greyLight.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '$progress/$total completed',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Icon(Icons.stars, size: 14, color: AppColors.warning),
              const SizedBox(width: 4),
              Text(
                '+$reward pts',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSafariCard(Map<String, dynamic> item) {
    final hasOperator = item['operator'] != null;
    final operator = hasOperator ? item['operator'] : null;
    final isVerified = operator?['verified'] == true;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SafariDetailsScreen(safari: item),
          ),
        );
      },
      child: Container(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with favorite button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item['image'],
                    height: 280,
                    width: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 280,
                        width: 300,
                        color: AppColors.greyLight,
                        child: Icon(Icons.image, color: AppColors.textSecondary),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),

          // Location and operator badge
          Row(
            children: [
              Expanded(
                child: Text(
                  item['location'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isVerified)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified,
                      size: 16,
                      color: AppColors.info,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      operator['badge'] ?? 'Verified',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 4),

          // Property type or title
          Text(
            item['propertyType'] ?? item['type'] ?? item['title'],
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Guests and beds (if available)
          if (item['guests'] != null || item['beds'] != null)
            Text(
              [item['guests'], item['beds']].where((e) => e != null).join(' · '),
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          const SizedBox(height: 8),

          // Rating and price
          Row(
            children: [
              Icon(Icons.star, size: 14, color: AppColors.textPrimary),
              const SizedBox(width: 4),
              Text(
                '${item['rating']}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              if (item['reviewCount'] != null) ...[
                const SizedBox(width: 4),
                Text(
                  '(${item['reviewCount']})',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const Spacer(),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: item['price'],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (item['priceUnit'] != null)
                      TextSpan(
                        text: ' / ${item['priceUnit']}',
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
        ],
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          CustomScrollView(
        slivers: [
          // Search Bar at top
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      Icon(Icons.search, color: AppColors.textPrimary, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search destinations, wildlife, parks...',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          onTap: () {
                            // Handle search tap
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Icon Tabs (Homes/Experiences/Services)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildIconTab(
                    icon: Icons.explore_outlined,
                    label: 'Safaris',
                    isSelected: _selectedCategory == 'Safaris',
                    onTap: () {
                      setState(() => _selectedCategory = 'Safaris');
                    },
                  ),
                  _buildIconTab(
                    icon: Icons.location_on_outlined,
                    label: 'Hidden Gems',
                    isNew: true,
                    isSelected: _selectedCategory == 'Hidden Gems',
                    onTap: () {
                      setState(() => _selectedCategory = 'Hidden Gems');
                    },
                  ),
                  _buildIconTab(
                    icon: Icons.hotel_outlined,
                    label: 'Lodges',
                    isNew: true,
                    isSelected: _selectedCategory == 'Lodges',
                    onTap: () {
                      setState(() => _selectedCategory = 'Lodges');
                    },
                  ),
                ],
              ),
            ),
          ),

          // Travel Stories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _stories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddStoryScreen(),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.greyLight.withOpacity(0.3),
                                  border: Border.all(
                                    color: AppColors.greyLight,
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: AppColors.textPrimary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Add Story',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    final story = _stories[index - 1];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: StoryAvatar(
                        username: story['username'],
                        avatarUrl: story['avatar'],
                        hasStory: story['hasStory'],
                        location: story['location'],
                        viewed: story['viewed'] ?? false,
                        progress: (story['progress'] ?? 0.0).toDouble(),
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          // Open story viewer with this user's stories
                          final storyContent = story['content'] as List<dynamic>? ?? [];
                          if (storyContent.isNotEmpty) {
                            final userStories = storyContent.map((content) {
                              return {
                                ...content as Map<String, dynamic>,
                                'username': story['username'],
                              };
                            }).toList();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoryViewerScreen(
                                  stories: userStories,
                                  initialIndex: 0,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Hidden Gems Section (after stories)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Icon(
                    Icons.diamond,
                    size: 24,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Hidden Gems in Kenya',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward, size: 20, color: AppColors.textPrimary),
                ],
              ),
            ),
          ),

          // Hidden Gems Auto-Sliding Carousel
          SliverToBoxAdapter(
            child: HiddenGemsCarousel(
              gems: _hiddenGems,
              height: 280,
              onGemTap: (gem) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GemDetailsScreen(gem: gem),
                  ),
                );
              },
            ),
          ),

          // Recommended For You Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                children: [
                  Text(
                    'Recommended Tours',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward, size: 20, color: AppColors.textPrimary),
                ],
              ),
            ),
          ),

          // Recommended Accommodations Slider
          SliverToBoxAdapter(
            child: SizedBox(
              height: 370,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _recommendedTours.length,
                itemBuilder: (context, index) {
                  final item = _recommendedTours[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildSafariCard(item),
                  );
                },
              ),
            ),
          ),

          // Featured Safaris Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Text(
                    'Featured Safaris',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward, size: 20, color: AppColors.textPrimary),
                ],
              ),
            ),
          ),

          // Featured Safaris Slider
          SliverToBoxAdapter(
            child: SizedBox(
              height: 370,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _featuredItems.length,
                itemBuilder: (context, index) {
                  final item = _featuredItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildSafariCard(item),
                  );
                },
              ),
            ),
          ),

          // Trending Destinations Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                children: [
                  Text(
                    'Trending Destinations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward, size: 20, color: AppColors.textPrimary),
                ],
              ),
            ),
          ),

          // Trending Destinations Slider
          SliverToBoxAdapter(
            child: SizedBox(
              height: 370,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _recommendedTours.length,
                itemBuilder: (context, index) {
                  final item = _recommendedTours[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildSafariCard(item),
                  );
                },
              ),
            ),
          ),

          // Active Challenges Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                children: [
                  Text(
                    'Active Challenges',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward, size: 20, color: AppColors.textPrimary),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _challenges.length,
                itemBuilder: (context, index) {
                  final challenge = _challenges[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildChallengeCard(
                      title: challenge['title'],
                      description: challenge['description'],
                      progress: challenge['progress'],
                      total: challenge['total'],
                      reward: challenge['reward'],
                      icon: challenge['icon'],
                      color: challenge['color'],
                    ),
                  );
                },
              ),
            ),
          ),

          // People Exploring Near You
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                children: [
                  Text(
                    'Explorers Near You',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward, size: 20, color: AppColors.textPrimary),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _nearbyExplorers.length,
                itemBuilder: (context, index) {
                  final explorer = _nearbyExplorers[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ExplorerCard(
                      name: explorer['name'],
                      avatarUrl: explorer['avatar'],
                      location: explorer['location'],
                      time: explorer['time'],
                      activity: explorer['activity'],
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ),

          // Live Updates Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                children: [
                  Text(
                    'Live From The Field',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward, size: 20, color: AppColors.textPrimary),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _liveUpdates.length,
                itemBuilder: (context, index) {
                  final update = _liveUpdates[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: LiveUpdateCard(
                      title: update['title'],
                      location: update['location'],
                      time: update['time'],
                      icon: update['icon'],
                      color: update['color'],
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ),

          // Trusted Partners Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                children: [
                  Text(
                    'Trusted Safari Partners',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward, size: 20, color: AppColors.textPrimary),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _verifiedProviders.length,
                itemBuilder: (context, index) {
                  final provider = _verifiedProviders[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: VerifiedProviderCard(
                      name: provider['name'],
                      logoUrl: provider['logo'],
                      rating: provider['rating'],
                      tours: provider['tours'],
                      badge: provider['badge'],
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ),

          // Bottom Padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),

          // FAB overlay (backdrop)
          if (_isFabExpanded)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isFabExpanded = false;
                });
              },
              child: Container(
                color: AppColors.black.withOpacity(0.3),
              ),
            ),

          // Speed dial FAB
          _buildSpeedDialFab(),
        ],
      ),
    );
  }

  Widget _buildSpeedDialFab() {
    return Positioned(
      right: 16,
      bottom: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Action buttons (shown when expanded)
          if (_isFabExpanded) ...[
            _buildSpeedDialButton(
              icon: Icons.add_location_alt,
              label: 'Add Hidden Gem',
              onTap: () {
                setState(() => _isFabExpanded = false);
                // TODO: Navigate to add gem screen
              },
            ),
            const SizedBox(height: 12),
            _buildSpeedDialButton(
              icon: Icons.camera_alt,
              label: 'Scan Surroundings',
              onTap: () {
                setState(() => _isFabExpanded = false);
                // TODO: Open camera for AR scanning
              },
            ),
            const SizedBox(height: 12),
            _buildSpeedDialButton(
              icon: Icons.explore,
              label: 'Explore Nearby',
              onTap: () {
                setState(() => _isFabExpanded = false);
                // TODO: Show nearby gems on map
              },
            ),
            const SizedBox(height: 12),
            _buildSpeedDialButton(
              icon: Icons.flag_outlined,
              label: 'Report Issue',
              onTap: () {
                setState(() => _isFabExpanded = false);
                // TODO: Open report screen
              },
            ),
            const SizedBox(height: 16),
          ],

          // Main FAB
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _isFabExpanded = !_isFabExpanded;
              });
            },
            backgroundColor: AppColors.berryCrush,
            elevation: 4,
            child: AnimatedRotation(
              turns: _isFabExpanded ? 0.125 : 0, // 45 degrees when expanded
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _isFabExpanded ? Icons.close : Icons.add,
                color: AppColors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedDialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Button
        Material(
          color: AppColors.white,
          elevation: 4,
          borderRadius: BorderRadius.circular(28),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(28),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.berryCrush.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: AppColors.berryCrush,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
