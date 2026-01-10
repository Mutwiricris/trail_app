import 'package:flutter/material.dart';
import 'dart:io';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/hidden_gem_data.dart';

class GemReviewScreen extends StatelessWidget {
  final HiddenGemData gemData;
  final VoidCallback onSubmit;
  final VoidCallback onBack;
  final Function(int) onEdit;

  const GemReviewScreen({
    super.key,
    required this.gemData,
    required this.onSubmit,
    required this.onBack,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: onBack,
        ),
        title: const Text(
          'Review & Submit',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Completion percentage
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: gemData.completionPercentage / 100,
                          backgroundColor: AppColors.greyLight,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            gemData.completionPercentage >= 80
                                ? AppColors.success
                                : gemData.completionPercentage >= 50
                                    ? AppColors.warning
                                    : AppColors.error,
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${gemData.completionPercentage.toInt()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      gemData.completionPercentage >= 80
                          ? Icons.check_circle
                          : Icons.info_outline,
                      size: 16,
                      color: gemData.completionPercentage >= 80
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        gemData.completionPercentage >= 80
                            ? 'Looks great! Ready to submit.'
                            : 'Add more details to improve your submission',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Images Section
                  _buildSection(
                    context,
                    title: 'Photos',
                    stepIndex: 0,
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: gemData.images.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(gemData.images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Location Section
                  _buildSection(
                    context,
                    title: 'Location',
                    stepIndex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          Icons.place,
                          'Name',
                          gemData.locationName ?? 'Not set',
                        ),
                        if (gemData.address != null) ...[
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.location_city,
                            'Address',
                            gemData.address!,
                          ),
                        ],
                        if (gemData.city != null) ...[
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.location_on_outlined,
                            'City',
                            gemData.city!,
                          ),
                        ],
                        if (gemData.location != null) ...[
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.gps_fixed,
                            'Coordinates',
                            '${gemData.location!.latitude.toStringAsFixed(4)}, '
                                '${gemData.location!.longitude.toStringAsFixed(4)}',
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Details Section
                  _buildSection(
                    context,
                    title: 'Details',
                    stepIndex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gemData.name ?? 'Untitled',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          gemData.description ?? 'No description',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (gemData.category != null)
                          _buildInfoRow(
                            Icons.category,
                            'Category',
                            gemData.category!,
                          ),
                        if (gemData.difficulty != null) ...[
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.terrain,
                            'Difficulty',
                            gemData.difficulty!,
                          ),
                        ],
                        if (gemData.bestTimeToVisit != null) ...[
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.wb_sunny,
                            'Best Time',
                            gemData.bestTimeToVisit!,
                          ),
                        ],
                        if (gemData.entryFee != null) ...[
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.payments,
                            'Entry Fee',
                            'KES ${gemData.entryFee!.toStringAsFixed(0)}',
                          ),
                        ],
                        if (gemData.tags != null && gemData.tags!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: gemData.tags!.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.berryCrush.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  tag,
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Bottom Action Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!gemData.isValid)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.warning.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber,
                              color: AppColors.warning,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Please complete all required sections to submit',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: gemData.isValid ? onSubmit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      disabledBackgroundColor: AppColors.greyLight,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_circle, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Submit Hidden Gem',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required int stepIndex,
    required Widget child,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: () => onEdit(stepIndex),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.berryCrush,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.berryCrush,
        ),
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
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
