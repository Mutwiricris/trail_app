import 'package:flutter/material.dart';
import 'package:zuritrails/models/booking_data.dart';
import 'package:zuritrails/screens/bookings/booking_date_screen.dart';
import 'package:zuritrails/screens/bookings/booking_participants_screen.dart';
import 'package:zuritrails/screens/bookings/booking_payment_options_screen.dart';
import 'package:zuritrails/screens/bookings/booking_payment_method_screen.dart';
import 'package:zuritrails/screens/bookings/booking_payment_processing_screen.dart';
import 'package:zuritrails/screens/bookings/booking_confirmation_screen.dart';
import 'package:zuritrails/utils/app_colors.dart';

class BookingFlowCoordinator extends StatefulWidget {
  final Map<String, dynamic> tourData;

  const BookingFlowCoordinator({
    super.key,
    required this.tourData,
  });

  @override
  State<BookingFlowCoordinator> createState() => _BookingFlowCoordinatorState();
}

class _BookingFlowCoordinatorState extends State<BookingFlowCoordinator> {
  late BookingData _bookingData;
  int _currentStep = 0;

  final List<String> _stepTitles = [
    'Date',
    'Guests',
    'Payment',
    'Method',
    'Confirm',
  ];

  @override
  void initState() {
    super.initState();
    _bookingData = BookingData(
      tourId: widget.tourData['id'],
      tourName: widget.tourData['name'] ?? widget.tourData['title'],
      tourImage: widget.tourData['image'] ?? widget.tourData['imageUrl'],
      pricePerPerson: widget.tourData['price']?.toDouble() ??
          widget.tourData['pricePerPerson']?.toDouble(),
      operatorName: widget.tourData['operatorName'],
      operatorId: widget.tourData['operatorId'],
    );
  }

  void _nextStep() {
    if (_currentStep < _stepTitles.length - 2) {
      setState(() {
        _currentStep++;
      });
    } else if (_currentStep == _stepTitles.length - 2) {
      // Move to payment processing
      _showPaymentProcessing();
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

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking?'),
        content: const Text(
          'Are you sure you want to cancel this booking? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue Booking'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit flow
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }

  void _showPaymentProcessing() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingPaymentProcessingScreen(
          bookingData: _bookingData,
          onComplete: _showConfirmation,
        ),
      ),
    );
  }

  void _showConfirmation() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConfirmationScreen(
          bookingData: _bookingData,
        ),
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
                child: Row(
                  children: List.generate(_stepTitles.length - 1, (index) {
                    final isCompleted = index < _currentStep;
                    final isCurrent = index == _currentStep;

                    return Expanded(
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
                              if (index < _stepTitles.length - 2)
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
                    );
                  }),
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
        return BookingDateScreen(
          bookingData: _bookingData,
          onNext: _nextStep,
          onBack: _previousStep,
        );
      case 1:
        return BookingParticipantsScreen(
          bookingData: _bookingData,
          onNext: _nextStep,
          onBack: _previousStep,
        );
      case 2:
        return BookingPaymentOptionsScreen(
          bookingData: _bookingData,
          onNext: _nextStep,
          onBack: _previousStep,
        );
      case 3:
        return BookingPaymentMethodScreen(
          bookingData: _bookingData,
          onNext: _nextStep,
          onBack: _previousStep,
        );
      default:
        return const SizedBox();
    }
  }
}
