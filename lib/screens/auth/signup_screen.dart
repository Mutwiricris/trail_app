import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/screens/main_navigation.dart';

class SignupScreen extends StatefulWidget {
  final String? email;

  const SignupScreen({super.key, this.email});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      _emailController.text = widget.email!;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthdayController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
        _birthdayController.text =
            '${picked.month}/${picked.day}/${picked.year}';
      });
    }
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      // Navigate to main navigation (home screen)
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const MainNavigation(),
        ),
        (route) => false,
      );
    } else if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the terms to continue'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Finish signing up',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 32),

                // Legal name section
                const Text(
                  'Legal name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 12),

                // Name fields container
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // First name
                      TextField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          hintText: 'First name on ID',
                          hintStyle: TextStyle(color: AppColors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.grey.withOpacity(0.3),
                      ),
                      // Last name
                      TextField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          hintText: 'Last name on ID',
                          hintStyle: TextStyle(color: AppColors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Name helper text
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.grey,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'Make sure this matches the name on your government ID. If you go by another name, you can ',
                      ),
                      TextSpan(
                        text: 'add a preferred first name',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Date of birth section
                const Text(
                  'Date of birth',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 12),

                // Birthday field
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _birthdayController,
                      enabled: false,
                      decoration: const InputDecoration(
                        hintText: 'Birthday',
                        hintStyle: TextStyle(color: AppColors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Birthday helper text
                const Text(
                  "To sign up, you need to be at least 18. Other people who use ZuriTrails won't see your birthday.",
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.grey,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 24),

                // Email section
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 12),

                // Email field
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Text(
                          _emailController.text.isEmpty
                              ? 'you@example.com'
                              : _emailController.text,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Email helper text
                const Text(
                  "We'll email you a reservation confirmation.",
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.grey,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 24),

                // Password section
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 12),

                // Password field
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: AppColors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        child: Text(
                          _isPasswordVisible ? 'Hide' : 'Show',
                          style: const TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Terms and conditions
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.grey,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: 'By selecting '),
                      const TextSpan(
                        text: 'Agree and continue',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(text: ', I agree to ZuriTrails\'s '),
                      const TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      const TextSpan(text: ', '),
                      const TextSpan(
                        text: 'Payments Terms of Service',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      const TextSpan(
                        text: 'Nondiscrimination Policy',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      const TextSpan(text: ', and acknowledge the '),
                      const TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Agree and continue button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.berryCrush,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Agree and continue',
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
      ),
    );
  }
}
