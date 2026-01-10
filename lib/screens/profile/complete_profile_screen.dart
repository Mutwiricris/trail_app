import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/user_profile.dart';
import 'package:intl/intl.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Comprehensive mock user profile
    final profile = UserProfile(
      id: '1',
      name: 'Chris Mutwiri',
      firstName: 'Chris',
      lastName: 'Mutwiri',
      email: 'chris.mutwiri@zuritrails.com',
      phoneNumber: '+254 712 345 678',
      photoUrl: 'https://i.pravatar.cc/300?img=12',
      bio:
          '🌍 Adventure seeker | 📸 Wildlife photographer | 🏔️ Mountain climber\n\nExploring Kenya\'s hidden treasures one trail at a time. Love meeting fellow travelers and sharing epic experiences!',
      joinedDate: DateTime(2023, 6, 15),
      level: ExplorerLevel.trailblazer,
      currentXP: 2150,
      streakDays: 23,
      // Personal Information
      dateOfBirth: DateTime(1995, 5, 15),
      gender: 'Male',
      nationality: 'Kenyan',
      idNumber: '12345678',
      passportNumber: 'A12345678',
      // Address
      address: '123 Kenyatta Avenue, Westlands',
      city: 'Nairobi',
      country: 'Kenya',
      postalCode: '00100',
      // Preferences
      interests: [
        'Wildlife Safari',
        'Photography',
        'Hiking',
        'Cultural Tours',
        'Beach Activities',
        'Mountain Climbing',
      ],
      languages: ['English', 'Swahili', 'French'],
      preferredCurrency: 'KES',
      emailNotifications: true,
      smsNotifications: true,
      pushNotifications: true,
      // Emergency Contact
      emergencyContactName: 'Jane Mutwiri',
      emergencyContactPhone: '+254 722 123 456',
      emergencyContactRelation: 'Sister',
      // Travel Preferences
      travelStyle: 'Adventure & Luxury',
      dietaryRestrictions: ['None'],
      accessibility: [],
      travelInsurance: true,
      // Stats
      totalTripsCount: 28,
      completedTripsCount: 25,
      totalVisitsCount: 87,
      visitedGemIds: List.generate(45, (i) => 'gem$i'),
      savedGemIds: List.generate(23, (i) => 'saved_gem$i'),
      visitedSafariIds: List.generate(12, (i) => 'safari$i'),
      savedSafariIds: List.generate(8, (i) => 'saved_safari$i'),
      completedRouteIds: List.generate(15, (i) => 'route$i'),
      savedRouteIds: List.generate(10, (i) => 'saved_route$i'),
      unlockedBadges: [
        'first_journey',
        'explorer',
        'photographer',
        'sunrise_hunter',
        'gem_finder',
        'safari_expert',
        'peak_conqueror',
        'culture_enthusiast',
      ],
      // Settings
      isProfilePublic: true,
      shareLocationWithFriends: true,
      lastActive: DateTime.now(),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 320,
              pinned: true,
              floating: false,
              backgroundColor: AppColors.berryCrush,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildProfileHeader(profile),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.share, color: AppColors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Share profile')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit profile')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: AppColors.white),
                  onPressed: () {},
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  color: AppColors.white,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: AppColors.berryCrush,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.berryCrush,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Activities'),
                      Tab(text: 'Bookings'),
                      Tab(text: 'Achievements'),
                      Tab(text: 'Info'),
                      Tab(text: 'Settings'),
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
            _buildOverviewTab(profile),
            _buildActivitiesTab(profile),
            _buildBookingsTab(profile),
            _buildAchievementsTab(profile),
            _buildInfoTab(profile),
            _buildSettingsTab(profile),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserProfile profile) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Cover gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.berryCrush, AppColors.berryCrushLight],
            ),
          ),
        ),
        // Pattern overlay
        Positioned.fill(
          child: Opacity(
            opacity: 0.1,
            child: Image.network(
              'https://images.unsplash.com/photo-1523805009345-7448845a9e53?w=1200',
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Profile content
        Positioned(
          bottom: 70,
          left: 0,
          right: 0,
          child: Column(
            children: [
              // Profile photo
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: profile.photoUrl != null
                      ? NetworkImage(profile.photoUrl!)
                      : null,
                  backgroundColor: AppColors.white,
                ),
              ),
              const SizedBox(height: 16),
              // Name
              Text(
                profile.fullName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  shadows: [
                    Shadow(
                      color: AppColors.black.withOpacity(0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Level badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(profile.level.icon, style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text(
                      profile.level.displayName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.berryCrush,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.berryCrush.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${profile.currentXP} XP',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.berryCrush,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // OVERVIEW TAB
  Widget _buildOverviewTab(UserProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile completion
          _buildCompletionCard(profile),
          const SizedBox(height: 20),

          // Quick stats
          _buildQuickStats(profile),
          const SizedBox(height: 20),

          // Bio
          if (profile.bio != null) ...[
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Me',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile.bio!,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Member since
          _buildCard(
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.berryCrush,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Member Since',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      DateFormat('MMMM d, yyyy').format(profile.joinedDate),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color: AppColors.warning,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${profile.streakDays} day streak',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Interests
          if (profile.interests != null && profile.interests!.isNotEmpty) ...[
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Travel Interests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: profile.interests!.map((interest) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.berryCrush.withOpacity(0.1),
                              AppColors.berryCrushLight.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.berryCrush.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          interest,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.berryCrush,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Recent badges
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Badges',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _tabController.animateTo(3);
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: profile.unlockedBadges.length.clamp(0, 5),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 70,
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.warning.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.emoji_events,
                                color: AppColors.warning,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.unlockedBadges[index].replaceAll(
                                '_',
                                ' ',
                              ),
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ACTIVITIES TAB
  Widget _buildActivitiesTab(UserProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Activity stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.explore,
                  label: 'Total Trips',
                  value: '${profile.totalTripsCount}',
                  color: AppColors.berryCrush,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle,
                  label: 'Completed',
                  value: '${profile.completedTripsCount}',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Places visited
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Places Visited',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.berryCrush,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${profile.visitedGemIds.length}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildActivityItem(
                  Icons.diamond,
                  'Hidden Gems',
                  '${profile.visitedGemIds.length} visited',
                  AppColors.warning,
                ),
                _buildActivityItem(
                  Icons.tour,
                  'Safari Tours',
                  '${profile.visitedSafariIds.length} completed',
                  AppColors.success,
                ),
                _buildActivityItem(
                  Icons.route,
                  'Routes',
                  '${profile.completedRouteIds.length} finished',
                  AppColors.info,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Saved for later
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saved for Later',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildActivityItem(
                  Icons.bookmark,
                  'Saved Gems',
                  '${profile.savedGemIds.length} places',
                  AppColors.berryCrush,
                ),
                _buildActivityItem(
                  Icons.bookmark_border,
                  'Saved Tours',
                  '${profile.savedSafariIds.length} tours',
                  AppColors.berryCrush,
                ),
                _buildActivityItem(
                  Icons.map,
                  'Saved Routes',
                  '${profile.savedRouteIds.length} routes',
                  AppColors.berryCrush,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // BOOKINGS TAB
  Widget _buildBookingsTab(UserProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildCard(
            child: Column(
              children: [
                Text(
                  'My Bookings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                _buildBookingCard(
                  'Maasai Mara Safari',
                  'Aug 15-18, 2024',
                  'Confirmed',
                  AppColors.success,
                  'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=200',
                ),
                const SizedBox(height: 12),
                _buildBookingCard(
                  'Diani Beach Resort',
                  'Sep 1-5, 2024',
                  'Confirmed',
                  AppColors.success,
                  'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=200',
                ),
                const SizedBox(height: 12),
                _buildBookingCard(
                  'Mt. Kenya Hiking Tour',
                  'Oct 10-12, 2024',
                  'Pending',
                  AppColors.warning,
                  'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ACHIEVEMENTS TAB
  Widget _buildAchievementsTab(UserProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Progress to next level
          _buildCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Level Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${profile.xpToNextLevel} XP to ${ExplorerLevel.values[profile.level.index + 1 < ExplorerLevel.values.length ? profile.level.index + 1 : profile.level.index].displayName}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: profile.levelProgress,
                    backgroundColor: AppColors.greyLight,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.berryCrush,
                    ),
                    minHeight: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Badges grid
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unlocked Badges (${profile.unlockedBadges.length})',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: profile.unlockedBadges.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.warning,
                                AppColors.warning.withOpacity(0.7),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.warning.withOpacity(0.3),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.emoji_events,
                            color: AppColors.white,
                            size: 36,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.unlockedBadges[index].replaceAll('_', ' '),
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // INFO TAB
  Widget _buildInfoTab(UserProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Personal info
          _buildInfoSection('Personal Information', [
            _buildInfoRow(Icons.email, 'Email', profile.email ?? 'Not set'),
            _buildInfoRow(
              Icons.phone,
              'Phone',
              profile.phoneNumber ?? 'Not set',
            ),
            if (profile.dateOfBirth != null)
              _buildInfoRow(
                Icons.cake,
                'Birthday',
                '${DateFormat('MMM d, yyyy').format(profile.dateOfBirth!)} (${profile.age} years)',
              ),
            if (profile.gender != null)
              _buildInfoRow(Icons.person, 'Gender', profile.gender!),
            if (profile.nationality != null)
              _buildInfoRow(Icons.flag, 'Nationality', profile.nationality!),
            if (profile.idNumber != null)
              _buildInfoRow(Icons.badge, 'ID Number', profile.idNumber!),
            if (profile.passportNumber != null)
              _buildInfoRow(
                Icons.card_travel,
                'Passport',
                profile.passportNumber!,
              ),
          ]),
          const SizedBox(height: 16),

          // Address
          if (profile.address != null) ...[
            _buildInfoSection('Address', [
              if (profile.address != null)
                _buildInfoRow(Icons.home, 'Street', profile.address!),
              if (profile.city != null)
                _buildInfoRow(Icons.location_city, 'City', profile.city!),
              if (profile.country != null)
                _buildInfoRow(Icons.public, 'Country', profile.country!),
              if (profile.postalCode != null)
                _buildInfoRow(
                  Icons.markunread_mailbox,
                  'Postal Code',
                  profile.postalCode!,
                ),
            ]),
            const SizedBox(height: 16),
          ],

          // Emergency contact
          if (profile.emergencyContactName != null) ...[
            _buildInfoSection('Emergency Contact', [
              _buildInfoRow(
                Icons.person_outline,
                'Name',
                profile.emergencyContactName!,
              ),
              if (profile.emergencyContactPhone != null)
                _buildInfoRow(
                  Icons.phone,
                  'Phone',
                  profile.emergencyContactPhone!,
                ),
              if (profile.emergencyContactRelation != null)
                _buildInfoRow(
                  Icons.family_restroom,
                  'Relation',
                  profile.emergencyContactRelation!,
                ),
            ]),
            const SizedBox(height: 16),
          ],

          // Travel preferences
          _buildInfoSection('Travel Preferences', [
            if (profile.travelStyle != null)
              _buildInfoRow(Icons.explore, 'Style', profile.travelStyle!),
            if (profile.languages != null && profile.languages!.isNotEmpty)
              _buildInfoRow(
                Icons.language,
                'Languages',
                profile.languages!.join(', '),
              ),
            if (profile.preferredCurrency != null)
              _buildInfoRow(
                Icons.attach_money,
                'Currency',
                profile.preferredCurrency!,
              ),
            if (profile.travelInsurance != null)
              _buildInfoRow(
                Icons.verified_user,
                'Insurance',
                profile.travelInsurance! ? 'Active' : 'None',
              ),
          ]),
        ],
      ),
    );
  }

  // SETTINGS TAB
  Widget _buildSettingsTab(UserProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSwitchRow(
                  'Email Notifications',
                  profile.emailNotifications ?? false,
                  Icons.email,
                ),
                _buildSwitchRow(
                  'SMS Notifications',
                  profile.smsNotifications ?? false,
                  Icons.sms,
                ),
                _buildSwitchRow(
                  'Push Notifications',
                  profile.pushNotifications ?? false,
                  Icons.notifications,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSwitchRow(
                  'Public Profile',
                  profile.isProfilePublic ?? true,
                  Icons.public,
                ),
                _buildSwitchRow(
                  'Share Location',
                  profile.shareLocationWithFriends ?? false,
                  Icons.location_on,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildCard(
            child: Column(
              children: [
                _buildSettingButton(
                  Icons.lock,
                  'Change Password',
                  AppColors.info,
                ),
                _buildSettingButton(
                  Icons.payment,
                  'Payment Methods',
                  AppColors.success,
                ),
                _buildSettingButton(
                  Icons.help,
                  'Help & Support',
                  AppColors.warning,
                ),
                _buildSettingButton(Icons.logout, 'Logout', AppColors.error),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widgets
  Widget _buildCompletionCard(UserProfile profile) {
    final percentage = profile.profileCompletionPercentage;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.berryCrush.withOpacity(0.15),
            AppColors.berryCrushLight.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.berryCrush.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile Completion',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.berryCrush,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppColors.greyLight,
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage >= 80
                    ? AppColors.success
                    : percentage >= 50
                    ? AppColors.warning
                    : AppColors.berryCrush,
              ),
              minHeight: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(UserProfile profile) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.place,
            label: 'Places',
            value: '${profile.visitedGemIds.length}',
            color: AppColors.berryCrush,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.tour,
            label: 'Trips',
            value: '${profile.totalTripsCount}',
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.emoji_events,
            label: 'Badges',
            value: '${profile.unlockedBadges.length}',
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildActivityItem(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildBookingCard(
    String title,
    String date,
    String status,
    Color statusColor,
    String imageUrl,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> items) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.berryCrush),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.berryCrush),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
            ),
          ),
          Switch(
            value: value,
            onChanged: null,
            activeColor: AppColors.berryCrush,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingButton(IconData icon, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
