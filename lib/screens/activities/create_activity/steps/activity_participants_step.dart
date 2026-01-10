import 'package:flutter/material.dart';
import 'package:zuritrails/models/activity_data.dart';
import 'package:zuritrails/utils/app_colors.dart';

/// Step 6: Who can join settings
class ActivityParticipantsStep extends StatefulWidget {
  final ActivityData activityData;
  final VoidCallback onComplete;

  const ActivityParticipantsStep({
    super.key,
    required this.activityData,
    required this.onComplete,
  });

  @override
  State<ActivityParticipantsStep> createState() =>
      _ActivityParticipantsStepState();
}

class _ActivityParticipantsStepState extends State<ActivityParticipantsStep> {
  late int _minAge;
  late int _maxAge;
  late String _privacy;

  @override
  void initState() {
    super.initState();
    _minAge = widget.activityData.minAge;
    _maxAge = widget.activityData.maxAge;
    _privacy = widget.activityData.privacy;
  }

  void _incrementMinAge() {
    if (_minAge < _maxAge - 1) {
      setState(() {
        _minAge++;
      });
    }
  }

  void _decrementMinAge() {
    if (_minAge > 18) {
      setState(() {
        _minAge--;
      });
    }
  }

  void _incrementMaxAge() {
    if (_maxAge < 99) {
      setState(() {
        _maxAge++;
      });
    }
  }

  void _decrementMaxAge() {
    if (_maxAge > _minAge + 1) {
      setState(() {
        _maxAge--;
      });
    }
  }

  void _addToMap() {
    widget.activityData.minAge = _minAge;
    widget.activityData.maxAge = _maxAge;
    widget.activityData.privacy = _privacy;
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header with drag handle
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Close button and title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.black),
                  ),
                  const Expanded(
                    child: Text(
                      'Who can join?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: AppColors.black),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Age range section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.cake_outlined,
                          color: AppColors.textSecondary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Age range',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        // Min Age
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Min Age',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: _decrementMinAge,
                                    icon: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        color: AppColors.textSecondary,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _minAge.toString(),
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: _incrementMinAge,
                                    icon: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.berryCrush,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: AppColors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Max Age
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Max Age',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: _decrementMaxAge,
                                    icon: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        color: AppColors.textSecondary,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _maxAge.toString(),
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: _incrementMaxAge,
                                    icon: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.berryCrush,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: AppColors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Privacy section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _privacy = 'open';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _privacy == 'open'
                              ? AppColors.berryCrush.withOpacity(0.1)
                              : AppColors.greyLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _privacy == 'open'
                                ? AppColors.berryCrush
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.group,
                              color: _privacy == 'open'
                                  ? AppColors.berryCrush
                                  : AppColors.grey,
                              size: 32,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Open',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _privacy == 'open'
                                    ? AppColors.berryCrush
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Anyone can join',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _privacy = 'private';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _privacy == 'private'
                              ? AppColors.berryCrush.withOpacity(0.1)
                              : AppColors.greyLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _privacy == 'private'
                                ? AppColors.berryCrush
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              color: _privacy == 'private'
                                  ? AppColors.berryCrush
                                  : AppColors.grey,
                              size: 32,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Private',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _privacy == 'private'
                                    ? AppColors.berryCrush
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Approval required',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Add to Map button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _addToMap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.berryCrush,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Add to Map!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
