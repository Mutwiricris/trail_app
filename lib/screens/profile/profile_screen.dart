import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with Cover Photo
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Cover Photo
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.berryCrush,
                          AppColors.berryCrushLight,
                        ],
                      ),
                    ),
                  ),

                  // Settings Icon
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.settings, color: AppColors.white),
                    ),
                  ),

                  // Profile Photo
                  Positioned(
                    left: 20,
                    bottom: -40,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.white,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.beige,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.berryCrush,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Profile Info
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Safari Explorer',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'explorer@zuritrails.com',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text('Edit Profile'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Stats
                    Row(
                      children: [
                        Expanded(child: _buildStatCard('12', 'Trips', Icons.luggage)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard('8', 'Parks', Icons.park)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard('25', 'Badges', Icons.emoji_events)),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Achievements Section
                    _buildSectionHeader('Achievements'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildBadge(Icons.stars, 'Explorer', AppColors.warning),
                        const SizedBox(width: 12),
                        _buildBadge(Icons.camera_alt, 'Photographer', AppColors.info),
                        const SizedBox(width: 12),
                        _buildBadge(Icons.favorite, 'Adventurer', AppColors.berryCrush),
                        const SizedBox(width: 12),
                        _buildBadge(Icons.add, 'More', AppColors.greyLight),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Menu Items
                    _buildSectionHeader('Account'),
                    const SizedBox(height: 12),
                    _buildMenuItem(Icons.person_outline, 'Personal Information', () {}),
                    _buildMenuItem(Icons.payment, 'Payment Methods', () {}),
                    _buildMenuItem(Icons.notifications_outlined, 'Notifications', () {}),
                    _buildMenuItem(Icons.security, 'Privacy & Security', () {}),

                    const SizedBox(height: 24),
                    _buildSectionHeader('Support'),
                    const SizedBox(height: 12),
                    _buildMenuItem(Icons.help_outline, 'Help Center', () {}),
                    _buildMenuItem(Icons.description_outlined, 'Terms & Conditions', () {}),
                    _buildMenuItem(Icons.info_outline, 'About ZuriTrails', () {}),

                    const SizedBox(height: 24),
                    _buildMenuItem(
                      Icons.logout,
                      'Log Out',
                      () {},
                      color: AppColors.error,
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.beige.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.berryCrush, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap,
      {Color? color}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: color ?? AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: color ?? AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
