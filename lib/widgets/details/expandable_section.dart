import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';

/// Expandable section widget with smooth animations
///
/// Features:
/// - Smooth AnimatedSize transition
/// - Expand/collapse icon with rotation
/// - Optional badge count
/// - Follows project section styling
/// - Customizable header and content
class ExpandableSection extends StatefulWidget {
  /// Section title
  final String title;

  /// Optional badge count (e.g., "5 items")
  final String? badgeText;

  /// Content widget to show when expanded
  final Widget child;

  /// Whether the section starts expanded (default: false)
  final bool initiallyExpanded;

  /// Optional icon to show before title
  final IconData? leadingIcon;

  /// Title font size (default: 22)
  final double titleFontSize;

  /// Padding around the section (default: 20 horizontal, 24 vertical)
  final EdgeInsets? padding;

  /// Whether to show a divider at the bottom (default: true)
  final bool showDivider;

  /// Optional callback when expansion state changes
  final ValueChanged<bool>? onExpansionChanged;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.child,
    this.badgeText,
    this.initiallyExpanded = false,
    this.leadingIcon,
    this.titleFontSize = 22,
    this.padding,
    this.showDivider = true,
    this.onExpansionChanged,
  });

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    if (_isExpanded) {
      _iconController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _iconController.forward();
      } else {
        _iconController.reverse();
      }
    });

    widget.onExpansionChanged?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final defaultPadding = widget.padding ??
        const EdgeInsets.symmetric(horizontal: 20, vertical: 24);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(
        top: defaultPadding.top,
        bottom: defaultPadding.bottom,
      ),
      decoration: widget.showDivider
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.greyLight.withOpacity(0.3),
                  width: 1,
                ),
              ),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with expand/collapse
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  // Optional leading icon
                  if (widget.leadingIcon != null) ...[
                    Icon(
                      widget.leadingIcon,
                      size: 24,
                      color: AppColors.berryCrush,
                    ),
                    const SizedBox(width: 12),
                  ],

                  // Title
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: widget.titleFontSize,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  // Badge (optional)
                  if (widget.badgeText != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.berryCrush.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.badgeText!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.berryCrush,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],

                  // Expand/collapse icon
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(
                      CurvedAnimation(
                        parent: _iconController,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 28,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _isExpanded
                ? Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: widget.child,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// Simple expandable item for list items (like FAQ questions)
///
/// A lighter version for individual expandable items within a section
class ExpandableListItem extends StatefulWidget {
  /// Question or item title
  final String title;

  /// Answer or item content
  final String content;

  /// Whether initially expanded (default: false)
  final bool initiallyExpanded;

  /// Title style customization
  final TextStyle? titleStyle;

  /// Content style customization
  final TextStyle? contentStyle;

  const ExpandableListItem({
    super.key,
    required this.title,
    required this.content,
    this.initiallyExpanded = false,
    this.titleStyle,
    this.contentStyle,
  });

  @override
  State<ExpandableListItem> createState() => _ExpandableListItemState();
}

class _ExpandableListItemState extends State<ExpandableListItem>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    if (_isExpanded) {
      _iconController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _iconController.forward();
      } else {
        _iconController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultTitleStyle = widget.titleStyle ??
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        );

    final defaultContentStyle = widget.contentStyle ??
        const TextStyle(
          fontSize: 15,
          color: AppColors.textSecondary,
          height: 1.5,
        );

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question/Title
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: defaultTitleStyle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(
                      CurvedAnimation(
                        parent: _iconController,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 24,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Answer/Content
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _isExpanded
                ? Padding(
                    padding: const EdgeInsets.only(top: 8, right: 36),
                    child: Text(
                      widget.content,
                      style: defaultContentStyle,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
