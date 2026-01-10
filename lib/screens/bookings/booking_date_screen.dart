import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/booking_data.dart';
import 'package:intl/intl.dart';

class BookingDateScreen extends StatefulWidget {
  final BookingData bookingData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const BookingDateScreen({
    super.key,
    required this.bookingData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<BookingDateScreen> createState() => _BookingDateScreenState();
}

class _BookingDateScreenState extends State<BookingDateScreen> {
  DateTime? _selectedDate;
  int _adults = 1;
  int _children = 0;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.bookingData.tourDate;
    _adults = widget.bookingData.adults;
    _children = widget.bookingData.children;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.berryCrush,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _updateBookingData() {
    widget.bookingData.tourDate = _selectedDate;
    widget.bookingData.adults = _adults;
    widget.bookingData.children = _children;
  }

  bool get _canProceed {
    return _selectedDate != null && (_adults + _children) > 0;
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
          'Select Date & Guests',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tour Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        if (widget.bookingData.tourImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              widget.bookingData.tourImage!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.bookingData.tourName ?? 'Tour',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (widget.bookingData.operatorName != null)
                                Text(
                                  'by ${widget.bookingData.operatorName}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Text(
                                'KES ${widget.bookingData.pricePerPerson?.toStringAsFixed(0) ?? '0'}/person',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.berryCrush,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Date Selection
                  Text(
                    'Select Tour Date',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedDate != null
                              ? AppColors.berryCrush
                              : AppColors.greyLight,
                          width: _selectedDate != null ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: _selectedDate != null
                                ? AppColors.berryCrush
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _selectedDate != null
                                  ? DateFormat('EEEE, MMMM d, yyyy')
                                      .format(_selectedDate!)
                                  : 'Choose a date',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: _selectedDate != null
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: _selectedDate != null
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Participants Selection
                  Text(
                    'Number of Guests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Adults
                  _buildParticipantCounter(
                    title: 'Adults',
                    subtitle: 'Age 18+',
                    count: _adults,
                    onIncrement: () {
                      setState(() {
                        if (_adults < 20) _adults++;
                      });
                    },
                    onDecrement: () {
                      setState(() {
                        if (_adults > 1) _adults--;
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // Children
                  _buildParticipantCounter(
                    title: 'Children',
                    subtitle: 'Age 0-17 (20% discount)',
                    count: _children,
                    onIncrement: () {
                      setState(() {
                        if (_children < 10) _children++;
                      });
                    },
                    onDecrement: () {
                      setState(() {
                        if (_children > 0) _children--;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Price Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.berryCrush.withOpacity(0.1),
                          AppColors.berryCrushLight.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.berryCrush.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Guests',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              '${_adults + _children}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        if (widget.bookingData.pricePerPerson != null) ...[
                          const SizedBox(height: 12),
                          Divider(color: AppColors.greyLight),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Estimated Total',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'KES ${_calculateEstimatedTotal().toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.berryCrush,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
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
              child: ElevatedButton(
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
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantCounter({
    required String title,
    required String subtitle,
    required int count,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: onDecrement,
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.greyLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.remove,
                    size: 20,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onIncrement,
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.berryCrush,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 20,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateEstimatedTotal() {
    final price = widget.bookingData.pricePerPerson ?? 0;
    final adultTotal = _adults * price;
    final childPrice = price * 0.8; // 20% discount
    final childTotal = _children * childPrice;
    return adultTotal + childTotal;
  }
}
