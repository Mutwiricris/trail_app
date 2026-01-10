import 'package:flutter/material.dart';
import 'package:zuritrails/models/feed_item.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_typography.dart';
import 'package:zuritrails/utils/app_spacing.dart';
import 'package:zuritrails/widgets/common/sheets/app_bottom_sheet.dart';

/// Modern discovery feed screen with social features
class DiscoveryFeedScreen extends StatefulWidget {
  const DiscoveryFeedScreen({super.key});

  @override
  State<DiscoveryFeedScreen> createState() => _DiscoveryFeedScreenState();
}

class _DiscoveryFeedScreenState extends State<DiscoveryFeedScreen>
    with SingleTickerProviderStateMixin {
  final List<FeedItem> _feedItems = MockFeedData.getMockFeed();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
            // Modern App Bar
            SliverAppBar(
              floating: true,
              snap: true,
              elevation: 0,
              backgroundColor: AppColors.white,
              surfaceTintColor: AppColors.white,
              title: Text(
                'Feed',
                style: AppTypography.displayMedium(color: AppColors.textPrimary),
              ),
              actions: [
                // Filter button
                IconButton(
                  icon: Icon(
                    Icons.tune_rounded,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () {
                    _showFilterSheet(context);
                  },
                ),
                // Notifications button
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.notifications_outlined,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () {},
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.berryCrush,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
              ],
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
                      Tab(text: 'For You'),
                      Tab(text: 'Following'),
                      Tab(text: 'Trending'),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildFeedList(),
            _buildFeedList(),
            _buildFeedList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedList() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      color: AppColors.berryCrush,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        itemCount: _feedItems.length,
        itemBuilder: (context, index) {
          return _ModernFeedCard(
            item: _feedItems[index],
            onReact: () => _showReactionSheet(context, _feedItems[index]),
            onComment: () {},
            onShare: () {},
          );
        },
      ),
    );
  }

  Future<void> _showReactionSheet(BuildContext context, FeedItem item) async {
    await AppBottomSheet.showList<ReactionType>(
      context: context,
      title: 'React to this journey',
      items: ReactionType.values.map((type) {
        return AppBottomSheetItem<ReactionType>(
          title: type.label,
          subtitle: _getReactionDescription(type),
          icon: Icons.circle,
          value: type,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Reacted with ${type.emoji} ${type.label}'),
                duration: const Duration(seconds: 2),
                backgroundColor: AppColors.textPrimary,
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Future<void> _showFilterSheet(BuildContext context) async {
    await showModalBottomSheet(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter Feed',
                  style: AppTypography.displaySmall(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 20),
                _FilterOption(
                  title: 'Activity Type',
                  subtitle: 'All activities',
                  icon: Icons.directions_walk,
                  onTap: () {},
                ),
                _FilterOption(
                  title: 'Distance',
                  subtitle: 'Any distance',
                  icon: Icons.straighten,
                  onTap: () {},
                ),
                _FilterOption(
                  title: 'Location',
                  subtitle: 'Nearby',
                  icon: Icons.location_on,
                  onTap: () {},
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getReactionDescription(ReactionType type) {
    switch (type) {
      case ReactionType.inspired:
        return 'This made me want to explore';
      case ReactionType.respect:
        return 'Amazing achievement';
      case ReactionType.adventurous:
        return 'Bold exploration';
    }
  }
}

class _ModernFeedCard extends StatelessWidget {
  final FeedItem item;
  final VoidCallback onReact;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const _ModernFeedCard({
    required this.item,
    required this.onReact,
    required this.onComment,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyLight.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // Avatar with gradient border
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.berryCrush,
                        AppColors.berryCrushLight,
                      ],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.white,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.berryCrushLight,
                      child: Text(
                        item.userName[0].toUpperCase(),
                        style: AppTypography.buttonLarge(
                          color: AppColors.berryCrushDark,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.userName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          if (item.reactionsCount > 10)
                            Icon(
                              Icons.verified,
                              size: 16,
                              color: AppColors.berryCrush,
                            ),
                        ],
                      ),
                      Text(
                        item.timeAgo,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // More options
                IconButton(
                  icon: const Icon(
                    Icons.more_horiz,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Activity content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                if (item.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    item.description!,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                _StatChip(
                  icon: Icons.directions_walk,
                  label: '5.2 km',
                  color: AppColors.berryCrush,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  icon: Icons.timer_outlined,
                  label: '1h 23m',
                  color: AppColors.success,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  icon: Icons.location_on,
                  label: '3 places',
                  color: AppColors.warning,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Interaction bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                // Reactions
                Expanded(
                  child: _InteractionButton(
                    icon: Icons.favorite_border,
                    label: item.reactionsCount > 0
                        ? '${item.reactionsCount}'
                        : 'React',
                    onTap: onReact,
                  ),
                ),
                Expanded(
                  child: _InteractionButton(
                    icon: Icons.chat_bubble_outline,
                    label: 'Comment',
                    onTap: onComment,
                  ),
                ),
                Expanded(
                  child: _InteractionButton(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    onTap: onShare,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _InteractionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _FilterOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.beige,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.berryCrush, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
