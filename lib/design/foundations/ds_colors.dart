import 'dart:ui';

part 'base_colors.dart';

abstract class DsColors {
  // --- Core Brand Colors ---
  static const Color primary = _BaseColors.blue500;
  static const Color primaryLight = _BaseColors.blue300;
  static const Color primaryDark = _BaseColors.blue700;
  static const Color onPrimary = _BaseColors.white;

  static const Color secondary = _BaseColors.purple500;
  static const Color secondaryLight = _BaseColors.purple300;
  static const Color secondaryDark = _BaseColors.purple700;
  static const Color onSecondary = _BaseColors.white;

  static const Color accent = _BaseColors.teal500;
  static const Color onAccent = _BaseColors.white;

  // --- Background Colors ---
  static const Color backgroundPrimary = _BaseColors.white;
  static const Color backgroundSecondary = _BaseColors.neutral100;
  static const Color backgroundDark = _BaseColors.neutral800;
  static const Color backgroundInverse = _BaseColors.neutral800;

  // --- Surface Colors (for cards, dialogs, sheets) ---
  static const Color surfacePrimary = _BaseColors.white;
  static const Color surfaceSecondary = _BaseColors.neutral100;
  static const Color surfaceInverse = _BaseColors.neutral700;

  // --- Text Colors ---
  static const Color textPrimary = _BaseColors.neutral800;
  static const Color textSecondary = _BaseColors.neutral700;
  static const Color textTertiary = _BaseColors.neutral500;
  static const Color textDisabled = _BaseColors.neutral400;
  static const Color textHint = _BaseColors.neutral400;
  static const Color textOnDark = _BaseColors.white;
  static const Color textOnDarkSecondary = _BaseColors.neutral300;
  static const Color textLink = _BaseColors.blue600;

  // --- Icon Colors ---
  static const Color iconPrimary = _BaseColors.black;
  static const Color iconSecondary = _BaseColors.neutral500;
  static const Color iconDisabled = _BaseColors.neutral400;
  static const Color iconOnDark = _BaseColors.neutral200;

  // --- Button Colors ---
  // Primary Button
  static const Color buttonPrimaryBackground = primary;
  static const Color buttonPrimaryText = onPrimary;
  static const Color buttonPrimaryBackgroundDisabled = _BaseColors.neutral300;
  static const Color buttonPrimaryTextDisabled = _BaseColors.neutral500;

  // Secondary Button (Outlined)
  static const Color buttonSecondaryBorder = primary;
  static const Color buttonSecondaryText = primary;
  static const Color buttonSecondaryBorderDisabled = _BaseColors.neutral400;
  static const Color buttonSecondaryTextDisabled = _BaseColors.neutral400;

  // Destructive Action Button
  static const Color buttonDestructiveBackground = _BaseColors.red500;
  static const Color buttonDestructiveText = _BaseColors.white;
  static const Color buttonDestructiveBackgroundDisabled = _BaseColors.red200;
  static const Color buttonDestructiveTextDisabled = _BaseColors.red400;

  // --- Border Colors ---
  // General/Default Borders
  static const Color borderDefault = _BaseColors.neutral300;
  static const Color borderSubtle = _BaseColors.neutral200;
  static const Color borderStrong = _BaseColors.neutral500;

  // Input Field Borders
  static const Color borderInput = _BaseColors.neutral400;
  static const Color borderInputFocused = primary;
  static const Color borderInputDisabled = _BaseColors.neutral200;

  // Stateful Borders
  static const Color borderEnabled = _BaseColors.neutral400;
  static const Color borderDisabled = _BaseColors.neutral200;
  static const Color borderHover = primaryLight;
  static const Color borderFocused = primary;

  static const Color borderSuccess = _BaseColors.green600;
  static const Color borderWarning = _BaseColors.orange500;
  static const Color borderCritical = _BaseColors.red600;
  static const Color borderInfo = _BaseColors.blue500;

  // --- Semantic State Colors (Backgrounds/Fills) ---
  static const Color stateBackgroundSuccess = _BaseColors.green100;
  static const Color stateTextSuccess = _BaseColors.green800;
  static const Color stateIconSuccess = _BaseColors.green700;

  static const Color stateBackgroundWarning = _BaseColors.orange100;
  static const Color stateTextWarning = _BaseColors.orange800;
  static const Color stateIconWarning = _BaseColors.orange700;

  static const Color stateBackgroundCritical = _BaseColors.red100;
  static const Color stateTextCritical = _BaseColors.red800;
  static const Color stateIconCritical = _BaseColors.red700;

  static const Color stateBackgroundInfo = _BaseColors.blue100;
  static const Color stateTextInfo = _BaseColors.blue800;
  static const Color stateIconInfo = _BaseColors.blue700;

  static const Color stateBackgroundDisabled = _BaseColors.neutral200;
  static const Color stateTextMuted = _BaseColors.neutral500;

  // --- Text Field Colors ---
  static const Color textFieldBackground = _BaseColors.white;
  static const Color textFieldBackgroundHover = _BaseColors.neutral100;
  static const Color textFieldBackgroundDisabled = _BaseColors.neutral200;
  static const Color textFieldText = _BaseColors.neutral800;
  static const Color textFieldTextDisabled = _BaseColors.neutral400;
  static const Color textFormFieldCursorColor = _BaseColors.neutral800;

  // --- Other UI Elements ---
  static const Color divider = _BaseColors.neutral200;
}
