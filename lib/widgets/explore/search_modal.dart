import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';

/// Modal for searching destinations with live results
class SearchModal extends StatefulWidget {
  final List<Map<String, dynamic>> allItems;
  final Function(Map<String, dynamic>) onItemTap;

  const SearchModal({
    super.key,
    required this.allItems,
    required this.onItemTap,
  });

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchResults = widget.allItems;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = widget.allItems;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = widget.allItems.where((item) {
        final title = (item['title'] ?? '').toString().toLowerCase();
        final location = (item['location'] ?? '').toString().toLowerCase();
        final description = (item['description'] ?? '').toString().toLowerCase();
        final category = (item['category'] ?? '').toString().toLowerCase();
        final searchLower = query.toLowerCase();

        return title.contains(searchLower) ||
            location.contains(searchLower) ||
            description.contains(searchLower) ||
            category.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header with search bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Search input
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: _performSearch,
                        decoration: InputDecoration(
                          hintText: 'Search destinations, locations...',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary.withValues(alpha: 0.6),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Search results
          Expanded(
            child: _searchResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isSearching ? Icons.search_off : Icons.explore,
                          size: 80,
                          color: AppColors.textSecondary.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isSearching
                              ? 'No results found'
                              : 'Start typing to search',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary.withValues(alpha: 0.6),
                          ),
                        ),
                        if (_isSearching) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Try different keywords',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final item = _searchResults[index];
                      return _buildResultCard(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        widget.onItemTap(item);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Container(
                width: 100,
                height: 100,
                color: AppColors.beige,
                child: item['image'] != null
                    ? Image.network(
                        item['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image,
                            size: 40,
                            color: AppColors.textSecondary.withValues(alpha: 0.3),
                          );
                        },
                      )
                    : Icon(
                        Icons.place,
                        size: 40,
                        color: AppColors.textSecondary.withValues(alpha: 0.3),
                      ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item['location'] ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary.withValues(alpha: 0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (item['rating'] != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${item['rating']}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (item['category'] != null) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.berryCrush.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['category'],
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.berryCrush,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Arrow
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
