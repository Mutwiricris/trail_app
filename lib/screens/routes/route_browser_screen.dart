import 'package:flutter/material.dart';
import 'package:zuritrails/models/route.dart' as app_route;
import 'package:zuritrails/screens/routes/route_detail_screen.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Screen for browsing curated routes
class RouteBrowserScreen extends StatefulWidget {
  const RouteBrowserScreen({super.key});

  @override
  State<RouteBrowserScreen> createState() => _RouteBrowserScreenState();
}

class _RouteBrowserScreenState extends State<RouteBrowserScreen> {
  app_route.RouteType? _selectedType;
  app_route.RouteDifficulty? _selectedDifficulty;

  final List<app_route.Route> _routes = app_route.MockRouteData.getMockRoutes();

  List<app_route.Route> get _filteredRoutes {
    return _routes.where((route) {
      if (_selectedType != null && route.type != _selectedType) {
        return false;
      }
      if (_selectedDifficulty != null && route.difficulty != _selectedDifficulty) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Discover Routes'),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined, color: AppColors.berryCrush),
            onPressed: () {
              // TODO: Show all routes on map
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Route Type',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTypeChip(null, 'All'),
                      ...app_route.RouteType.values.map(
                        (type) => _buildTypeChip(type, type.displayName),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'Difficulty',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildDifficultyChip(null, 'All'),
                      ...app_route.RouteDifficulty.values.map(
                        (diff) => _buildDifficultyChip(diff, diff.displayName),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Routes List
          Expanded(
            child: _filteredRoutes.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: _filteredRoutes.length,
                    itemBuilder: (context, index) {
                      return _RouteCard(
                        route: _filteredRoutes[index],
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RouteDetailScreen(
                                route: _filteredRoutes[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(app_route.RouteType? type, String label) {
    final isSelected = _selectedType == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            _selectedType = isSelected ? null : type;
          });
        },
        backgroundColor: AppColors.white,
        selectedColor: AppColors.berryCrush.withValues(alpha: 0.15),
        checkmarkColor: AppColors.berryCrush,
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isSelected ? AppColors.berryCrush : AppColors.textSecondary,
        ),
        side: BorderSide(
          color: isSelected ? AppColors.berryCrush : AppColors.greyLight,
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(app_route.RouteDifficulty? difficulty, String label) {
    final isSelected = _selectedDifficulty == difficulty;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            _selectedDifficulty = isSelected ? null : difficulty;
          });
        },
        backgroundColor: AppColors.white,
        selectedColor: AppColors.berryCrush.withValues(alpha: 0.15),
        checkmarkColor: AppColors.berryCrush,
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isSelected ? AppColors.berryCrush : AppColors.textSecondary,
        ),
        side: BorderSide(
          color: isSelected ? AppColors.berryCrush : AppColors.greyLight,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.beige,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.route,
              size: 64,
              color: AppColors.berryCrush,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'No routes found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Route card widget
class _RouteCard extends StatelessWidget {
  final app_route.Route route;
  final VoidCallback onTap;

  const _RouteCard({
    required this.route,
    required this.onTap,
  });

  Color get _difficultyColor {
    switch (route.difficulty) {
      case app_route.RouteDifficulty.easy:
        return AppColors.success;
      case app_route.RouteDifficulty.moderate:
        return AppColors.warning;
      case app_route.RouteDifficulty.challenging:
      case app_route.RouteDifficulty.difficult:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image / Placeholder
            Container(
              height: 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.berryCrush.withValues(alpha: 0.2),
                    AppColors.info.withValues(alpha: 0.2),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          route.type.icon,
                          style: const TextStyle(fontSize: 48),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            route.type.displayName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.berryCrush,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Difficulty badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _difficultyColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            route.difficulty.icon,
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            route.difficulty.displayName,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route.name,
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
                        route.region,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    route.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      _buildStat(Icons.route, route.formattedDistance),
                      const SizedBox(width: 16),
                      _buildStat(Icons.access_time, route.formattedDuration),
                      if (route.formattedElevation != null) ...[
                        const SizedBox(width: 16),
                        _buildStat(Icons.trending_up, route.formattedElevation!),
                      ],
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Text(
                            route.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (route.hasSegments) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.diamond,
                            size: 14,
                            color: AppColors.info,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${route.segments.length} Hidden ${route.segments.length == 1 ? 'Segment' : 'Segments'}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.info,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.berryCrush),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
