import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/user_profile.dart';
import 'package:intl/intl.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock user profile with comprehensive signup data
    final profile = UserProfile(
      id: '1',
      name: 'Chris Mutwiri',
      firstName: 'Chris',
      lastName: 'Mutwiri',
      email: 'chris.mutwiri@example.com',
      phoneNumber: '+254 712 345 678',
      photoUrl: 'https://i.pravatar.cc/300?img=12',
      bio: 'Adventure seeker and nature enthusiast. Love exploring hidden gems across Kenya!',
      joinedDate: DateTime.now().subtract(const Duration(days: 180)),
      level: ExplorerLevel.pathfinder,
      currentXP: 750,
      streakDays: 15,
      // Personal Information
      dateOfBirth: DateTime(1995, 5, 15),
      gender: 'Male',
      nationality: 'Kenyan',
      idNumber: '12345678',
      // Address
      address: '123 Kenyatta Avenue',
      city: 'Nairobi',
      country: 'Kenya',
      postalCode: '00100',
      // Preferences
      interests: ['Wildlife', 'Photography', 'Hiking', 'Cultural Tours'],
      languages: ['English', 'Swahili'],
      preferredCurrency: 'KES',
      emailNotifications: true,
      smsNotifications: false,
      pushNotifications: true,
      // Emergency Contact
      emergencyContactName: 'Jane Mutwiri',
      emergencyContactPhone: '+254 722 123 456',
      emergencyContactRelation: 'Sister',
      // Travel Preferences
      travelStyle: 'Adventure',
      dietaryRestrictions: ['None'],
      accessibility: [],
      travelInsurance: true,
      // Stats
      totalTripsCount: 12,
      completedTripsCount: 10,
      totalVisitsCount: 45,
      visitedGemIds: ['gem1', 'gem2', 'gem3'],
      unlockedBadges: ['first_journey', 'explorer', 'photographer'],
      // Settings
      isProfilePublic: true,
      shareLocationWithFriends: true,
      lastActive: DateTime.now(),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Cover Photo
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.berryCrush,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Cover Image
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.berryCrush,
                          AppColors.berryCrushLight,
                        ],
                      ),
                    ),
                  ),
                  // Profile Info
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: [
                        // Profile Photo
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: profile.photoUrl != null
                                ? NetworkImage(profile.photoUrl!)
                                : null,
                            backgroundColor: AppColors.white,
                            child: profile.photoUrl == null
                                ? Text(
                                    profile.name[0].toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.berryCrush,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Name and Level
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.fullName,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    profile.level.icon,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    profile.level.displayName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.white),
                onPressed: () {
                  // TODO: Navigate to edit profile
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit profile feature coming soon!'),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: AppColors.white),
                onPressed: () {
                  // TODO: Navigate to settings
                },
              ),
            ],
          ),

          // Profile Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Completion Card
                  _buildCompletionCard(profile),
                  const SizedBox(height: 20),

                  // Bio
                  if (profile.bio != null) ...[
                    _buildSectionCard(
                      title: 'About',
                      child: Text(
                        profile.bio!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Stats
                  _buildStatsCard(profile),
                  const SizedBox(height: 16),

                  // Personal Information
                  _buildSectionCard(
                    title: 'Personal Information',
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.email, 'Email', profile.email ?? 'Not set'),
                        _buildInfoRow(Icons.phone, 'Phone', profile.phoneNumber ?? 'Not set'),
                        if (profile.dateOfBirth != null)
                          _buildInfoRow(
                            Icons.cake,
                            'Date of Birth',
                            '${DateFormat('MMMM d, yyyy').format(profile.dateOfBirth!)} (${profile.age} years old)',
                          ),
                        if (profile.gender != null)
                          _buildInfoRow(Icons.person, 'Gender', profile.gender!),
                        if (profile.nationality != null)
                          _buildInfoRow(Icons.flag, 'Nationality', profile.nationality!),
                        if (profile.idNumber != null)
                          _buildInfoRow(Icons.badge, 'ID Number', profile.idNumber!),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Address Information
                  if (profile.address != null || profile.city != null) ...[
                    _buildSectionCard(
                      title: 'Address',
                      child: Column(
                        children: [
                          if (profile.address != null)
                            _buildInfoRow(Icons.home, 'Street Address', profile.address!),
                          if (profile.city != null)
                            _buildInfoRow(Icons.location_city, 'City', profile.city!),
                          if (profile.country != null)
                            _buildInfoRow(Icons.public, 'Country', profile.country!),
                          if (profile.postalCode != null)
                            _buildInfoRow(Icons.mail, 'Postal Code', profile.postalCode!),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Travel Preferences
                  _buildSectionCard(
                    title: 'Travel Preferences',
                    child: Column(
                      children: [
                        if (profile.travelStyle != null)
                          _buildInfoRow(Icons.explore, 'Travel Style', profile.travelStyle!),
                        if (profile.interests != null && profile.interests!.isNotEmpty)
                          _buildChipsRow(Icons.favorite, 'Interests', profile.interests!),
                        if (profile.languages != null && profile.languages!.isNotEmpty)
                          _buildChipsRow(Icons.language, 'Languages', profile.languages!),
                        if (profile.preferredCurrency != null)
                          _buildInfoRow(Icons.attach_money, 'Preferred Currency', profile.preferredCurrency!),
                        if (profile.travelInsurance != null)
                          _buildInfoRow(
                            Icons.verified_user,
                            'Travel Insurance',
                            profile.travelInsurance! ? 'Yes' : 'No',
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Emergency Contact
                  if (profile.emergencyContactName != null) ...[
                    _buildSectionCard(
                      title: 'Emergency Contact',
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.person_outline, 'Name', profile.emergencyContactName!),
                          if (profile.emergencyContactPhone != null)
                            _buildInfoRow(Icons.phone, 'Phone', profile.emergencyContactPhone!),
                          if (profile.emergencyContactRelation != null)
                            _buildInfoRow(Icons.family_restroom, 'Relation', profile.emergencyContactRelation!),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Notification Settings
                  _buildSectionCard(
                    title: 'Notifications',
                    child: Column(
                      children: [
                        _buildSwitchRow('Email Notifications', profile.emailNotifications ?? false),
                        _buildSwitchRow('SMS Notifications', profile.smsNotifications ?? false),
                        _buildSwitchRow('Push Notifications', profile.pushNotifications ?? false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Privacy Settings
                  _buildSectionCard(
                    title: 'Privacy',
                    child: Column(
                      children: [
                        _buildSwitchRow('Public Profile', profile.isProfilePublic ?? true),
                        _buildSwitchRow('Share Location with Friends', profile.shareLocationWithFriends ?? false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionCard(UserProfile profile) {
    final percentage = profile.profileCompletionPercentage;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.berryCrush.withOpacity(0.1),
            AppColors.berryCrushLight.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.berryCrush.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile Completion',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.berryCrush,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
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
              minHeight: 8,
            ),
          ),
          if (percentage < 100) ...[
            const SizedBox(height: 8),
            Text(
              'Complete your profile to unlock more features!',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsCard(UserProfile profile) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.explore, 'Trips', '${profile.totalTripsCount}'),
          Container(width: 1, height: 40, color: AppColors.greyLight),
          _buildStatItem(Icons.place, 'Places', '${profile.visitedGemIds.length}'),
          Container(width: 1, height: 40, color: AppColors.greyLight),
          _buildStatItem(Icons.emoji_events, 'Badges', '${profile.unlockedBadges.length}'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.berryCrush, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget _buildChipsRow(IconData icon, String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.berryCrush),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.berryCrush.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.berryCrush,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          Switch(
            value: value,
            onChanged: null, // Read-only for now
            activeColor: AppColors.berryCrush,
          ),
        ],
      ),
    );
  }
}
