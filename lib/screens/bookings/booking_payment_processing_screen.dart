import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/models/booking_data.dart';
import 'dart:async';

class BookingPaymentProcessingScreen extends StatefulWidget {
  final BookingData bookingData;
  final VoidCallback on

Complete;

  const BookingPaymentProcessingScreen({
    super.key,
    required this.bookingData,
    required this.onComplete,
  });

  @override
  State<BookingPaymentProcessingScreen> createState() =>
      _BookingPaymentProcessingScreenState();
}

class _BookingPaymentProcessingScreenState
    extends State<BookingPaymentProcessingScreen> {
  bool _isProcessing = true;
  bool _isSuccess = false;
  String _statusMessage = 'Processing payment...';

  @override
  void initState() {
    super.initState();
    _processPayment();
  }

  Future<void> _processPayment() async {
    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _statusMessage = 'Connecting to payment gateway...';
      });
    }

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _statusMessage = 'Verifying payment...';
      });
    }

    await Future.delayed(const Duration(seconds: 2));

    // Simulate successful payment
    final transaction = PaymentTransaction(
      transactionId: 'TXN${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      amount: widget.bookingData.paymentOption == PaymentOption.full
          ? widget.bookingData.totalAmount
          : widget.bookingData.depositAmount,
      method: widget.bookingData.paymentMethod!,
      status: PaymentStatus.completed,
      referenceNumber: 'REF${DateTime.now().millisecondsSinceEpoch}',
    );

    widget.bookingData.transactions = [transaction];
    widget.bookingData.amountPaid = transaction.amount;
    widget.bookingData.status = BookingStatus.confirmed;
    widget.bookingData.paymentStatus =
        widget.bookingData.paymentOption == PaymentOption.full
            ? PaymentStatus.completed
            : PaymentStatus.partial;
    widget.bookingData.bookingId = 'BK${DateTime.now().millisecondsSinceEpoch}';
    widget.bookingData.confirmationCode = 'ZT${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    widget.bookingData.createdAt = DateTime.now();

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
        _statusMessage = 'Payment successful!';
      });
    }

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isProcessing) ...[
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.berryCrush.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.berryCrush,
                      ),
                    ),
                  ),
                ] else if (_isSuccess) ...[
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 80,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                Text(
                  _statusMessage,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  _isProcessing
                      ? 'Please wait while we process your payment...'
                      : 'Your booking has been confirmed!',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.bookingData.paymentMethod == PaymentMethod.mpesa &&
                    _isProcessing) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone_android,
                          color: AppColors.success,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Check your phone for M-Pesa prompt and enter your PIN to complete payment',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
