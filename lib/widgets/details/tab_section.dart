import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';

/// Tabbed content section for organizing information
///
/// Features:
/// - Based on TripsScreen tab pattern
/// - Rounded tab indicator with shadow
/// - Clean white background tabs on beige base
/// - Support 2-4 tabs
/// - Smooth tab switching
class TabSection extends StatefulWidget {
  /// List of tab titles
  final List<String> tabs;

  /// List of tab content widgets (must match tabs length)
  final List<Widget> children;

  /// Initial tab index (default: 0)
  final int initialIndex;

  /// Optional callback when tab changes
  final ValueChanged<int>? onTabChanged;

  /// Whether to show in a card container (default: false)
  final bool inCard;

  /// Optional padding around the entire widget
  final EdgeInsets? padding;

  const TabSection({
    super.key,
    required this.tabs,
    required this.children,
    this.initialIndex = 0,
    this.onTabChanged,
    this.inCard = false,
    this.padding,
  }) : assert(tabs.length == children.length,
            'tabs and children must have the same length');

  @override
  State<TabSection> createState() => _TabSectionState();
}

class _TabSectionState extends State<TabSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.onTabChanged?.call(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab Bar
        Container(
          decoration: BoxDecoration(
            color: AppColors.beige.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: AppColors.berryCrush,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            tabs: widget.tabs
                .map((tab) => Tab(
                      text: tab,
                    ))
                .toList(),
          ),
        ),

        const SizedBox(height: 24),

        // Tab Content with intrinsic height
        IntrinsicHeight(
          child: SizedBox(
            width: double.infinity,
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: widget.children.map((child) {
                return SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: child,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );

    if (widget.inCard) {
      return Container(
        padding: widget.padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: content,
      );
    }

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: content,
    );
  }
}

/// Tab section with fixed height content
///
/// Use this when you know the height of the tab content and want to avoid
/// expansion issues
class FixedHeightTabSection extends StatefulWidget {
  /// List of tab titles
  final List<String> tabs;

  /// List of tab content widgets (must match tabs length)
  final List<Widget> children;

  /// Content height
  final double contentHeight;

  /// Initial tab index (default: 0)
  final int initialIndex;

  /// Optional callback when tab changes
  final ValueChanged<int>? onTabChanged;

  /// Whether to show in a card container (default: false)
  final bool inCard;

  /// Optional padding around the entire widget
  final EdgeInsets? padding;

  const FixedHeightTabSection({
    super.key,
    required this.tabs,
    required this.children,
    required this.contentHeight,
    this.initialIndex = 0,
    this.onTabChanged,
    this.inCard = false,
    this.padding,
  }) : assert(tabs.length == children.length,
            'tabs and children must have the same length');

  @override
  State<FixedHeightTabSection> createState() => _FixedHeightTabSectionState();
}

class _FixedHeightTabSectionState extends State<FixedHeightTabSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.onTabChanged?.call(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tab Bar
        Container(
          decoration: BoxDecoration(
            color: AppColors.beige.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: AppColors.berryCrush,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            tabs: widget.tabs
                .map((tab) => Tab(
                      text: tab,
                    ))
                .toList(),
          ),
        ),

        const SizedBox(height: 24),

        // Tab Content with fixed height
        SizedBox(
          height: widget.contentHeight,
          child: TabBarView(
            controller: _tabController,
            children: widget.children,
          ),
        ),
      ],
    );

    if (widget.inCard) {
      return Container(
        padding: widget.padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: content,
      );
    }

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: content,
    );
  }
}

/// Simple tab data class
class TabData {
  final String title;
  final Widget content;
  final IconData? icon;

  const TabData({
    required this.title,
    required this.content,
    this.icon,
  });
}
