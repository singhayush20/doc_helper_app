part of 'password_reset_page.dart';

class _PasswordResetForm extends StatelessWidget {
  const _PasswordResetForm();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PasswordResetBloc, PasswordResetState>(
        builder: (context, state) => SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DsSpacing.radialSpace16,
              vertical: DsSpacing.radialSpace24,
            ),
            child: (state.store.otpSent)
                ? const _OtpVerificationForm()
                : const _EmailEntryForm(),
          ),
        ),
      );
}

class _OtpVerificationForm extends StatelessWidget {
  const _OtpVerificationForm();

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<PasswordResetBloc, PasswordResetState>(
    builder: (context, state) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: DsSpacing.verticalSpace24,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          spacing: DsSpacing.verticalSpace12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DsText.titleLarge(data: 'Create new password'),
            const DsText.bodyLarge(
              data:
                  '''Verify the OTP sent to your email and create new password''',
            ),
          ],
        ),
        Column(
          spacing: DsSpacing.verticalSpace12,
          children: [
            DsPinField(
              otp: state.store.otp,
              onChanged: (newValue) => getBloc<PasswordResetBloc>(
                context,
              ).onOTPChanged(otpString: newValue),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if ((state.store.timerValue ?? 0) > 0) ...[
                  DsText.bodySmall(
                    data:
                        '''Resend OTP in ${formatDuration(state.store.timerValue ?? 0)}''',
                    color: DsColors.textSecondary,
                  ),
                ] else ...[
                  DsTextButton.primary(
                    data: 'Resend OTP',
                    onTap: () =>
                        getBloc<PasswordResetBloc>(context).onSendOtpPressed(),
                    underline: false,
                  ),
                ],
              ],
            ),
          ],
        ),
        PasswordTextFormField(
          value: state.store.password,
          onChanged: (value) => getBloc<PasswordResetBloc>(
            context,
          ).onPasswordChanged(passwordString: value),
          labelText: 'Password',
          hintText: 'Enter your password',
          obscureText: !state.store.isPasswordVisible,
          errorText:
              '''Password must be minimum 8 characters long with at least one special character and one Uppercase alphabet!''',
          suffixIconWidget: IconButton(
            icon: Icon(
              state.store.isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            onPressed: () => getBloc<PasswordResetBloc>(
              context,
            ).onPasswordVisibilityChanged(),
          ),
          prefixIcon: Icons.lock,
        ),
        PasswordTextFormField(
          value: state.store.confirmPassword,
          onChanged: (value) => getBloc<PasswordResetBloc>(
            context,
          ).onConfirmPasswordChanged(passwordString: value),
          labelText: 'Confirm Password',
          hintText: 'Confirm your password',
          errorText:
              '''Password must be minimum 8 characters long with at least one special character and one Uppercase alphabet!''',
          obscureText: !state.store.isPasswordVisible,
          suffixIconWidget: IconButton(
            icon: Icon(
              state.store.isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            onPressed: () => getBloc<PasswordResetBloc>(
              context,
            ).onPasswordVisibilityChanged(),
          ),
          prefixIcon: Icons.lock,
          formFieldValidator: (value) {
            final result = state.store.password?.input == value?.input;
            return result ? null : 'Passwords do not match!';
          },
        ),
        DsButton.primary(
          data: 'Verify and save password',
          onTap:
              _enableSaveButton(
                otp: state.store.otp,
                password: state.store.password,
                confirmPassword: state.store.confirmPassword,
              )
              ? () =>
                    getBloc<PasswordResetBloc>(context).onSavePasswordPressed()
              : null,
        ),
        const _FooterWidget(),
      ],
    ),
  );

  bool _enableSaveButton({
    required Password? password,
    required Password? confirmPassword,
    required Otp? otp,
  }) =>
      (otp?.isValid() ?? false) &&
      (password?.isValid() ?? false) &&
      (confirmPassword?.isValid() ?? false) &&
      (password?.input == confirmPassword?.input);
}

class _EmailEntryForm extends StatelessWidget {
  const _EmailEntryForm();

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<PasswordResetBloc, PasswordResetState>(
    builder: (context, state) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: DsSpacing.verticalSpace24,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          spacing: DsSpacing.verticalSpace12,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DsImage(
              mediaUrl: ImageKeys.passwordResetIllustration,
              height: 150.h,
              fit: BoxFit.contain,
            ),
            const DsText.titleLarge(data: 'Enter your Email'),
            const DsText.bodyLarge(
              data:
                  '''If your email is registered, you will receive a verification otp.''',
            ),
          ],
        ),
        EmailTextFormField(
          value: state.store.email,
          prefixIcon: Icons.email,
          labelText: 'Email Address',
          hintText: 'Enter your email address',
          errorText: 'Enter a valid email id!',
          onChanged: (value) => getBloc<PasswordResetBloc>(
            context,
          ).onEmailChanged(emailString: value),
        ),
        DsButton.primary(
          data: 'Send OTP',
          onTap: (state.store.email?.isValid() ?? false)
              ? () => getBloc<PasswordResetBloc>(context).onSendOtpPressed()
              : null,
        ),
      ],
    ),
  );
}

class _FooterWidget extends StatefulWidget {
  const _FooterWidget();

  @override
  State<_FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<_FooterWidget> {
  final _tapGestureRecognizer = TapGestureRecognizer();

  @override
  Widget build(BuildContext context) => RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      text: 'Entered wrong email?',
      style: DsTextStyle.titleMedium.copyWith(color: DsColors.textPrimary),
      children: [
        const TextSpan(text: ' '),
        TextSpan(
          text: 'Change',
          style: DsTextStyle.titleMedium.copyWith(
            color: DsColors.textLink,
            decoration: TextDecoration.underline,
          ),
          recognizer: _tapGestureRecognizer
            ..onTap = () =>
                getBloc<PasswordResetBloc>(context).onChangeEmailPressed(),
        ),
      ],
    ),
  );

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }
}
