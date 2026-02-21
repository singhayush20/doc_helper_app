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
  });

  final String label;
  final List<T> options;
  final T selectedOption;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: DsSpacing.verticalSpace12,
    children: [
      DsText.labelMedium(data: label, color: DsColors.textTertiary),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: DsSpacing.radialSpace8,
          children: options.map((option) {
            final isSelected = option == selectedOption;
            return ChoiceChip(
              label: Text(option.name.toUpperCase()),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) onSelected(option);
              },
              selectedColor: DsColors.primary,
              backgroundColor: DsColors.backgroundSurface,
              labelStyle: TextStyle(
                color: isSelected
                    ? DsColors.textOnDark
                    : DsColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  DsBorderRadius.borderRadius12,
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
