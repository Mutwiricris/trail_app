import 'package:flutter/material.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/widgets/common/circular_progress_ring.dart';

class MatchPercentageBadge extends StatelessWidget {
  final int percentage;
  final String reason;
  final bool showReason;

  const MatchPercentageBadge({
    super.key,
    required this.percentage,
    required this.reason,
    this.showReason = true,
  });

  Color _getColor() {
    if (percentage >= 80) return AppColors.success;
    if (percentage >= 60) return AppColors.warning;
    return AppColors.info;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(showReason ? 12 : 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _getColor().withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress ring with percentage
          CircularProgressRing(
            progress: percentage / 100,
            size: 44,
            strokeWidth: 4,
            color: _getColor(),
            child: Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _getColor(),
              ),
            ),
          ),

          if (showReason) ...[
            const SizedBox(width: 12),
            // Reason text
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Match',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    reason,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
