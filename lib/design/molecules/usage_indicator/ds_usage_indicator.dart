import 'package:doc_helper_app/core/utils/number_utils.dart';
import 'package:doc_helper_app/design/design.dart';
import 'package:flutter/material.dart';

class DsUsageIndicator extends StatelessWidget {
  const DsUsageIndicator({
    super.key,
    required this.title,
    required this.currentUsage,
    required this.totalLimit,
    required this.unit,
    this.resetDate,
  });

  final String title;
  final int currentUsage;
  final int totalLimit;
  final String unit;
  final String? resetDate;

  @override
  Widget build(BuildContext context) {
    final percentage = (currentUsage / totalLimit).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: DsSpacing.horizontalSpace4,
          children: [
            Expanded(
              child: DsText.titleMedium(data: title),
            ),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: DsColors.textPrimary),
                children: [
                  TextSpan(
                    text: formatNumberWithSymbol(currentUsage.toDouble()),
                    style: DsTextStyle.bodyMedium.copyWith(
                      color: DsColors.textSecondary,
                    ),
                  ),
                  TextSpan(
                    text: ' / ${formatNumberWithSymbol(totalLimit.toDouble())} $unit',
                    style: DsTextStyle.bodyMedium.copyWith(
                      color: DsColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        DsSpacing.verticalSpaceSizedBox8,
        ClipRRect(
          borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius4),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 6,
            backgroundColor: DsColors.backgroundDisabled,
            valueColor: const AlwaysStoppedAnimation<Color>(
              DsColors.primary,
            ),
          ),
        ),
        DsSpacing.verticalSpaceSizedBox8,
        if (resetDate != null && resetDate!.isNotEmpty)
          DsText.bodySmall(
            data: 'Resets on $resetDate',
            color: DsColors.textSecondary,
          ),
      ],
    );
  }
}
