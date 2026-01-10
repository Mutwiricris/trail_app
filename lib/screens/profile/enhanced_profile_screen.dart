import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zuritrails/models/user_profile.dart';
import 'package:zuritrails/services/journey_service.dart';
import 'package:zuritrails/services/memory_service.dart';
import 'package:zuritrails/services/achievement_service.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_typography.dart';
import 'package:zuritrails/utils/app_spacing.dart';
import 'package:zuritrails/widgets/common/stats_grid.dart';
import 'package:zuritrails/widgets/common/indicators/app_badge.dart';
import 'package:zuritrails/screens/memory/memory_timeline_screen.dart';
import 'package:zuritrails/screens/achievements/badge_gallery_screen.dart';
import 'package:zuritrails/screens/score/exploration_score_screen.dart';

/// Enhanced profile screen with explorer level, stats, and achievements
class EnhancedProfileScreen extends StatelessWidget {
  const EnhancedProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock user profile (in real app, get from auth service)
    final profile = UserProfile(
      id: '1',
      name: 'Chris Mutwiri',
      email: 'chris@zuritrails.com',
      joinedDate: DateTime.now().subtract(const Duration(days: 45)),
      level: ExplorerLevel.pathfinder,
      currentXP: 650,
      streakDays: 12,
      unlockedBadges: ['first_journey', 'sunrise_hunter', 'gem_finder'],
    );

    final journeyService = Provider.of<JourneyService>(context);
    final stats = journeyService.getTotalStats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            _ProfileHeader(profile: profile),

            const SizedBox(height: AppSpacing.md),

            // Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: StatsGrid(
                stats: [
                  StatItem(
                    value: stats['totalJourneys'].toString(),
                    label: 'Journeys',
                    icon: Icons.explore,
                  ),
                  StatItem(
                    value: '${stats['totalDistance'].toStringAsFixed(0)} km',
                    label: 'Distance',
                    icon: Icons.route,
                  ),
                  StatItem(
                    value: stats['totalPlaces'].toString(),
                    label: 'Places',
                    icon: Icons.place,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Exploration Score Card
            _ExplorationScoreCard(),

            const SizedBox(height: AppSpacing.lg),

            // Achievements
            _AchievementsSection(profile: profile),

            const SizedBox(height: AppSpacing.lg),

            // Memories
            const _MemoriesSection(),

            const SizedBox(height: AppSpacing.lg),

            // Journey history
            _JourneyHistorySection(journeyService: journeyService),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserProfile profile;

  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.berryCrush, AppColors.berryCrushDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 3),
                  color: AppColors.white,
                ),
                child: const Icon(Icons.person, size: 50, color: AppColors.grey),
              ),
              if (profile.streakDays > 0)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '🔥',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '${profile.streakDays}',
                          style: AppTypography.caption(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Name
          Text(
            profile.name,
            style: AppTypography.displaySmall(color: AppColors.white),
          ),

          const SizedBox(height: AppSpacing.xs),

          // Level
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                profile.level.icon,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${profile.level.displayName} Level ${profile.level.index + 1}',
                style: AppTypography.bodyMedium(color: AppColors.white),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Progress bar
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: profile.levelProgress,
                  minHeight: 8,
                  backgroundColor: AppColors.white.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation(AppColors.white),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${profile.xpToNextLevel} XP to ${profile.level.index < ExplorerLevel.values.length - 1 ? ExplorerLevel.values[profile.level.index + 1].displayName : 'Max Level'}',
                style: AppTypography.caption(color: AppColors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AchievementsSection extends StatelessWidget {
  final UserProfile profile;

  const _AchievementsSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    final allBadges = [
      _BadgeData('first_journey', 'First Journey', Icons.flag, AppColors.success),
      _BadgeData('sunrise_hunter', 'Sunrise Hunter', Icons.wb_sunny, AppColors.warning),
      _BadgeData('gem_finder', 'Gem Finder', Icons.diamond, AppColors.berryCrush),
      _BadgeData('social_explorer', 'Social Explorer', Icons.people, AppColors.info),
      _BadgeData('photo_master', 'Photo Master', Icons.photo_camera, AppColors.categoryNature),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievements',
                style: AppTypography.headline(),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BadgeGalleryScreen(),
                    ),
                  );
                },
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: allBadges.length,
            itemBuilder: (context, index) {
              final badge = allBadges[index];
              final isUnlocked = profile.unlockedBadges.contains(badge.id);
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: AppSpacing.sm),
                child: AchievementBadge(
                  title: badge.title,
                  icon: badge.icon,
                  iconColor: badge.color,
                  isLocked: !isUnlocked,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BadgeData {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  _BadgeData(this.id, this.title, this.icon, this.color);
}

class _MemoriesSection extends StatelessWidget {
  const _MemoriesSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<MemoryService>(
      builder: (context, memoryService, child) {
        final memories = memoryService.memories;
        final todaysMemories = memoryService.todaysMemories;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Memories',
                        style: AppTypography.headline(),
                      ),
                      if (todaysMemories.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.berryCrush,
                                AppColors.berryCrushDark,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                size: 12,
                                color: AppColors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${todaysMemories.length} today',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MemoryTimelineScreen(),
                        ),
                      );
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (memories.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.beige,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.photo_library_outlined,
                          size: 40,
                          color: AppColors.berryCrush,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'No memories yet',
                        style: AppTypography.bodyLarge(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Complete journeys to create memories',
                        style: AppTypography.caption(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: memories.take(5).length,
                  itemBuilder: (context, index) {
                    final memory = memories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MemoryTimelineScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: AppSpacing.sm),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: memory.photoUrl != null
                                  ? Image.network(
                                      memory.photoUrl!,
                                      width: 160,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 160,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.beige,
                                                AppColors.berryCrushLight.withValues(alpha: 0.3),
                                              ],
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.landscape,
                                            color: AppColors.berryCrush.withValues(alpha: 0.5),
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      width: 160,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.beige,
                                            AppColors.berryCrushLight.withValues(alpha: 0.3),
                                          ],
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.landscape,
                                        color: AppColors.berryCrush.withValues(alpha: 0.5),
                                      ),
                                    ),
                            ),
                            // Gradient overlay
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      AppColors.black.withValues(alpha: 0.6),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Text
                            Positioned(
                              bottom: 8,
                              left: 8,
                              right: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    memory.title,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    memory.timeAgoText,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.white.withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ExplorationScoreCard extends StatelessWidget {
  const _ExplorationScoreCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ExplorationScoreScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.berryCrush.withValues(alpha: 0.1),
              AppColors.berryCrushLight.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.berryCrush.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.berryCrush,
                    AppColors.berryCrushDark,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.emoji_events,
                size: 32,
                color: AppColors.white,
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Exploration Score',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'View your complete score breakdown',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: AppColors.berryCrush,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class _JourneyHistorySection extends StatelessWidget {
  final JourneyService journeyService;

  const _JourneyHistorySection({required this.journeyService});

  @override
  Widget build(BuildContext context) {
    final journeys = journeyService.getRecentJourneys(limit: 5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Journeys',
                style: AppTypography.headline(),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to full journey list
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        if (journeys.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.explore_off, size: 48, color: AppColors.grey),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'No journeys yet',
                    style: AppTypography.bodyMedium(),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: journeys.length,
            itemBuilder: (context, index) {
              final journey = journeys[index];
              return ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.berryCrushLight.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      journey.type.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                title: Text(journey.title, style: AppTypography.bodyLarge()),
                subtitle: Text(
                  '${journey.formattedDistance} • ${journey.formattedDuration}',
                  style: AppTypography.caption(),
                ),
                trailing: Text(
                  journey.placesCount.toString(),
                  style: AppTypography.buttonLarge(color: AppColors.berryCrush),
                ),
                onTap: () {
                  // TODO: Navigate to journey details
                },
              );
            },
          ),
      ],
    );
  }
}
