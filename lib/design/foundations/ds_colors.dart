import 'package:flutter/material.dart';

part 'base_colors.dart';

abstract class DsColors {
  // ==========================================
  // 1. PRIMARY & SECONDARY COLORS
  // ==========================================
  /// Main brand color - purple (used for primary actions, app bars, FABs)
  static const Color primary = _BaseColors.purple600;
  static const Color primaryLight = _BaseColors.purple400;
  static const Color primaryDark = _BaseColors.purple800;

  /// Secondary brand color - teal (complements purple nicely)
  static const Color secondary = _BaseColors.teal600;
  static const Color secondaryLight = _BaseColors.teal400;
  static const Color secondaryDark = _BaseColors.teal800;

  /// Text/icons on primary and secondary colors
  static const Color onPrimary = _BaseColors.white;
  static const Color onSecondary = _BaseColors.white;

  // ==========================================
  // 2. BACKGROUND COLORS
  // ==========================================
  /// Main app background
  static const Color backgroundPrimary = _BaseColors.white;
  static const Color backgroundSurface = _BaseColors.neutral100;

  /// Secondary background (for cards, sections)
  static const Color backgroundSubtle = _BaseColors.purple100;

  /// Success state background (light green tint)
  static const Color backgroundSuccess = _BaseColors.green600;

  /// Warning state background (light orange tint)
  static const Color backgroundWarning = _BaseColors.orange700;

  /// Error/failure state background (light red tint)
  static const Color backgroundError = _BaseColors.red700;

  /// Info state background (light purple tint)
  static const Color backgroundInfo = _BaseColors.purple100;

  /// Disabled state background
  static const Color backgroundDisabled = _BaseColors.neutral200;

  // ==========================================
  // 3. SURFACE COLORS (Cards, Dialogs, Sheets)
  // ==========================================
  static const Color surface = _BaseColors.white;
  static const Color surfaceElevated = _BaseColors.purple100;
  static const Color onSurface = _BaseColors.neutral800;

  // ==========================================
  // 4. TEXT COLORS
  // ==========================================
  /// Primary text (headings, body)
  static const Color textPrimary = _BaseColors.neutral800;

  /// Secondary text (subheadings, captions)
  static const Color textSecondary = _BaseColors.neutral600;

  /// Tertiary text (hints, labels)
  static const Color textTertiary = _BaseColors.neutral500;

  /// Disabled text
  static const Color textDisabled = _BaseColors.neutral400;

  /// Text on dark backgrounds
  static const Color textOnDark = _BaseColors.white;

  /// Link text (purple for brand consistency)
  static const Color textLink = _BaseColors.purple700;

  /// Success message text
  static const Color textSuccess = _BaseColors.green800;

  /// Warning message text
  static const Color textWarning = _BaseColors.orange800;

  /// Error message text
  static const Color textError = _BaseColors.red800;

  /// Accent text (for highlights)
  static const Color textAccent = _BaseColors.purple600;

  // ==========================================
  // 5. BORDER COLORS
  // ==========================================
  static const Color borderDefault = _BaseColors.neutral300;

  static const Color borderSubtle = _BaseColors.neutral200;

  static const Color borderDisabled = _BaseColors.neutral500;

  static const Color borderPrimary = _BaseColors.purple600;

  /// Success border
  static const Color borderSuccess = _BaseColors.green600;

  /// Warning border
  static const Color borderWarning = _BaseColors.orange600;

  /// Error border
  static const Color borderError = _BaseColors.red600;

  /// Info border (purple)
  static const Color borderInfo = _BaseColors.purple600;

  // ==========================================
  // 6. BUTTON COLORS
  // ==========================================
  // Primary Button (Filled - Purple)
  static const Color buttonPrimary = primary;
  static const Color buttonPrimaryHover = primaryDark;
  static const Color buttonPrimaryDisabled = _BaseColors.neutral300;
  static const Color buttonPrimaryText = onPrimary;
  static const Color buttonPrimaryTextDisabled = _BaseColors.neutral500;
  static const Color buttonPrimaryPressed = _BaseColors.purple300;

