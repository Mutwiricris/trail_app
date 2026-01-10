import 'package:flutter/material.dart';
import 'package:zuritrails/models/signup_data.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/steps/welcome_step.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/steps/birthday_step.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/steps/referral_step.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/steps/name_step.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/steps/gender_step.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/steps/country_step.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/steps/travel_style_step.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/steps/interests_step.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/steps/profile_photo_step.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/steps/notifications_step.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/steps/activity_preferences_step.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/steps/location_step.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/steps/privacy_step.dart';
import 'package:zuritrails/screens/auth/welcome_screen.dart';

class SignupFlowCoordinator extends StatefulWidget {
  final String? email;

  const SignupFlowCoordinator({super.key, this.email});

  @override
  State<SignupFlowCoordinator> createState() => _SignupFlowCoordinatorState();
}

class _SignupFlowCoordinatorState extends State<SignupFlowCoordinator> {
  final PageController _pageController = PageController();
  final SignupData _signupData = SignupData();
  int _currentStep = 0;

  late final List<Widget> _steps;

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      _signupData.email = widget.email;
    }

    _steps = [
      WelcomeStep(onNext: _nextStep),
      BirthdayStep(signupData: _signupData, onNext: _nextStep),
      ReferralStep(signupData: _signupData, onNext: _nextStep),
      NameStep(signupData: _signupData, onNext: _nextStep),
      GenderStep(signupData: _signupData, onNext: _nextStep),
      CountryStep(signupData: _signupData, onNext: _nextStep),
      TravelStyleStep(signupData: _signupData, onNext: _nextStep),
      InterestsStep(signupData: _signupData, onNext: _nextStep),
      ProfilePhotoStep(signupData: _signupData, onNext: _nextStep),
      NotificationsStep(signupData: _signupData, onNext: _nextStep),
      ActivityPreferencesStep(signupData: _signupData, onNext: _nextStep),
      LocationStep(signupData: _signupData, onNext: _nextStep),
      PrivacyStep(signupData: _signupData, onComplete: _completeSignup),
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

  void _completeSignup() {
    // TODO: Implement actual signup logic with backend
    // Navigate to welcome screen with user's name
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => WelcomeScreen(
          userName: _signupData.firstName,
        ),
      ),
      (route) => false,
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
