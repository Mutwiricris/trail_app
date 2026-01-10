import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zuritrails/models/journey.dart';
import 'package:zuritrails/services/journey_service.dart';
import 'package:zuritrails/services/exploration_score_service.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_spacing.dart';
import 'package:zuritrails/utils/app_typography.dart';

/// Exploration Score Dashboard screen
class ExplorationScoreScreen extends StatefulWidget {
  const ExplorationScoreScreen({super.key});

  @override
  State<ExplorationScoreScreen> createState() => _ExplorationScoreScreenState();
}

class _ExplorationScoreScreenState extends State<ExplorationScoreScreen> {
  final _scoreService = ExplorationScoreService();

  @override
  void initState() {
    super.initState();
    _calculateScore();
  }

  void _calculateScore() {
    final journeyService = Provider.of<JourneyService>(context, listen: false);
    _scoreService.calculateScore(journeyService.journeys);
  }

  @override
  Widget build(BuildContext context) {
    final journeyService = Provider.of<JourneyService>(context);
    _scoreService.calculateScore(journeyService.journeys);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Exploration Score'),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _calculateScore();
          await Future.delayed(const Duration(milliseconds: 500));
        },
        color: AppColors.berryCrush,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Score Header Card
              _buildScoreHeader(),

              const SizedBox(height: AppSpacing.lg),

              // Level Progress
              _buildLevelProgress(),

              const SizedBox(height: AppSpacing.lg),

              // Score Breakdown
              _buildScoreBreakdown(),

              const SizedBox(height: AppSpacing.lg),

              // Insights
              _buildInsights(journeyService.journeys),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreHeader() {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.berryCrush,
            AppColors.berryCrushDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.berryCrush.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Score icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events,
              size: 48,
              color: AppColors.white,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Total score
          Text(
            _scoreService.totalScore.toString(),
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
              height: 1,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Exploration Points',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Percentile
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.trending_up,
                  size: 18,
                  color: AppColors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  'Top ${100 - _scoreService.getPercentile()}%',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelProgress() {
    final level = _scoreService.getLevel();
    final currentScore = _scoreService.totalScore;
    final nextLevelScore = level.nextLevelScore;

    double progress = 0.0;
    String progressText = 'Max Level!';

    if (nextLevelScore != null) {
      final levelMin = level.minScore;
      final levelRange = nextLevelScore - levelMin;
      final currentProgress = currentScore - levelMin;
      progress = (currentProgress / levelRange).clamp(0.0, 1.0);
      progressText = '${nextLevelScore - currentScore} points to ${ExplorationLevel.values[level.index + 1].displayName}';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                level.icon,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level.displayName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Explorer Level ${level.index + 1}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (nextLevelScore != null) ...[
            const SizedBox(height: AppSpacing.md),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: AppColors.greyLight.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation(AppColors.berryCrush),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              progressText,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScoreBreakdown() {
    final breakdown = _scoreService.scoreBreakdown;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'Score Breakdown',
            style: AppTypography.headline(),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        _ScoreCategory(
          title: 'Distance',
          icon: Icons.directions_walk,
          score: breakdown['distance'] ?? 0,
          maxScore: 300,
          color: AppColors.info,
        ),

        _ScoreCategory(
          title: 'Places Visited',
          icon: Icons.place,
          score: breakdown['places'] ?? 0,
          maxScore: 250,
          color: AppColors.warning,
        ),

        _ScoreCategory(
          title: 'Diversity',
          icon: Icons.explore,
          score: breakdown['diversity'] ?? 0,
          maxScore: 200,
          color: AppColors.berryCrush,
        ),

        _ScoreCategory(
          title: 'Consistency',
          icon: Icons.local_fire_department,
          score: breakdown['consistency'] ?? 0,
          maxScore: 150,
          color: AppColors.error,
        ),

        _ScoreCategory(
          title: 'Exploration Bonus',
          icon: Icons.emoji_events,
          score: breakdown['exploration'] ?? 0,
          maxScore: 100,
          color: AppColors.success,
        ),
      ],
    );
  }

  Widget _buildInsights(List<Journey> journeys) {
    final insights = _scoreService.getInsights(journeys);

    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'Insights & Tips',
            style: AppTypography.headline(),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        ...insights.map((insight) => _InsightCard(insight: insight)),
      ],
    );
  }
}

class _ScoreCategory extends StatelessWidget {
  final String title;
  final IconData icon;
  final int score;
  final int maxScore;
  final Color color;

  const _ScoreCategory({
    required this.title,
    required this.icon,
    required this.score,
    required this.maxScore,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (score / maxScore).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '$score / $maxScore',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.greyLight.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final ScoreInsight insight;

  const _InsightCard({required this.insight});

  IconData _getIcon() {
    switch (insight.icon) {
      case 'directions_walk':
        return Icons.directions_walk;
      case 'explore':
        return Icons.explore;
      case 'place':
        return Icons.place;
      case 'local_fire_department':
        return Icons.local_fire_department;
      default:
        return Icons.lightbulb_outline;
    }
  }

  Color _getColor() {
    switch (insight.category) {
      case 'distance':
        return AppColors.info;
      case 'diversity':
        return AppColors.berryCrush;
      case 'places':
        return AppColors.warning;
      case 'consistency':
        return AppColors.error;
      default:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Container(
      margin: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_getIcon(), size: 24, color: color),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  insight.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '+${insight.potentialPoints}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
