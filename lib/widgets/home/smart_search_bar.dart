import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zuritrails/utils/app_colors.dart';

class SmartSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback? onVoiceSearch;

  const SmartSearchBar({
    super.key,
    required this.onSearch,
    this.onVoiceSearch,
  });

  @override
  State<SmartSearchBar> createState() => _SmartSearchBarState();
}

class _SmartSearchBarState extends State<SmartSearchBar>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<String> _suggestions = [
    'Kakamega Forest',
    'Maasai Mara Safari',
    'Diani Beach',
    'Mount Kenya Trek',
    'Hell\'s Gate National Park',
    'Lake Nakuru Bird Watching',
  ];

  final List<String> _experienceSuggestions = [
    'Waterfall hikes',
    'Wildlife photography',
    'Cultural homestays',
    'Beach camping',
    'Mountain climbing',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    HapticFeedback.lightImpact();
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
        _focusNode.requestFocus();
      } else {
        _animationController.reverse();
        _focusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isExpanded ? _buildExpandedSearch() : _buildCollapsedSearch();
  }

  Widget _buildCollapsedSearch() {
    return GestureDetector(
      onTap: _toggleExpand,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.greyLight.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Search destinations, experiences, guides...',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.berryCrush.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.tune,
                color: AppColors.berryCrush,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedSearch() {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: AppColors.white,
        child: SafeArea(
          child: Column(
            children: [
              // Header with search input
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
                      onPressed: _toggleExpand,
                    ),
                    Expanded(
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.beige.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: AppColors.berryCrush,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  focusNode: _focusNode,
                                  autofocus: true,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Where to next?',
                                    hintStyle: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                              ),
                              if (_controller.text.isNotEmpty)
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: AppColors.textSecondary,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _controller.clear();
                                    setState(() {});
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (widget.onVoiceSearch != null) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.mic, color: AppColors.berryCrush),
                        onPressed: widget.onVoiceSearch,
                      ),
                    ],
                  ],
                ),
              ),

              // Search suggestions
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    if (_controller.text.isEmpty) ...[
                      _buildSuggestionSection(
                        'Try searching for',
                        _suggestions,
                        Icons.location_on,
                      ),
                      const SizedBox(height: 24),
                      _buildSuggestionSection(
                        'Search by experience',
                        _experienceSuggestions,
                        Icons.explore,
                      ),
                    ] else ...[
                      _buildLiveSuggestions(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionSection(
    String title,
    List<String> suggestions,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        ...suggestions.map((suggestion) {
          return InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              _controller.text = suggestion;
              widget.onSearch(suggestion);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.beige.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      size: 18,
                      color: AppColors.berryCrush,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      suggestion,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_outward,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildLiveSuggestions() {
    final filteredSuggestions = _suggestions
        .where((s) => s.toLowerCase().contains(_controller.text.toLowerCase()))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Results',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        if (filteredSuggestions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off,
                    size: 48,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No results found',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...filteredSuggestions.map((suggestion) {
            return InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                widget.onSearch(suggestion);
                _toggleExpand();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.berryCrush.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.location_on,
                        size: 18,
                        color: AppColors.berryCrush,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: _highlightMatch(
                            suggestion,
                            _controller.text,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_outward,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
      ],
    );
  }

  List<TextSpan> _highlightMatch(String text, String query) {
    final index = text.toLowerCase().indexOf(query.toLowerCase());
    if (index == -1) {
      return [
        TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
        ),
      ];
    }

    return [
      if (index > 0)
        TextSpan(
          text: text.substring(0, index),
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
        ),
      TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.berryCrush,
        ),
      ),
      if (index + query.length < text.length)
        TextSpan(
          text: text.substring(index + query.length),
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
        ),
    ];
  }
}