  // Secondary Button (Outlined - Purple)
  static const Color buttonSecondary = _BaseColors.white;
  static const Color buttonSecondaryBorder = primary;
  static const Color buttonSecondaryText = primary;
  static const Color buttonSecondaryHover = _BaseColors.purple100;
  static const Color buttonSecondaryDisabled = _BaseColors.neutral300;
  static const Color buttonSecondaryPressed = _BaseColors.purple300;
  static const Color buttonSecondaryBorderDisabled = _BaseColors.neutral500;

  // Tertiary Button (Text only - Purple)
  static const Color buttonTertiaryText = primary;
  static const Color buttonTertiaryHover = _BaseColors.purple100;

  // Destructive Button (Red)
  static const Color buttonDestructive = _BaseColors.red600;
  static const Color buttonDestructiveHover = _BaseColors.red700;
  static const Color buttonDestructiveDisabled = _BaseColors.red200;
  static const Color buttonDestructiveText = _BaseColors.white;

  // ==========================================
  // 7. TEXT FIELD COLORS
  // ==========================================
  /// Default text field background
  static const Color textFieldBackground = _BaseColors.white;

  /// Text field text color
  static const Color textFieldText = _BaseColors.neutral800;

  /// Text field border (default/idle state)
  static const Color textFieldBorder = _BaseColors.neutral400;

  /// Text field border when focused (purple for brand consistency)
  static const Color textFieldBorderFocused = primary;

  /// Text field border when hovered
  static const Color textFieldBorderHover = _BaseColors.purple300;

  /// Text field border when disabled
  static const Color textFieldBorderDisabled = _BaseColors.neutral200;

  /// Text field border for error state
  static const Color textFieldBorderError = _BaseColors.red600;

  /// Text field border for success state
  static const Color textFieldBorderSuccess = _BaseColors.green600;

  /// Text field background when disabled
  static const Color textFieldBackgroundDisabled = _BaseColors.neutral100;

  /// Text field text when disabled
  static const Color textFieldTextDisabled = _BaseColors.neutral400;

  /// Text field hint/placeholder color
  static const Color textFieldHint = _BaseColors.neutral500;

  /// Text field cursor color
  static const Color textFieldCursor = primary;

  /// Text field cursor error
  static const Color textFieldCursorError = _BaseColors.red600;

  static const Color textFieldLabel = _BaseColors.neutral700;

  /// Text field label color when focused
  static const Color textFieldLabelFocused = _BaseColors.purple800;

  /// Text field helper text color
  static const Color textFieldHelper = _BaseColors.neutral600;

  /// Text field error text color
  static const Color textFieldErrorText = _BaseColors.red700;

  /// Text field success text color
  static const Color textFieldSuccessText = _BaseColors.green700;

  // ==========================================
  // ICON COLORS
  // ==========================================
  static const Color iconPrimary = _BaseColors.neutral800;
  static const Color iconSecondary = _BaseColors.neutral600;
  static const Color iconDisabled = _BaseColors.neutral400;
  static const Color iconOnPrimary = _BaseColors.white;
  static const Color iconSuccess = _BaseColors.green600;
  static const Color iconWarning = _BaseColors.orange600;
  static const Color iconError = _BaseColors.red600;
  static const Color iconInfo = _BaseColors.blue500;

  // ==========================================
  // SEMANTIC STATE COLORS
  // ==========================================
  static const Color success = _BaseColors.green600;
  static const Color warning = _BaseColors.orange600;
  static const Color error = _BaseColors.red600;
  static const Color info = _BaseColors.purple600;

  // ==========================================
  // UTILITY COLORS
  // ==========================================
  static const Color divider = _BaseColors.neutral200;
  static const Color navigationBarShadow = Color(0x52000000);
  static const Color overlayColor = Color(0x95FFFFFF);
  static const Color transparent = Colors.transparent;
  static const Color white = _BaseColors.white;
  static const Color black = _BaseColors.black;

  // Purple gradient colors (for special effects)
  static const Color gradientStart = _BaseColors.purple600;
  static const Color gradientEnd = _BaseColors.purple800;

  static const Color loadingIndicatorColorPrimary = primary;
}
