import 'package:flutter/material.dart';
import 'package:zuritrails/models/hidden_gem.dart';
import 'package:zuritrails/screens/map/map_view_screen.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_typography.dart';
import 'package:zuritrails/utils/app_spacing.dart';
import 'package:zuritrails/widgets/common/cards/app_card.dart';
import 'package:zuritrails/widgets/common/buttons/filter_chip.dart';
import 'package:zuritrails/widgets/common/empty_state.dart';

/// Hidden gems feed screen
class GemsFeedScreen extends StatefulWidget {
  const GemsFeedScreen({super.key});

  @override
  State<GemsFeedScreen> createState() => _GemsFeedScreenState();
}

class _GemsFeedScreenState extends State<GemsFeedScreen> {
  GemCategory? _selectedCategory;
  final List<HiddenGem> _gems = MockGemsData.getMockGems();

  List<HiddenGem> get _filteredGems {
    if (_selectedCategory == null) return _gems;
    return _gems.where((g) => g.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hidden Gems'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MapViewScreen(
                    gems: _filteredGems,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Show search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          FilterChipList(
            items: [
              FilterChipItem(label: 'All', value: 'all'),
              ...GemCategory.values.map(
                (cat) => FilterChipItem(
                  label: cat.displayName,
                  value: cat.name,
                  icon: Icons.circle,
                ),
              ),
            ],
            selectedValue: _selectedCategory?.name ?? 'all',
            onChanged: (value) {
              setState(() {
                _selectedCategory = value == 'all'
                    ? null
                    : GemCategory.values.firstWhere((c) => c.name == value);
              });
            },
          ),

          const SizedBox(height: AppSpacing.md),

          // Gems list
          Expanded(
            child: _filteredGems.isEmpty
                ? const EmptyState(
                    icon: Icons.diamond_outlined,
                    title: 'No gems found',
                    message: 'Try a different category',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: _filteredGems.length,
                    itemBuilder: (context, index) {
                      return _GemCard(gem: _filteredGems[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Add new gem
        },
        icon: const Icon(Icons.add_location),
        label: const Text('Add Gem'),
      ),
    );
  }
}

class _GemCard extends StatelessWidget {
  final HiddenGem gem;

  const _GemCard({required this.gem});

  @override
  Widget build(BuildContext context) {
    return AppImageCard(
      imageWidget: Container(
        color: AppColors.surface,
        child: Center(
          child: Text(
            gem.category.icon,
            style: const TextStyle(fontSize: 60),
          ),
        ),
      ),
      onTap: () {
        // TODO: Navigate to gem details
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  gem.name,
                  style: AppTypography.headline(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: AppColors.warning),
                  const SizedBox(width: 2),
                  Text(
                    gem.formattedRating,
                    style: AppTypography.buttonMedium(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            gem.description,
            style: AppTypography.bodyMedium(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.diamond,
                size: 16,
                color: AppColors.berryCrush,
              ),
              const SizedBox(width: 4),
              Text(
                'Discovered by ${gem.discoveredBy} explorers',
                style: AppTypography.caption(color: AppColors.berryCrush),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
