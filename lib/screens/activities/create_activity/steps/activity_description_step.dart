import 'package:flutter/material.dart';
import 'package:zuritrails/models/activity_data.dart';
import 'package:zuritrails/utils/app_colors.dart';

/// Step 3: Describe what you want to do
class ActivityDescriptionStep extends StatefulWidget {
  final ActivityData activityData;
  final VoidCallback onNext;

  const ActivityDescriptionStep({
    super.key,
    required this.activityData,
    required this.onNext,
  });

  @override
  State<ActivityDescriptionStep> createState() =>
      _ActivityDescriptionStepState();
}

class _ActivityDescriptionStepState extends State<ActivityDescriptionStep> {
  final TextEditingController _controller = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    if (widget.activityData.description != null) {
      _controller.text = widget.activityData.description!;
      _isValid = _controller.text.isNotEmpty;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    setState(() {
      _isValid = value.trim().isNotEmpty;
    });
    widget.activityData.description = value.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
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

              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: AppColors.black),
                ),
              ),

              const SizedBox(height: 32),

              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.berryCrush.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '✨',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Title
              const Text(
                'I want to...',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 24),

              // Text input
              TextField(
                controller: _controller,
                onChanged: _onTextChanged,
                maxLines: 3,
                autofocus: true,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'grab coffee, hang out at the park, etc.',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey.withOpacity(0.6),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.berryCrush,
                      width: 2,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.berryCrush,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Next button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isValid ? widget.onNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.berryCrush,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.grey.withOpacity(0.3),
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

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
