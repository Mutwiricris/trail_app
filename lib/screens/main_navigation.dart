import 'package:flutter/material.dart';
import 'package:zuritrails/screens/home/home_screen_redesigned.dart';
import 'package:zuritrails/screens/discover/comprehensive_browse_screen.dart';
import 'package:zuritrails/screens/explore/map_explore_screen.dart';
import 'package:zuritrails/screens/trips/trips_screen.dart';
import 'package:zuritrails/screens/profile/complete_profile_screen.dart';
import 'package:zuritrails/widgets/navigation/main_bottom_nav.dart';

class MainNavigation extends StatefulWidget {
  final Widget? child;
  final int initialIndex;

  const MainNavigation({
    super.key,
    this.child,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = const [
    HomeScreenRedesigned(),
    ComprehensiveBrowseScreen(initialTab: 0),
    MapExploreScreen(),
    TripsScreen(),
    CompleteProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
