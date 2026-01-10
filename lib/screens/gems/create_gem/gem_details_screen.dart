import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/hidden_gem_data.dart';

class GemDetailsScreen extends StatefulWidget {
  final HiddenGemData gemData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const GemDetailsScreen({
    super.key,
    required this.gemData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<GemDetailsScreen> createState() => _GemDetailsScreenState();
}

class _GemDetailsScreenState extends State<GemDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _accessInfoController = TextEditingController();
  final TextEditingController _facilitiesController = TextEditingController();
  final TextEditingController _entryFeeController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  String? _selectedCategory;
  String? _selectedDifficulty;
  String? _selectedBestTime;
  final List<String> _selectedTags = [];

  final List<String> _categories = [
    'Waterfall',
    'Mountain',
    'Beach',
    'Forest',
    'Lake',
    'Cave',
    'Valley',
    'Wildlife',
    'Cultural Site',
    'Historical',
    'Adventure',
    'Other',
  ];

  final List<String> _difficulties = [
    'Easy',
    'Moderate',
    'Hard',
    'Expert',
  ];

  final List<String> _bestTimes = [
    'All Year',
    'Dry Season (June - October)',
    'Rainy Season (March - May)',
    'Morning',
    'Afternoon',
    'Evening',
    'Sunrise',
    'Sunset',
  ];

  final List<String> _availableTags = [
    'Family Friendly',
    'Pet Friendly',
    'Photography',
    'Hiking',
    'Swimming',
    'Camping',
    'Picnic Area',
    'Guided Tours',
    'Wildlife Viewing',
    'Bird Watching',
    'Rock Climbing',
    'Fishing',
    'Scenic Views',
    'Remote',
    'Accessible',
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    if (widget.gemData.name != null) {
      _nameController.text = widget.gemData.name!;
    }
    if (widget.gemData.description != null) {
      _descriptionController.text = widget.gemData.description!;
    }
    if (widget.gemData.accessInfo != null) {
      _accessInfoController.text = widget.gemData.accessInfo!;
    }
    if (widget.gemData.facilities != null) {
      _facilitiesController.text = widget.gemData.facilities!;
    }
    if (widget.gemData.entryFee != null) {
      _entryFeeController.text = widget.gemData.entryFee.toString();
    }
    if (widget.gemData.contactPhone != null) {
      _contactController.text = widget.gemData.contactPhone!;
    }
    if (widget.gemData.website != null) {
      _websiteController.text = widget.gemData.website!;
    }
    _selectedCategory = widget.gemData.category;
    _selectedDifficulty = widget.gemData.difficulty;
    _selectedBestTime = widget.gemData.bestTimeToVisit;
    if (widget.gemData.tags != null) {
      _selectedTags.addAll(widget.gemData.tags!);
    }
  }

  void _updateGemData() {
    widget.gemData.name = _nameController.text.trim();
    widget.gemData.description = _descriptionController.text.trim();
    widget.gemData.category = _selectedCategory;
    widget.gemData.difficulty = _selectedDifficulty;
    widget.gemData.bestTimeToVisit = _selectedBestTime;
    widget.gemData.tags = _selectedTags.isNotEmpty ? List.from(_selectedTags) : null;
    widget.gemData.accessInfo = _accessInfoController.text.trim().isNotEmpty
        ? _accessInfoController.text.trim()
        : null;
    widget.gemData.facilities = _facilitiesController.text.trim().isNotEmpty
        ? _facilitiesController.text.trim()
        : null;
    widget.gemData.entryFee = _entryFeeController.text.trim().isNotEmpty
        ? double.tryParse(_entryFeeController.text.trim())
        : null;
    widget.gemData.contactPhone = _contactController.text.trim().isNotEmpty
        ? _contactController.text.trim()
        : null;
    widget.gemData.website = _websiteController.text.trim().isNotEmpty
        ? _websiteController.text.trim()
        : null;
  }

  bool get _canProceed {
    return _nameController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().length >= 50 &&
        _selectedCategory != null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _accessInfoController.dispose();
    _facilitiesController.dispose();
    _entryFeeController.dispose();
    _contactController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: widget.onBack,
        ),
        title: const Text(
          'Gem Details',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Progress info
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.white,
            child: Row(
              children: [
                Icon(
                  Icons.edit_note,
                  color: AppColors.berryCrush,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tell us about this hidden gem',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    _buildSectionTitle('Basic Information', required: true),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Name *',
                      hint: 'e.g., Secret Waterfall Paradise',
                      icon: Icons.title,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Description * (min. 50 characters)',
                      hint: 'Describe what makes this place special...',
                      icon: Icons.description,
                      maxLines: 5,
                      counter: true,
                    ),
                    const SizedBox(height: 16),

                    // Category
                    _buildDropdown(
                      label: 'Category *',
                      value: _selectedCategory,
                      items: _categories,
                      icon: Icons.category,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Visit Information
                    _buildSectionTitle('Visit Information'),
                    const SizedBox(height: 12),
                    _buildDropdown(
                      label: 'Difficulty Level',
                      value: _selectedDifficulty,
                      items: _difficulties,
                      icon: Icons.terrain,
                      onChanged: (value) {
                        setState(() {
                          _selectedDifficulty = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: 'Best Time to Visit',
                      value: _selectedBestTime,
                      items: _bestTimes,
                      icon: Icons.wb_sunny,
                      onChanged: (value) {
                        setState(() {
                          _selectedBestTime = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _entryFeeController,
                      label: 'Entry Fee (KES)',
                      hint: 'e.g., 500',
                      icon: Icons.payments,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _accessInfoController,
                      label: 'Access Information',
                      hint: 'How to get there, parking info, etc.',
                      icon: Icons.directions,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _facilitiesController,
                      label: 'Available Facilities',
                      hint: 'e.g., Restrooms, parking, camping sites',
                      icon: Icons.cabin,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),

                    // Tags
                    _buildSectionTitle('Tags & Features'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableTags.map((tag) {
                        final isSelected = _selectedTags.contains(tag);
                        return FilterChip(
                          label: Text(tag),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedTags.add(tag);
                              } else {
                                _selectedTags.remove(tag);
                              }
                            });
                          },
                          selectedColor: AppColors.berryCrush.withOpacity(0.2),
                          checkmarkColor: AppColors.berryCrush,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.berryCrush
                                : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Contact Information
                    _buildSectionTitle('Contact Information (Optional)'),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _contactController,
                      label: 'Contact Phone',
                      hint: '+254 712 345 678',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _websiteController,
                      label: 'Website',
                      hint: 'https://example.com',
                      icon: Icons.language,
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Action Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_canProceed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Please fill in all required fields (marked with *)',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _canProceed
                        ? () {
                            _updateGemData();
                            widget.onNext();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.berryCrush,
                      disabledBackgroundColor: AppColors.greyLight,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {bool required = false}) {
    return Text(
      title + (required ? ' *' : ''),
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool counter = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.berryCrush),
        counter: counter
            ? Text(
                '${controller.text.length} characters',
                style: TextStyle(
                  fontSize: 11,
                  color: controller.text.length >= 50
                      ? AppColors.success
                      : AppColors.textSecondary,
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.greyLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.greyLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.berryCrush, width: 2),
        ),
        filled: true,
        fillColor: AppColors.white,
      ),
      onChanged: counter ? (_) => setState(() {}) : null,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.berryCrush),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.greyLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.greyLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.berryCrush, width: 2),
        ),
        filled: true,
        fillColor: AppColors.white,
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
