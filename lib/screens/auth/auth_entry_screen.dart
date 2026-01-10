import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/signup_flow_coordinator.dart';
import 'package:zuritrails/screens/auth/phone_auth_screen.dart';

class AuthEntryScreen extends StatefulWidget {
  const AuthEntryScreen({super.key});

  @override
  State<AuthEntryScreen> createState() => _AuthEntryScreenState();
}

class _AuthEntryScreenState extends State<AuthEntryScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_emailController.text.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SignupFlowCoordinator(email: _emailController.text),
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
          icon: const Icon(Icons.close, color: AppColors.black),
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
                'Welcome to ZuriTrails',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Sign up to start your journey',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // Email field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: AppColors.grey,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

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

              // Or divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.grey.withOpacity(0.3),
                      thickness: 1,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.grey.withOpacity(0.3),
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Other signup options
              _buildSocialButton(
                icon: Icons.phone_outlined,
                label: 'Sign up with Phone',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PhoneAuthScreen(isSignup: true),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              _buildSocialButton(
                icon: Icons.facebook,
                label: 'Sign up with Facebook',
                iconColor: const Color(0xFF1877F2),
                onTap: () {
                  // TODO: Implement Facebook signup
                },
              ),

              const SizedBox(height: 12),

              _buildSocialButton(
                icon: Icons.g_mobiledata,
                label: 'Sign up with Google',
                iconColor: const Color(0xFF4285F4),
                onTap: () {
                  // TODO: Implement Google signup
                },
              ),

              const SizedBox(height: 12),

              _buildSocialButton(
                icon: Icons.apple,
                label: 'Sign up with Apple',
                iconColor: AppColors.black,
                onTap: () {
                  // TODO: Implement Apple signup
                },
              ),

              const SizedBox(height: 24),

              // Login link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PhoneAuthScreen(isSignup: false),
                          ),
                        );
                      },
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.berryCrush,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.black, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              icon,
              size: 24,
              color: iconColor ?? AppColors.black,
            ),
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 40), // Balance the icon space
          ],
        ),
      ),
    );
  }
}
