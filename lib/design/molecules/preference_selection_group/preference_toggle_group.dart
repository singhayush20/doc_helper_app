import 'package:doc_helper_app/design/atoms/typography/ds_text.dart';
import 'package:doc_helper_app/design/foundations/ds_border_radius.dart';
import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:doc_helper_app/design/foundations/ds_spacing.dart';
import 'package:flutter/material.dart';

class PreferenceToggleGroup<T extends Enum> extends StatelessWidget {
  const PreferenceToggleGroup({
    super.key,
    required this.label,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
    this.icon,
  });

  final String label;
  final List<T> options;
  final T selectedOption;
  final ValueChanged<T> onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: DsSpacing.verticalSpace12,
    children: [
      Row(
        spacing: DsSpacing.horizontalSpace8,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: 16,
              color: DsColors.primary,
            ),
          DsText.labelMedium(data: label, color: DsColors.textTertiary),
        ],
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: DsSpacing.radialSpace8,
          children: options.map((option) {
            final isSelected = option == selectedOption;
            return ChoiceChip(
              label: Text(
                option.name[0].toUpperCase() + option.name.substring(1),
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) onSelected(option);
              },
              selectedColor: DsColors.white,
              backgroundColor: DsColors.backgroundSurface,
              labelStyle: TextStyle(
                color: isSelected ? DsColors.primary : DsColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  DsBorderRadius.borderRadius8,
                ),
                side: BorderSide(
                  color: isSelected ? DsColors.primary : DsColors.borderSubtle,
                ),
              ),
              showCheckmark: false,
            );
          }).toList(),
        ),
      ),
    ],
  );
}
