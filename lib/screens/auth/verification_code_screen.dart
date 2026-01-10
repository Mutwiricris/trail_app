import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/signup_flow_coordinator.dart';
import 'package:zuritrails/screens/auth/welcome_screen.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String phoneNumber;
  final bool isSignup;

  const VerificationCodeScreen({
    super.key,
    required this.phoneNumber,
    this.isSignup = true,
  });

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    // Check if all fields are filled
    if (_controllers.every((controller) => controller.text.isNotEmpty)) {
      _verifyCode();
    }
  }

  void _onBackspace(int index) {
    if (index > 0) {
      _controllers[index].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyCode() async {
    setState(() {
      _isVerifying = true;
    });

    final code = _controllers.map((c) => c.text).join();

    // Simulate verification
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isVerifying = false;
      });

      // Navigate based on signup or login
      if (widget.isSignup) {
        // New user - go through signup flow
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => SignupFlowCoordinator(
              email: widget.phoneNumber, // Use phone as identifier
            ),
          ),
          (route) => false,
        );
      } else {
        // Existing user - go directly to home
        context.go('/home');
      }
    }
  }

  void _resendCode() {
    // TODO: Implement resend code logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification code sent!'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
              const Text(
                'Enter verification code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                'We sent a code to ${widget.phoneNumber}',
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.grey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // Verification code inputs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    height: 60,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                      decoration: InputDecoration(
                        counterText: '',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.grey,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.berryCrush,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(8),
                      ),
                      onChanged: (value) => _onCodeChanged(index, value),
                      onTap: () {
                        // Clear on tap
                        _controllers[index].clear();
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              // Resend code
              Center(
                child: Column(
                  children: [
                    const Text(
                      "Didn't receive a code?",
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _resendCode,
                      child: const Text(
                        'Resend code',
                        style: TextStyle(
                          color: AppColors.berryCrush,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Loading indicator or verify button
              if (_isVerifying)
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.berryCrush,
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _controllers.every((c) => c.text.isNotEmpty)
                        ? _verifyCode
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.berryCrush,
                      foregroundColor: AppColors.white,
                      disabledBackgroundColor: AppColors.grey.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Verify',
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
