import 'package:flutter/material.dart';
import 'package:zuritrails/models/hidden_gem_data.dart';
import 'package:zuritrails/screens/gems/create_gem/gem_images_screen.dart';
import 'package:zuritrails/screens/gems/create_gem/gem_location_screen.dart';
import 'package:zuritrails/screens/gems/create_gem/gem_details_screen.dart';
import 'package:zuritrails/screens/gems/create_gem/gem_review_screen.dart';
import 'package:zuritrails/utils/app_colors.dart';

class GemFlowCoordinator extends StatefulWidget {
  final HiddenGemData? existingGemData;

  const GemFlowCoordinator({
    super.key,
    this.existingGemData,
  });

  @override
  State<GemFlowCoordinator> createState() => _GemFlowCoordinatorState();
}

class _GemFlowCoordinatorState extends State<GemFlowCoordinator> {
  late HiddenGemData _gemData;
  int _currentStep = 0;

  final List<String> _stepTitles = [
    'Photos',
    'Location',
    'Details',
    'Review',
  ];

  @override
  void initState() {
    super.initState();
    _gemData = widget.existingGemData ?? HiddenGemData();
  }

  void _nextStep() {
    if (_currentStep < _stepTitles.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      _showExitConfirmation();
    }
  }

  void _goToStep(int step) {
    if (step >= 0 && step < _stepTitles.length) {
      setState(() {
        _currentStep = step;
      });
    }
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit without saving?'),
        content: const Text(
          'Your progress will be lost if you exit now. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit flow
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _onComplete() {
    // Here you would typically save the gem data to your backend
    // For now, we'll just show a success message and navigate back

    _gemData.createdAt = DateTime.now();
    _gemData.isDraft = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Hidden Gem Submitted!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your hidden gem "${_gemData.name}" has been submitted for review. We\'ll notify you once it\'s approved!',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit flow
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _previousStep();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // Progress Stepper
            SafeArea(
              bottom: false,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                color: AppColors.white,
                child: Column(
                  children: [
                    Row(
                      children: List.generate(_stepTitles.length, (index) {
                        final isCompleted = index < _currentStep;
                        final isCurrent = index == _currentStep;

                        return Expanded(
                          child: GestureDetector(
                            onTap: isCompleted ? () => _goToStep(index) : null,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    if (index > 0)
                                      Expanded(
                                        child: Container(
                                          height: 2,
                                          color: isCompleted
                                              ? AppColors.success
                                              : AppColors.greyLight,
                                        ),
                                      ),
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: isCompleted
                                            ? AppColors.success
                                            : isCurrent
                                                ? AppColors.berryCrush
                                                : AppColors.greyLight,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: isCompleted
                                            ? const Icon(
                                                Icons.check,
                                                color: AppColors.white,
                                                size: 18,
                                              )
                                            : Text(
                                                '${index + 1}',
                                                style: TextStyle(
                                                  color: isCurrent
                                                      ? AppColors.white
                                                      : AppColors.textSecondary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                      ),
                                    ),
                                    if (index < _stepTitles.length - 1)
                                      Expanded(
                                        child: Container(
                                          height: 2,
                                          color: isCompleted
                                              ? AppColors.success
                                              : AppColors.greyLight,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _stepTitles[index],
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                                    color: isCurrent
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

            // Current Step Content
            Expanded(
              child: _buildCurrentStep(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return GemImagesScreen(
          gemData: _gemData,
          onNext: _nextStep,
          onBack: _previousStep,
        );
      case 1:
        return GemLocationScreen(
          gemData: _gemData,
          onNext: _nextStep,
          onBack: _previousStep,
        );
      case 2:
        return GemDetailsScreen(
          gemData: _gemData,
          onNext: _nextStep,
          onBack: _previousStep,
        );
      case 3:
        return GemReviewScreen(
          gemData: _gemData,
          onSubmit: _onComplete,
          onBack: _previousStep,
          onEdit: _goToStep,
        );
      default:
        return const SizedBox();
    }
  }
}
