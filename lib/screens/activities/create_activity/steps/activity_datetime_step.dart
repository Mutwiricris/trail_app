import 'package:flutter/material.dart';
import 'package:zuritrails/models/activity_data.dart';
import 'package:zuritrails/utils/app_colors.dart';

/// Step 5: Choose date and time
class ActivityDateTimeStep extends StatefulWidget {
  final ActivityData activityData;
  final VoidCallback onNext;

  const ActivityDateTimeStep({
    super.key,
    required this.activityData,
    required this.onNext,
  });

  @override
  State<ActivityDateTimeStep> createState() => _ActivityDateTimeStepState();
}

class _ActivityDateTimeStepState extends State<ActivityDateTimeStep> {
  DateTime _selectedDate = DateTime.now();
  String _timeType = 'flexible'; // 'flexible' or 'specific'
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.activityData.date != null) {
      _selectedDate = widget.activityData.date!;
    }
    if (widget.activityData.timeType != null) {
      _timeType = widget.activityData.timeType!;
    }
  }

  List<DateTime> _getNextDays() {
    final List<DateTime> days = [];
    for (int i = 0; i < 7; i++) {
      days.add(DateTime.now().add(Duration(days: i)));
    }
    return days;
  }

  String _getDayLabel(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return 'Today';
    }
    return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7];
  }

  Future<void> _selectSpecificTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
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

    if (time != null) {
      setState(() {
        _selectedTime = time;
        _timeType = 'specific';
      });
    }
  }

  void _continue() {
    widget.activityData.date = _selectedDate;
    widget.activityData.timeType = _timeType;
    if (_selectedTime != null && _timeType == 'specific') {
      widget.activityData.specificTime =
          '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
    }
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final days = _getNextDays();

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
                      'When?',
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

            const SizedBox(height: 24),

            // Date selector
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final day = days[index];
                  final isSelected = day.day == _selectedDate.day &&
                      day.month == _selectedDate.month;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = day;
                      });
                    },
                    child: Container(
                      width: 70,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.berryCrush
                            : AppColors.greyLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getDayLabel(day),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            day.day.toString(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // Time type selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _timeType = 'flexible';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _timeType == 'flexible'
                              ? AppColors.berryCrush.withOpacity(0.1)
                              : AppColors.greyLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _timeType == 'flexible'
                                ? AppColors.berryCrush
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: _timeType == 'flexible'
                                  ? AppColors.berryCrush
                                  : AppColors.grey,
                              size: 32,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Flexible time',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: _timeType == 'flexible'
                                    ? AppColors.berryCrush
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Anytime during the day',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: _selectSpecificTime,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _timeType == 'specific'
                              ? AppColors.berryCrush.withOpacity(0.1)
                              : AppColors.greyLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _timeType == 'specific'
                                ? AppColors.berryCrush
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: _timeType == 'specific'
                                  ? AppColors.berryCrush
                                  : AppColors.grey,
                              size: 32,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Set specific time',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: _timeType == 'specific'
                                    ? AppColors.berryCrush
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedTime != null
                                  ? _selectedTime!.format(context)
                                  : 'Choose exact time',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Info text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Activity will be visible on map until midnight',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.grey.withOpacity(0.8),
                ),
              ),
            ),

            const Spacer(),

            // Next button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.berryCrush,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 20),
                    ],
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
