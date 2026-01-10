import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zuritrails/models/achievement.dart';
import 'package:zuritrails/services/achievement_service.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_spacing.dart';
import 'package:zuritrails/utils/app_typography.dart';

/// Badge Gallery screen showing all achievements
class BadgeGalleryScreen extends StatefulWidget {
  const BadgeGalleryScreen({super.key});

  @override
  State<BadgeGalleryScreen> createState() => _BadgeGalleryScreenState();
}

class _BadgeGalleryScreenState extends State<BadgeGalleryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AchievementCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.white,
              surfaceTintColor: AppColors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Achievements',
                    style: AppTypography.displayMedium(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Consumer<AchievementService>(
                    builder: (context, service, child) {
                      final percentage = (service.unlockPercentage * 100).toInt();
                      return Text(
                        '$percentage% Complete • ${service.totalXP} XP',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  color: AppColors.white,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.berryCrush,
                    indicatorWeight: 3,
                    labelColor: AppColors.berryCrush,
                    unselectedLabelColor: AppColors.textSecondary,
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: const [
                      Tab(text: 'All'),
                      Tab(text: 'Unlocked'),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            // Category filter
            _buildCategoryFilter(),

            // Tab view
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllAchievements(),
                  _buildUnlockedAchievements(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = [
      (null, 'All', Icons.apps),
      (AchievementCategory.exploration, 'Exploration', Icons.explore),
      (AchievementCategory.distance, 'Distance', Icons.directions_walk),
      (AchievementCategory.consistency, 'Streaks', Icons.local_fire_department),
      (AchievementCategory.social, 'Social', Icons.people),
      (AchievementCategory.photography, 'Photo', Icons.photo_camera),
      (AchievementCategory.special, 'Special', Icons.star),
    ];

    return Container(
      height: 60,
      color: AppColors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.$1 == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category.$3,
                    size: 16,
                    color: isSelected ? AppColors.white : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(category.$2),
                ],
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category.$1;
                });
              },
              backgroundColor: AppColors.greyLight.withValues(alpha: 0.3),
              selectedColor: AppColors.berryCrush,
              labelStyle: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide.none,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAllAchievements() {
    return Consumer<AchievementService>(
      builder: (context, service, child) {
        var achievements = service.achievements;

        // Filter by category if selected
        if (_selectedCategory != null) {
          achievements = service.getAchievementsByCategory(_selectedCategory!);
        }

        if (achievements.isEmpty) {
          return _buildEmptyState(
            icon: Icons.emoji_events_outlined,
            title: 'No achievements',
            subtitle: 'Complete journeys to unlock achievements!',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 500));
          },
          color: AppColors.berryCrush,
          child: GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              return _AchievementCard(achievement: achievements[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildUnlockedAchievements() {
    return Consumer<AchievementService>(
      builder: (context, service, child) {
        var achievements = service.unlockedAchievements;

        // Filter by category if selected
        if (_selectedCategory != null) {
          achievements = achievements
              .where((a) => a.category == _selectedCategory)
              .toList();
        }

        if (achievements.isEmpty) {
          return _buildEmptyState(
            icon: Icons.lock_outline,
            title: 'No unlocked achievements',
            subtitle: 'Start exploring to unlock your first achievement!',
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            return _AchievementCard(achievement: achievements[index]);
          },
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.beige,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppColors.berryCrush,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showAchievementDetails(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: achievement.isUnlocked
              ? Border.all(color: achievement.rarityColor, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: achievement.isUnlocked
                  ? achievement.rarityColor.withValues(alpha: 0.2)
                  : AppColors.black.withValues(alpha: 0.06),
              blurRadius: achievement.isUnlocked ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: achievement.isUnlocked
                        ? achievement.color.withValues(alpha: 0.15)
                        : AppColors.greyLight.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    achievement.icon,
                    size: 40,
                    color: achievement.isUnlocked
                        ? achievement.color
                        : AppColors.grey,
                  ),
                ),
                if (!achievement.isUnlocked)
                  const Positioned(
                    child: Icon(
                      Icons.lock,
                      size: 24,
                      color: AppColors.grey,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                achievement.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: achievement.isUnlocked
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 4),

            // Rarity badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: achievement.rarityColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                achievement.rarityName,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: achievement.rarityColor,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Progress
            if (!achievement.isUnlocked) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: achievement.progress,
                        minHeight: 6,
                        backgroundColor: AppColors.greyLight.withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation(achievement.color),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      achievement.progressText,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 14,
                    color: achievement.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '+${achievement.xpReward} XP',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: achievement.color,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAchievementDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: achievement.isUnlocked
                        ? achievement.color.withValues(alpha: 0.15)
                        : AppColors.greyLight.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    achievement.icon,
                    size: 50,
                    color: achievement.isUnlocked
                        ? achievement.color
                        : AppColors.grey,
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Title
                Text(
                  achievement.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.xs),

                // Rarity
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: achievement.rarityColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    achievement.rarityName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: achievement.rarityColor,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Description
                Text(
                  achievement.description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.lg),

                // Progress or completion
                if (achievement.isUnlocked) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          achievement.color.withValues(alpha: 0.1),
                          achievement.color.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: achievement.color,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Unlocked!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Earned ${achievement.xpReward} XP',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.beige,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Progress',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              achievement.progressText,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: achievement.color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: achievement.progress,
                            minHeight: 8,
                            backgroundColor: AppColors.white,
                            valueColor: AlwaysStoppedAnimation(achievement.color),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
