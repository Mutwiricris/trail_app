import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/signup_data.dart';
import 'package:zuritrails/screens/auth/multi_step_signup/widgets/signup_button.dart';

class CountryStep extends StatefulWidget {
  final SignupData signupData;
  final VoidCallback onNext;

  const CountryStep({
    super.key,
    required this.signupData,
    required this.onNext,
  });

  @override
  State<CountryStep> createState() => _CountryStepState();
}

class _CountryStepState extends State<CountryStep> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCountry;
  List<Map<String, String>> _filteredCountries = [];

  final List<Map<String, String>> _countries = [
    {'name': 'Kenya', 'flag': '🇰🇪'},
    {'name': 'United States', 'flag': '🇺🇸'},
    {'name': 'United Kingdom', 'flag': '🇬🇧'},
    {'name': 'Canada', 'flag': '🇨🇦'},
    {'name': 'Australia', 'flag': '🇦🇺'},
    {'name': 'Germany', 'flag': '🇩🇪'},
    {'name': 'France', 'flag': '🇫🇷'},
    {'name': 'Spain', 'flag': '🇪🇸'},
    {'name': 'Italy', 'flag': '🇮🇹'},
    {'name': 'Netherlands', 'flag': '🇳🇱'},
    {'name': 'South Africa', 'flag': '🇿🇦'},
    {'name': 'Nigeria', 'flag': '🇳🇬'},
    {'name': 'Ghana', 'flag': '🇬🇭'},
    {'name': 'Uganda', 'flag': '🇺🇬'},
    {'name': 'Tanzania', 'flag': '🇹🇿'},
    {'name': 'India', 'flag': '🇮🇳'},
    {'name': 'China', 'flag': '🇨🇳'},
    {'name': 'Japan', 'flag': '🇯🇵'},
    {'name': 'Brazil', 'flag': '🇧🇷'},
    {'name': 'Mexico', 'flag': '🇲🇽'},
  ];

  @override
  void initState() {
    super.initState();
    _filteredCountries = _countries;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = _countries;
      } else {
        _filteredCountries = _countries
            .where((country) =>
                country['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _handleSelection(String country) {
    setState(() {
      _selectedCountry = country;
      widget.signupData.homeCountry = country;
    });
  }

  void _handleNext() {
    if (_selectedCountry != null) {
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
                "what's your home country?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'the flag that will appear on your profile',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
                ),
              ),

              const SizedBox(height: 24),

              // Search field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search countries...',
                          hintStyle: TextStyle(color: AppColors.grey),
                        ),
                        onChanged: _filterCountries,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Countries list
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredCountries.length,
                  itemBuilder: (context, index) {
                    final country = _filteredCountries[index];
                    final isSelected = _selectedCountry == country['name'];

                    return GestureDetector(
                      onTap: () => _handleSelection(country['name']!),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.berryCrush
                                : AppColors.grey.withOpacity(0.2),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              country['flag']!,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                country['name']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.berryCrush,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Next button
              SignupButton(
                text: 'next',
                onPressed: _handleNext,
                isEnabled: _selectedCountry != null,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
