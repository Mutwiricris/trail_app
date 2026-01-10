import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';

class UserStatsBar extends StatelessWidget {
  final int streak;
  final int badges;
  final int trips;
  final int points;

  const UserStatsBar({
    super.key,
    required this.streak,
    required this.badges,
    required this.trips,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.local_fire_department,
            value: '$streak',
            label: 'Day Streak',
            color: AppColors.warning,
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.emoji_events,
            value: '$badges',
            label: 'Badges',
            color: AppColors.berryCrush,
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.flight_takeoff,
            value: '$trips',
            label: 'Trips',
            color: AppColors.info,
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.stars,
            value: '$points',
            label: 'Points',
            color: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.greyLight.withOpacity(0.5),
    );
  }
}
