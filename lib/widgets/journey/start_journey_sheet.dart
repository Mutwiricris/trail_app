import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zuritrails/models/journey.dart';
import 'package:zuritrails/services/journey_service.dart';
import 'package:zuritrails/utils/app_colors.dart';
import 'package:zuritrails/utils/app_typography.dart';
import 'package:zuritrails/utils/app_spacing.dart';
import 'package:zuritrails/utils/app_radius.dart';
import 'package:zuritrails/widgets/common/sheets/app_bottom_sheet.dart';

/// Show journey start bottom sheet
Future<Journey?> showStartJourneySheet(BuildContext context) async {
  return await AppBottomSheet.show<Journey>(
    context: context,
    title: 'Start New Journey',
    child: const _StartJourneyForm(),
  );
}

class _StartJourneyForm extends StatefulWidget {
  const _StartJourneyForm();

  @override
  State<_StartJourneyForm> createState() => _StartJourneyFormState();
}

class _StartJourneyFormState extends State<_StartJourneyForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  JourneyType _selectedType = JourneyType.safari;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _startJourney() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final journeyService = Provider.of<JourneyService>(context, listen: false);
      final journey = await journeyService.startJourney(
        title: _titleController.text.trim(),
        type: _selectedType,
      );

      if (mounted) {
        Navigator.pop(context, journey);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting journey: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title input
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Journey Title',
              hintText: 'e.g., Masai Mara Safari',
              prefixIcon: Icon(Icons.edit),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
            textCapitalization: TextCapitalization.words,
          ),

          const SizedBox(height: AppSpacing.lg),

          // Journey type selector
          Text(
            'Journey Type',
            style: AppTypography.label(),
          ),
          const SizedBox(height: AppSpacing.sm),

          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: JourneyType.values.map((type) {
              final isSelected = _selectedType == type;
              return InkWell(
                onTap: () => setState(() => _selectedType = type),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.berryCrush
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.berryCrush
                          : AppColors.greyLight,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        type.icon,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        type.displayName,
                        style: AppTypography.buttonMedium(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Start button
          ElevatedButton(
            onPressed: _isLoading ? null : _startJourney,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(AppColors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Start Journey',
                        style: AppTypography.buttonLarge(),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
