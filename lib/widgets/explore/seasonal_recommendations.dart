import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';

/// Seasonal recommendations based on current time of year
class SeasonalRecommendations extends StatelessWidget {
  final Function(Map<String, dynamic>)? onPlaceTap;

  const SeasonalRecommendations({super.key, this.onPlaceTap});

  @override
  Widget build(BuildContext context) {
    // Determine current season based on month
    final month = DateTime.now().month;
    final season = _getSeason(month);
    final recommendations = _getSeasonalRecommendations(season);

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        recommendations['color'].withValues(alpha: 0.2),
                        recommendations['color'].withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: Icon(
                    recommendations['icon'] as IconData,
                    size: 20,
                    color: recommendations['color'] as Color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recommendations['title'] as String,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        recommendations['subtitle'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: (recommendations['places'] as List).length,
              itemBuilder: (context, index) {
                final place = (recommendations['places'] as List)[index];
                return Container(
                  width: 320,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (recommendations['color'] as Color).withValues(alpha: 0.1),
                        AppColors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    border: Border.all(
                      color: (recommendations['color'] as Color).withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onPlaceTap?.call(place as Map<String, dynamic>),
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Icon circle
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    (recommendations['color'] as Color).withValues(alpha: 0.2),
                                    (recommendations['color'] as Color).withValues(alpha: 0.1),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  place['emoji'] as String,
                                  style: const TextStyle(fontSize: 36),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (recommendations['color'] as Color).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(AppRadius.small),
                                    ),
                                    child: Text(
                                      place['tag'] as String,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: recommendations['color'] as Color,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    place['name'] as String,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    place['description'] as String,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                      height: 1.3,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.schedule,
                                        size: 14,
                                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        place['duration'] as String,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(
                                        Icons.attach_money,
                                        size: 14,
                                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                                      ),
                                      Text(
                                        place['price'] as String,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary.withValues(alpha: 0.8),
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
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getSeason(int month) {
    if (month >= 6 && month <= 10) {
      return 'dry'; // Dry season (June-Oct)
    } else if (month >= 11 || month <= 2) {
      return 'short_rains'; // Short rains (Nov-Feb)
    } else {
      return 'long_rains'; // Long rains (Mar-May)
    }
  }

  Map<String, dynamic> _getSeasonalRecommendations(String season) {
    switch (season) {
      case 'dry':
        return {
          'title': 'Perfect for Safari Season',
          'subtitle': 'Best wildlife viewing now',
          'icon': Icons.wb_sunny,
          'color': AppColors.warning,
          'places': [
            {
              'name': 'Maasai Mara Safari',
              'description': 'Witness the Great Migration and abundant wildlife',
              'emoji': '🦁',
              'tag': 'BEST TIME',
              'duration': '3-5 days',
              'price': '\$450+',
            },
            {
              'name': 'Amboseli National Park',
              'description': 'Clear views of Mount Kilimanjaro and elephants',
              'emoji': '🐘',
              'tag': 'PEAK SEASON',
              'duration': '2-3 days',
              'price': '\$350+',
            },
            {
              'name': 'Tsavo Wildlife Safari',
              'description': 'Red elephants and diverse landscapes',
              'emoji': '🦒',
              'tag': 'POPULAR',
              'duration': '2-4 days',
              'price': '\$280+',
            },
          ],
        };
      case 'short_rains':
        return {
          'title': 'Beach & Coastal Escapes',
          'subtitle': 'Perfect weather for the coast',
          'icon': Icons.beach_access,
          'color': AppColors.info,
          'places': [
            {
              'name': 'Diani Beach Getaway',
              'description': 'White sand beaches and crystal clear waters',
              'emoji': '🏖️',
              'tag': 'IDEAL WEATHER',
              'duration': '3-7 days',
              'price': '\$120+',
            },
            {
              'name': 'Watamu Marine Park',
              'description': 'Snorkeling, diving, and pristine coral reefs',
              'emoji': '🤿',
              'tag': 'BEST CONDITIONS',
              'duration': '2-4 days',
              'price': '\$150+',
            },
            {
              'name': 'Lamu Island Culture',
              'description': 'Historic Swahili town and dhow sailing',
              'emoji': '⛵',
              'tag': 'CULTURAL',
              'duration': '3-5 days',
              'price': '\$200+',
            },
          ],
        };
      case 'long_rains':
        return {
          'title': 'Green Season Adventures',
          'subtitle': 'Lush landscapes & fewer crowds',
          'icon': Icons.forest,
          'color': AppColors.success,
          'places': [
            {
              'name': 'Aberdare Forest Retreat',
              'description': 'Misty mountains and unique wildlife',
              'emoji': '🌲',
              'tag': 'SCENIC',
              'duration': '2-3 days',
              'price': '\$180+',
            },
            {
              'name': 'Lake Naivasha Birdwatching',
              'description': 'Abundant migratory birds and boat rides',
              'emoji': '🦅',
              'tag': 'BIRDING PARADISE',
              'duration': '1-2 days',
              'price': '\$80+',
            },
            {
              'name': 'Kakamega Rainforest',
              'description': 'Kenya\'s last tropical rainforest',
              'emoji': '🦋',
              'tag': 'UNIQUE',
              'duration': '2-3 days',
              'price': '\$120+',
            },
          ],
        };
      default:
        return _getSeasonalRecommendations('dry');
    }
  }
}
