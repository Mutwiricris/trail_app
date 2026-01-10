import 'package:flutter/material.dart';
import 'package:zuritrails/models/activity_data.dart';
import 'package:zuritrails/screens/activities/create_activity/steps/activity_description_step.dart';
import 'package:zuritrails/screens/activities/create_activity/steps/activity_type_step.dart';
import 'package:zuritrails/screens/activities/create_activity/steps/activity_location_step.dart';
import 'package:zuritrails/screens/activities/create_activity/steps/activity_datetime_step.dart';
import 'package:zuritrails/screens/activities/create_activity/steps/activity_participants_step.dart';

/// Coordinator for multi-step activity creation flow
class ActivityFlowCoordinator extends StatefulWidget {
  final Function(ActivityData)? onActivityCreated;

  const ActivityFlowCoordinator({super.key, this.onActivityCreated});

  @override
  State<ActivityFlowCoordinator> createState() =>
      _ActivityFlowCoordinatorState();
}

class _ActivityFlowCoordinatorState extends State<ActivityFlowCoordinator> {
  final PageController _pageController = PageController();
  final ActivityData _activityData = ActivityData();
  int _currentStep = 0;

  late final List<Widget> _steps;

  @override
  void initState() {
    super.initState();

    _steps = [
      ActivityDescriptionStep(
        activityData: _activityData,
        onNext: _nextStep,
      ),
      ActivityTypeStep(
        activityData: _activityData,
        onNext: _nextStep,
      ),
      ActivityLocationStep(
        activityData: _activityData,
        onNext: _nextStep,
      ),
      ActivityDateTimeStep(
        activityData: _activityData,
        onNext: _nextStep,
      ),
      ActivityParticipantsStep(
        activityData: _activityData,
        onComplete: _completeActivity,
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _completeActivity() {
    // TODO: Save activity to backend

    // Pass activity data back to map screen
    if (widget.onActivityCreated != null) {
      widget.onActivityCreated!(_activityData);
    }

    Navigator.of(context).pop();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Activity added to map!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentStep == 0,
      onPopInvoked: (bool didPop) {
        if (!didPop && _currentStep > 0) {
          _previousStep();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _currentStep > 0
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: _previousStep,
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              )
            : null,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _steps,
        ),
      ),
    );
  }
}
