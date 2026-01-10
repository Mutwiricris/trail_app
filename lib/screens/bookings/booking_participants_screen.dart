import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/booking_data.dart';

class BookingParticipantsScreen extends StatefulWidget {
  final BookingData bookingData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const BookingParticipantsScreen({
    super.key,
    required this.bookingData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<BookingParticipantsScreen> createState() =>
      _BookingParticipantsScreenState();
}

class _BookingParticipantsScreenState extends State<BookingParticipantsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<ParticipantInfo> _participants = [];
  final TextEditingController _specialRequestsController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeParticipants();
    _tabController = TabController(
      length: widget.bookingData.totalParticipants,
      vsync: this,
    );
    if (widget.bookingData.specialRequests != null) {
      _specialRequestsController.text = widget.bookingData.specialRequests!;
    }
  }

  void _initializeParticipants() {
    // Load existing participants or create new ones
    if (widget.bookingData.participants.isNotEmpty) {
      _participants.addAll(widget.bookingData.participants);
    } else {
      // Create participant objects
      for (int i = 0; i < widget.bookingData.adults; i++) {
        _participants.add(ParticipantInfo(isChild: false));
      }
      for (int i = 0; i < widget.bookingData.children; i++) {
        _participants.add(ParticipantInfo(isChild: true));
      }
    }
  }

  void _updateBookingData() {
    widget.bookingData.participants = List.from(_participants);
    widget.bookingData.specialRequests =
        _specialRequestsController.text.trim().isNotEmpty
            ? _specialRequestsController.text.trim()
            : null;
  }

  bool get _canProceed {
    return _participants.every((p) => p.isValid);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _specialRequestsController.dispose();
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
          'Participant Details',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: AppColors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.berryCrush,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.berryCrush,
              tabs: List.generate(
                widget.bookingData.totalParticipants,
                (index) {
                  final isChild = index >= widget.bookingData.adults;
                  return Tab(
                    text: isChild
                        ? 'Child ${index - widget.bookingData.adults + 1}'
                        : 'Adult ${index + 1}',
                  );
                },
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(
                widget.bookingData.totalParticipants,
                (index) => _buildParticipantForm(index),
              ),
            ),
          ),

          // Special Requests Section
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Special Requests (Optional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _specialRequestsController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Dietary requirements, accessibility needs, etc.',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.greyLight),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.greyLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.berryCrush,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Button
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
                              'Please fill in required fields for all participants',
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
                            _updateBookingData();
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
                      'Continue to Payment',
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

  Widget _buildParticipantForm(int index) {
    final participant = _participants[index];
    final isChild = participant.isChild;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isChild
                  ? AppColors.info.withOpacity(0.1)
                  : AppColors.berryCrush.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isChild ? Icons.child_care : Icons.person,
                  color: isChild ? AppColors.info : AppColors.berryCrush,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isChild
                      ? 'Child ${index - widget.bookingData.adults + 1} (20% discount applied)'
                      : 'Adult ${index + 1}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // First Name
          _buildTextField(
            label: 'First Name *',
            hint: 'Enter first name',
            initialValue: participant.firstName,
            onChanged: (value) {
              setState(() {
                participant.firstName = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Last Name
          _buildTextField(
            label: 'Last Name *',
            hint: 'Enter last name',
            initialValue: participant.lastName,
            onChanged: (value) {
              setState(() {
                participant.lastName = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Email
          _buildTextField(
            label: 'Email',
            hint: 'email@example.com',
            initialValue: participant.email,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              setState(() {
                participant.email = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Phone
          _buildTextField(
            label: 'Phone Number',
            hint: '+254 712 345 678',
            initialValue: participant.phone,
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              setState(() {
                participant.phone = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Nationality
          _buildTextField(
            label: 'Nationality',
            hint: 'e.g., Kenyan',
            initialValue: participant.nationality,
            onChanged: (value) {
              setState(() {
                participant.nationality = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // ID Number
          _buildTextField(
            label: 'ID/Passport Number',
            hint: 'Enter ID or passport number',
            initialValue: participant.idNumber,
            onChanged: (value) {
              setState(() {
                participant.idNumber = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    String? initialValue,
    required Function(String) onChanged,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
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
              borderSide: BorderSide(
                color: AppColors.berryCrush,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.all(16),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
