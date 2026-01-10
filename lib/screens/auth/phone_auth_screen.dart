import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/screens/auth/verification_code_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  final bool isSignup;

  const PhoneAuthScreen({
    super.key,
    this.isSignup = true,
  });

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  String _countryCode = '+254'; // Kenya default

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_phoneController.text.isNotEmpty && _phoneController.text.length >= 9) {
      final fullPhoneNumber = '$_countryCode${_phoneController.text}';
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VerificationCodeScreen(
            phoneNumber: fullPhoneNumber,
            isSignup: widget.isSignup,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid phone number'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                widget.isSignup ? 'Enter your phone number' : 'Log in with phone',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "We'll send you a code to verify your number.",
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.grey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              // Phone number field
              const Text(
                'Phone number',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Country code selector
                    InkWell(
                      onTap: () {
                        // TODO: Add country code selector
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              _countryCode,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.grey.withOpacity(0.3),
                    ),

                    // Phone number input
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontSize: 16),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: const InputDecoration(
                          hintText: '712 345 678',
                          hintStyle: TextStyle(color: AppColors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Standard messaging rates may apply.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.grey,
                  height: 1.4,
                ),
              ),

              const Spacer(),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.berryCrush,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
