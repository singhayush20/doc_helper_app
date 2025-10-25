part of 'ds_pin_field.dart';

class _BasePinField extends StatelessWidget {
  const _BasePinField({
    super.key,
    this.otp,
    this.enabled = true,
    this.controller,
    this.validator,
    this.onChanged,
    this.onCompleted,
    this.length = 6,
    this.focusNode,
    this.obscureText = false,
  });

  final Otp? otp;
  final bool enabled;
  final ValueChanged<String?>? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onCompleted;
  final int length;
  final FocusNode? focusNode;
  final bool obscureText;

  @override
  Widget build(BuildContext context) => Pinput(
    length: length,
    enabled: enabled,
    controller: controller,
    focusNode: focusNode,
    validator: validator ?? _validateOtp,
    onChanged: onChanged,
    onCompleted: onCompleted,
    obscureText: obscureText,
    obscuringCharacter: '*',
    autofocus: true,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    defaultPinTheme: dsPinTheme.defaultPinTheme,
    focusedPinTheme: dsPinTheme.focusedPinTheme,
    errorPinTheme: dsPinTheme.errorPinTheme,
    submittedPinTheme: dsPinTheme.submittedPinTheme,
    followingPinTheme: dsPinTheme.followingPinTheme,
    disabledPinTheme: dsPinTheme.disabledPinTheme,
    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
    showCursor: true,
  );

  String? _validateOtp(String? value) {
    if (value?.length != length) {
      return 'Please enter valid otp OTP';
    }

    return null;
  }
}
