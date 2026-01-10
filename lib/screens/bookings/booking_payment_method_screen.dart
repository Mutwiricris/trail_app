import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/booking_data.dart';

class BookingPaymentMethodScreen extends StatefulWidget {
  final BookingData bookingData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const BookingPaymentMethodScreen({
    super.key,
    required this.bookingData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<BookingPaymentMethodScreen> createState() =>
      _BookingPaymentMethodScreenState();
}

class _BookingPaymentMethodScreenState
    extends State<BookingPaymentMethodScreen> {
  PaymentMethod? _selectedMethod;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardExpiryController = TextEditingController();
  final TextEditingController _cardCvvController = TextEditingController();
  final TextEditingController _cardNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.bookingData.paymentMethod;
  }

  void _updateBookingData() {
    widget.bookingData.paymentMethod = _selectedMethod;
  }

  bool get _canProceed {
    if (_selectedMethod == null) return false;

    switch (_selectedMethod!) {
      case PaymentMethod.mpesa:
        return _phoneController.text.trim().length >= 10;
      case PaymentMethod.card:
        return _cardNumberController.text.trim().length >= 16 &&
            _cardExpiryController.text.trim().isNotEmpty &&
            _cardCvvController.text.trim().length >= 3 &&
            _cardNameController.text.trim().isNotEmpty;
      case PaymentMethod.bankTransfer:
      case PaymentMethod.cash:
        return true;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    _cardNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amountToPay = widget.bookingData.paymentOption == PaymentOption.full
        ? widget.bookingData.totalAmount
        : widget.bookingData.depositAmount;

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
          'Payment Method',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Amount Banner
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.berryCrush,
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Amount to Pay',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                  Text(
                    'KES ${amountToPay.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Payment Method',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // M-Pesa
                  _buildPaymentMethodTile(
                    method: PaymentMethod.mpesa,
                    title: 'M-Pesa',
                    subtitle: 'Pay with M-Pesa mobile money',
                    icon: Icons.phone_android,
                    iconColor: AppColors.success,
                  ),
                  if (_selectedMethod == PaymentMethod.mpesa) ...[
                    const SizedBox(height: 16),
                    _buildMpesaForm(),
                  ],
                  const SizedBox(height: 12),

                  // Card
                  _buildPaymentMethodTile(
                    method: PaymentMethod.card,
                    title: 'Debit/Credit Card',
                    subtitle: 'Visa, Mastercard, Amex',
                    icon: Icons.credit_card,
                    iconColor: AppColors.info,
                  ),
                  if (_selectedMethod == PaymentMethod.card) ...[
                    const SizedBox(height: 16),
                    _buildCardForm(),
                  ],
                  const SizedBox(height: 12),

                  // Bank Transfer
                  _buildPaymentMethodTile(
                    method: PaymentMethod.bankTransfer,
                    title: 'Bank Transfer',
                    subtitle: 'Direct bank transfer',
                    icon: Icons.account_balance,
                    iconColor: AppColors.warning,
                  ),
                  const SizedBox(height: 12),

                  // Cash
                  _buildPaymentMethodTile(
                    method: PaymentMethod.cash,
                    title: 'Pay on Arrival',
                    subtitle: 'Cash payment before tour',
                    icon: Icons.payments,
                    iconColor: AppColors.textSecondary,
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
                  'Proceed to Payment',
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

  Widget _buildPaymentMethodTile({
    required PaymentMethod method,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    final isSelected = _selectedMethod == method;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = method;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.berryCrush : AppColors.greyLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
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
            Radio<PaymentMethod>(
              value: method,
              groupValue: _selectedMethod,
              onChanged: (value) {
                setState(() {
                  _selectedMethod = value;
                });
              },
              activeColor: AppColors.berryCrush,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMpesaForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'M-Pesa Phone Number',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: '0712345678',
              prefixIcon: Icon(Icons.phone, color: AppColors.success),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.berryCrush, width: 2),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.success, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You will receive an M-Pesa prompt on your phone to complete the payment',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Card Number',
              hintText: '1234 5678 9012 3456',
              prefixIcon: Icon(Icons.credit_card, color: AppColors.info),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.berryCrush, width: 2),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _cardNameController,
            decoration: InputDecoration(
              labelText: 'Cardholder Name',
              hintText: 'John Doe',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.berryCrush, width: 2),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cardExpiryController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: 'Expiry',
                    hintText: 'MM/YY',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.berryCrush, width: 2),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _cardCvvController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: '123',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.berryCrush, width: 2),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
