import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime targetDate;
  final String label;

  const CountdownTimer({
    super.key,
    required this.targetDate,
    this.label = 'Resets in',
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    setState(() {
      _remaining = widget.targetDate.difference(DateTime.now());
      if (_remaining.isNegative) {
        _remaining = Duration.zero;
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);

    if (days > 0) {
      return '$days day${days > 1 ? 's' : ''}';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.warning.withOpacity(0.15),
            AppColors.warning.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule,
            size: 14,
            color: AppColors.warning,
          ),
          const SizedBox(width: 6),
          Text(
            '${widget.label} ',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            _formatDuration(_remaining),
            style: TextStyle(
              fontSize: 11,
              color: AppColors.warning,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
