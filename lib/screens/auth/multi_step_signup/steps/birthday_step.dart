import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/signup_data.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/widgets/signup_button.dart';

class BirthdayStep extends StatefulWidget {
  final SignupData signupData;
  final VoidCallback onNext;

  const BirthdayStep({
    super.key,
    required this.signupData,
    required this.onNext,
  });

  @override
  State<BirthdayStep> createState() => _BirthdayStepState();
}

class _BirthdayStepState extends State<BirthdayStep> {
  DateTime? _selectedDate;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        widget.signupData.birthday = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _handleNext() {
    if (_selectedDate != null) {
      // Check if user is at least 18
      final age = DateTime.now().difference(_selectedDate!).inDays ~/ 365;
      if (age < 18) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be at least 18 years old to sign up'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Question
              const Text(
                "when's your birthday?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'you must be at least 18 years old',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
                ),
              ),

              const SizedBox(height: 40),

              // Date picker button
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    _selectedDate != null ? _formatDate(_selectedDate!) : 'select date',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: _selectedDate != null ? AppColors.black : AppColors.grey,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Next button
              SignupButton(
                text: 'next',
                onPressed: _handleNext,
                isEnabled: _selectedDate != null,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
