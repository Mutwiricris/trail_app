import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zuritrails/models/memory.dart';
import 'package:zuritrails/services/memory_service.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_spacing.dart';
import 'package:zuritrails/utils/app_typography.dart';
import 'package:zuritrails/widgets/memory/memory_card.dart';

/// Memory Timeline screen for viewing all memories
class MemoryTimelineScreen extends StatefulWidget {
  const MemoryTimelineScreen({super.key});

  @override
  State<MemoryTimelineScreen> createState() => _MemoryTimelineScreenState();
}

class _MemoryTimelineScreenState extends State<MemoryTimelineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
                    'Memories',
                    style: AppTypography.displayMedium(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Relive your adventures',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.calendar_month_outlined,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () {
                    // TODO: Show calendar view
                  },
                ),
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
                      Tab(text: 'On This Day'),
                      Tab(text: 'All Memories'),
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
            _buildOnThisDayTab(),
            _buildAllMemoriesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOnThisDayTab() {
    return Consumer<MemoryService>(
      builder: (context, memoryService, child) {
        final todaysMemories = memoryService.todaysMemories;

        if (todaysMemories.isEmpty) {
          return _buildEmptyState(
            icon: Icons.history,
            title: 'No memories for today',
            subtitle:
                'Check back on other days or complete more journeys to create memories!',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 500));
          },
          color: AppColors.berryCrush,
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: todaysMemories.length,
            itemBuilder: (context, index) {
              return MemoryCard(
                memory: todaysMemories[index],
                onTap: () {
                  // TODO: Navigate to journey detail
                },
                onShare: () {
                  _showShareDialog(todaysMemories[index]);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAllMemoriesTab() {
    return Consumer<MemoryService>(
      builder: (context, memoryService, child) {
        final memories = memoryService.memories;

        if (memories.isEmpty) {
          return _buildEmptyState(
            icon: Icons.photo_library_outlined,
            title: 'No memories yet',
            subtitle:
                'Complete journeys to automatically create memories you can revisit!',
          );
        }

        // Group memories by year
        final groupedMemories = <int, List<Memory>>{};
        for (final memory in memories) {
          final year = memory.originalDate.year;
          groupedMemories.putIfAbsent(year, () => []).add(memory);
        }

        final years = groupedMemories.keys.toList()..sort((a, b) => b.compareTo(a));

        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 500));
          },
          color: AppColors.berryCrush,
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: years.length,
            itemBuilder: (context, index) {
              final year = years[index];
              final yearMemories = groupedMemories[year]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Year header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.berryCrush,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          year.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${yearMemories.length} ${yearMemories.length == 1 ? 'memory' : 'memories'}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.berryCrush,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Memories for this year
                  ...yearMemories.map((memory) {
                    return MemoryCard(
                      memory: memory,
                      onTap: () {
                        // TODO: Navigate to journey detail
                      },
                      onShare: () {
                        _showShareDialog(memory);
                      },
                    );
                  }),

                  const SizedBox(height: AppSpacing.md),
                ],
              );
            },
          ),
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
          mainAxisSize: MainAxisSize.min,
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

  void _showShareDialog(Memory memory) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.share_outlined,
                color: AppColors.berryCrush,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Share Memory',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Share "${memory.title}" with your friends and inspire them to explore!',
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Memory shared successfully!'),
                    duration: Duration(seconds: 2),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.berryCrush,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Share',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
