import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zuritrails/models/trip.dart';
import 'package:zuritrails/services/trip_service.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/utils/app_spacing.dart';

/// Create trip dialog - quick trip creation
///
/// Allows users to create a new trip with:
/// - Trip name
/// - Trip type (Personal / Booked)
/// - Date range (optional)
/// - Description (optional)
class CreateTripDialog extends StatefulWidget {
  const CreateTripDialog({super.key});

  @override
  State<CreateTripDialog> createState() => _CreateTripDialogState();
}

class _CreateTripDialogState extends State<CreateTripDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  TripType _tripType = TripType.personal;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.berryCrush.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      child: const Icon(
                        Icons.add_location_alt,
                        color: AppColors.berryCrush,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const Expanded(
                      child: Text(
                        'Create New Trip',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // Trip Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Trip Name',
                    hintText: 'e.g., Maasai Mara Adventure',
                    prefixIcon: const Icon(Icons.tour),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a trip name';
                    }
                    return null;
                  },
                  textCapitalization: TextCapitalization.words,
                ),

                const SizedBox(height: AppSpacing.md),

                // Trip Type
                const Text(
                  'Trip Type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _buildTypeOption(
                        type: TripType.personal,
                        icon: Icons.person,
                        label: 'Personal',
                        description: 'Custom itinerary',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _buildTypeOption(
                        type: TripType.booked,
                        icon: Icons.business,
                        label: 'Booked',
                        description: 'Tour package',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Date Range (Optional)
                const Text(
                  'Dates (Optional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        label: 'Start Date',
                        date: _startDate,
                        onTap: () => _selectDate(isStartDate: true),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _buildDateField(
                        label: 'End Date',
                        date: _endDate,
                        onTap: () => _selectDate(isStartDate: false),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Description (Optional)
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Add notes about your trip...',
                    prefixIcon: const Icon(Icons.notes),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                ),

                const SizedBox(height: AppSpacing.lg),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.medium),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleCreate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.berryCrush,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.medium),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(AppColors.white),
                                ),
                              )
                            : const Text('Create Trip'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeOption({
    required TripType type,
    required IconData icon,
    required String label,
    required String description,
  }) {
    final isSelected = _tripType == type;

    return GestureDetector(
      onTap: () => setState(() => _tripType = type),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.berryCrush.withValues(alpha: 0.1)
              : AppColors.beige.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(
            color: isSelected
                ? AppColors.berryCrush
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.berryCrush
                  : AppColors.textSecondary,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.berryCrush
                    : AppColors.textPrimary,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: AppColors.greyLight),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                date == null
                    ? label
                    : '${date.day}/${date.month}/${date.year}',
                style: TextStyle(
                  fontSize: 14,
                  color: date == null
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate({required bool isStartDate}) async {
    final now = DateTime.now();
    final initialDate = isStartDate
        ? (_startDate ?? now)
        : (_endDate ?? _startDate ?? now);

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.berryCrush,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        if (isStartDate) {
          _startDate = date;
          // If end date is before start date, clear it
          if (_endDate != null && _endDate!.isBefore(date)) {
            _endDate = null;
          }
        } else {
          _endDate = date;
        }
      });
    }
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final tripService = context.read<TripService>();

      final trip = await tripService.createTrip(
        title: _nameController.text.trim(),
        type: _tripType,
        userId: 'current_user', // TODO: Get from auth service
        startDate: _startDate,
        endDate: _endDate,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );

      if (mounted) {
        // Return trip info to caller
        Navigator.pop(context, {
          'tripId': trip.id,
          'tripTitle': trip.title,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Created trip: ${trip.title}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating trip: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
