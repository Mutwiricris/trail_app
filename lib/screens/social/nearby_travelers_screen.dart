import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/screens/social/chat_screen.dart';

class NearbyTravelersScreen extends StatelessWidget {
  final int count;

  const NearbyTravelersScreen({
    super.key,
    required this.count,
  });

  List<Map<String, dynamic>> _getMockTravelers() {
    return List.generate(count, (index) {
      final names = ['Sarah M.', 'John D.', 'Emma W.', 'Michael K.', 'Lisa R.',
                     'David P.', 'Anna L.', 'James B.', 'Sophie T.', 'Chris H.'];
      final locations = ['Nairobi', 'Mombasa', 'Kisumu', 'Nakuru', 'Eldoret'];
      final interests = ['Hiking', 'Photography', 'Wildlife', 'Culture', 'Food'];
      final distances = ['0.5 km', '1.2 km', '2.1 km', '3.5 km', '4.0 km'];

      return {
        'id': 'user_$index',
        'name': names[index % names.length],
        'avatar': 'https://i.pravatar.cc/150?img=${index + 10}',
        'location': locations[index % locations.length],
        'distance': distances[index % distances.length],
        'interests': [
          interests[index % interests.length],
          interests[(index + 1) % interests.length],
        ],
        'bio': 'Exploring hidden gems in Kenya 🌍✨',
        'isOnline': index % 3 == 0,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final travelers = _getMockTravelers();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Travelers Nearby',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: travelers.length,
        itemBuilder: (context, index) {
          final traveler = travelers[index];
          return _buildTravelerCard(context, traveler);
        },
      ),
    );
  }

  Widget _buildTravelerCard(BuildContext context, Map<String, dynamic> traveler) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar with online indicator
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(traveler['avatar']),
                      backgroundColor: AppColors.beige,
                    ),
                    if (traveler['isOnline'])
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        traveler['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
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
                          Text(
                            '${traveler['distance']} away • ${traveler['location']}',
                            style: const TextStyle(
                              fontSize: 13,
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
            const SizedBox(height: 12),
            Text(
              traveler['bio'],
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            // Interests
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (traveler['interests'] as List).map((interest) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.berryCrush.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    interest,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.berryCrush,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // View profile
                    },
                    icon: const Icon(Icons.person_outline, size: 18),
                    label: const Text('Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.greyLight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            userName: traveler['name'],
                            userAvatar: traveler['avatar'],
                            isOnline: traveler['isOnline'],
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: const Text('Chat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.berryCrush,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
