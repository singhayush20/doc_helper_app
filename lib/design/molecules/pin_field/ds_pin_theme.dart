import 'package:doc_helper_app/design/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class DsPinTheme {
  DsPinTheme({
    PinTheme? focusedPinTheme,
    PinTheme? defaultPinTheme,
    PinTheme? disabledPinTheme,
    PinTheme? errorPinTheme,
    PinTheme? followingPinTheme,
    PinTheme? submittedPinTheme,
  }) : defaultPinTheme = defaultPinTheme ?? _defaultPinTheme,
       followingPinTheme = followingPinTheme ?? _defaultPinTheme,
       focusedPinTheme =
           focusedPinTheme ??
           _defaultPinTheme.copyWith(
             decoration: _defaultPinTheme.decoration!.copyWith(
               border: Border.all(
                 color: DsColors.borderPrimary,
                 width: DsBorderWidth.borderWidth2,
               ),
             ),
           ),
       submittedPinTheme =
           submittedPinTheme ??
           _defaultPinTheme.copyWith(
             decoration: _defaultPinTheme.decoration!.copyWith(
               border: Border.all(
                 color: DsColors.borderPrimary,
                 width: DsBorderWidth.borderWidth1,
               ),
             ),
           ),
       disabledPinTheme =
           disabledPinTheme ??
           _defaultPinTheme.copyWith(
             decoration: _defaultPinTheme.decoration!.copyWith(
               color: DsColors.backgroundDisabled,
               border: Border.all(
                 color: DsColors.borderDisabled,
                 width: DsBorderWidth.borderWidth1,
               ),
             ),
           ),
       errorPinTheme =
           errorPinTheme ??
           _defaultPinTheme.copyWith(
             decoration: _defaultPinTheme.decoration!.copyWith(
               border: Border.all(
                 color: DsColors.borderError,
                 width: DsBorderWidth.borderWidth2,
               ),
             ),
           );

  final PinTheme focusedPinTheme;
  final PinTheme defaultPinTheme;
  final PinTheme disabledPinTheme;
  final PinTheme errorPinTheme;
  final PinTheme followingPinTheme;
  final PinTheme submittedPinTheme;

  static final PinTheme _defaultPinTheme = PinTheme(
    height: 48.r,
    width: 48.r,
    textStyle: DsTextStyle.bodyLarge.copyWith(color: DsColors.textPrimary),
    padding: EdgeInsets.zero,
    margin: EdgeInsets.symmetric(horizontal: DsSpacing.radialSpace4),
    decoration: BoxDecoration(
      color: DsColors.backgroundPrimary,
      border: Border.all(
        color: DsColors.borderDefault,
        width: DsBorderWidth.borderWidth1,
      ),
      borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius8),
    ),
  );
}

final dsPinTheme = DsPinTheme();
