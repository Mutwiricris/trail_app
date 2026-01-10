import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/booking_data.dart';

class BookingPaymentOptionsScreen extends StatefulWidget {
  final BookingData bookingData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const BookingPaymentOptionsScreen({
    super.key,
    required this.bookingData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<BookingPaymentOptionsScreen> createState() =>
      _BookingPaymentOptionsScreenState();
}

class _BookingPaymentOptionsScreenState
    extends State<BookingPaymentOptionsScreen> {
  PaymentOption? _selectedPaymentOption;
  final TextEditingController _promoCodeController = TextEditingController();
  bool _promoApplied = false;

  @override
  void initState() {
    super.initState();
    _selectedPaymentOption = widget.bookingData.paymentOption;
    if (widget.bookingData.promoCode != null) {
      _promoCodeController.text = widget.bookingData.promoCode!;
      _promoApplied = true;
    }
  }

  void _applyPromoCode() {
    // In a real app, validate promo code with backend
    if (_promoCodeController.text.trim().isNotEmpty) {
      setState(() {
        _promoApplied = true;
        widget.bookingData.promoCode = _promoCodeController.text.trim();
        // Apply a 10% discount for demo
        widget.bookingData.discount = widget.bookingData.subtotal * 0.1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Promo code applied! 10% discount'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _removePromoCode() {
    setState(() {
      _promoApplied = false;
      _promoCodeController.clear();
      widget.bookingData.promoCode = null;
      widget.bookingData.discount = null;
    });
  }

  void _updateBookingData() {
    widget.bookingData.paymentOption = _selectedPaymentOption;
  }

  bool get _canProceed => _selectedPaymentOption != null;

  @override
  void dispose() {
    _promoCodeController.dispose();
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
          'Payment Options',
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
                  // Price Breakdown
                  _buildPriceBreakdown(),
                  const SizedBox(height: 24),

                  // Promo Code
                  Text(
                    'Promo Code',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _promoCodeController,
                          enabled: !_promoApplied,
                          decoration: InputDecoration(
                            hintText: 'Enter promo code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
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
                            suffixIcon: _promoApplied
                                ? IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: _removePromoCode,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _promoApplied ? null : _applyPromoCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _promoApplied
                              ? AppColors.success
                              : AppColors.berryCrush,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(_promoApplied ? 'Applied' : 'Apply'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Payment Options
                  Text(
                    'Select Payment Option',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Full Payment Option
                  _buildPaymentOptionCard(
                    option: PaymentOption.full,
                    title: 'Pay in Full',
                    subtitle: 'Pay the total amount now',
                    amount: widget.bookingData.totalAmount,
                    badge: 'Recommended',
                    icon: Icons.payment,
                    benefits: [
                      'Instant confirmation',
                      'No additional fees',
                      'Secure booking',
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Partial Payment Option
                  _buildPaymentOptionCard(
                    option: PaymentOption.partial,
                    title: 'Pay Deposit',
                    subtitle:
                        'Pay ${widget.bookingData.depositPercentage?.toInt()}% now, rest later',
                    amount: widget.bookingData.depositAmount,
                    icon: Icons.schedule_send,
                    benefits: [
                      'Secure your booking',
                      'Pay remaining before tour',
                      'Flexible payment',
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.info.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.info,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedPaymentOption == PaymentOption.partial
                                ? 'Remaining balance of KES ${widget.bookingData.remainingBalance.toStringAsFixed(0)} must be paid at least 7 days before the tour date.'
                                : 'Your booking will be confirmed immediately after payment.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                              height: 1.4,
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
                  'Continue to Payment Method',
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

  Widget _buildPriceBreakdown() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Breakdown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildPriceRow(
            'Adults (${widget.bookingData.adults})',
            widget.bookingData.adults *
                (widget.bookingData.pricePerPerson ?? 0),
          ),
          if (widget.bookingData.children > 0) ...[
            const SizedBox(height: 8),
            _buildPriceRow(
              'Children (${widget.bookingData.children}) - 20% off',
              widget.bookingData.children *
                  (widget.bookingData.pricePerPerson ?? 0) *
                  0.8,
            ),
          ],
          const SizedBox(height: 12),
          Divider(color: AppColors.greyLight),
          const SizedBox(height: 12),
          _buildPriceRow('Subtotal', widget.bookingData.subtotal),
          if (widget.bookingData.discountAmount > 0) ...[
            const SizedBox(height: 8),
            _buildPriceRow(
              'Discount',
              -widget.bookingData.discountAmount,
              isDiscount: true,
            ),
          ],
          const SizedBox(height: 8),
          _buildPriceRow('Tax (16%)', widget.bookingData.taxAmount),
          const SizedBox(height: 8),
          _buildPriceRow('Service Fee', widget.bookingData.serviceFeeAmount),
          const SizedBox(height: 12),
          Divider(color: AppColors.greyLight),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'KES ${widget.bookingData.totalAmount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.berryCrush,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          '${isDiscount ? '-' : ''}KES ${amount.abs().toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDiscount ? AppColors.success : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOptionCard({
    required PaymentOption option,
    required String title,
    required String subtitle,
    required double amount,
    required IconData icon,
    String? badge,
    required List<String> benefits,
  }) {
    final isSelected = _selectedPaymentOption == option;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentOption = option;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.berryCrush : AppColors.greyLight,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.berryCrush.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.berryCrush.withOpacity(0.1)
                        : AppColors.greyLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? AppColors.berryCrush : AppColors.textSecondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (badge != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warning,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                badge,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
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
                Radio<PaymentOption>(
                  value: option,
                  groupValue: _selectedPaymentOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentOption = value;
                    });
                  },
                  activeColor: AppColors.berryCrush,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.berryCrush.withOpacity(0.1)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Amount to Pay',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'KES ${amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.berryCrush
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        benefit,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
