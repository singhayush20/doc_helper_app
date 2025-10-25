part of 'signup_page.dart';

class _SignUpForm extends StatelessWidget {
  const _SignUpForm();

  @override
  Widget build(BuildContext context) => BlocBuilder<SignUpBloc, SignUpState>(
    builder: (context, state) => SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: DsSpacing.radialSpace20,
          horizontal: DsSpacing.radialSpace16,
        ),
        child: (state.store.userDetailsEntered)
            ? const _EmailVerificationForm()
            : const _UserDetailsForm(),
      ),
    ),
  );
}

class _EmailVerificationForm extends StatelessWidget {
  const _EmailVerificationForm();

  @override
  Widget build(BuildContext context) => BlocBuilder<SignUpBloc, SignUpState>(
    builder: (context, state) => Column(
      mainAxisSize: MainAxisSize.min,
      spacing: DsSpacing.verticalSpace12,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DsImage(
          mediaUrl: ImageKeys.emailVerificationIllustration,
          height: 150.h,
          fit: BoxFit.contain,
        ),
        const DsText.titleLarge(data: 'Verify your email address'),
        const DsText.bodyLarge(
          data: 'You will receive an OTP on the email you entered',
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DsPinField(
              otp: state.store.otp,
              onChanged: (newValue) => getBloc<SignUpBloc>(
                context,
              ).onOtpChanged(otpString: newValue),
            ),
            if ((state.store.timerValue ?? 0) == 0) ...[
              DsTextButton.primary(
                data: 'Resent OTP',
                underline: true,
                onTap: () => getBloc<SignUpBloc>(context).onResendOTPPressed(),
              ),
            ] else ...[
              RichText(
                text: TextSpan(
                  text: 'Resend otp in',
                  style: DsTextStyle.bodySmall,
                  children: [
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: formatDuration(state.store.timerValue ?? 0),
                      style: DsTextStyle.bodyBoldSmall.copyWith(
                        color: DsColors.textLink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        DsButton.primary(
          data: 'Verify account',
          onTap: (state.store.otp?.isValid() ?? false)
              ? () => getBloc<SignUpBloc>(context).onVerifyOTPPressed()
              : null,
        ),
      ],
    ),
  );
}

class _UserDetailsForm extends StatelessWidget {
  const _UserDetailsForm();

  @override
  Widget build(BuildContext context) => BlocBuilder<SignUpBloc, SignUpState>(
    builder: (context, state) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: DsSpacing.radialSpace24,
      children: [
        const DsText.titleSmall(data: 'Create an account to get started'),
        Column(
          spacing: DsSpacing.radialSpace20,
          mainAxisSize: MainAxisSize.min,
          children: [
            NameTextFormField(
              value: state.store.firstName,
              onChanged: (value) => getBloc<SignUpBloc>(
                context,
              ).onFirstNameChanged(firstNameString: value),
              labelText: 'First Name',
              errorText: 'First name cannot be a single letter!',
              hintText: 'Enter your first name',
              prefixIcon: Icons.person,
            ),

            NameTextFormField(
              value: state.store.lastName,
              onChanged: (value) => getBloc<SignUpBloc>(
                context,
              ).onLastNameChanged(lastNameString: value),
              labelText: 'Last Name',
              errorText: 'Last name cannot be a single letter!',
              hintText: 'Enter your last name',
              prefixIcon: Icons.person_2,
            ),

            EmailTextFormField(
              value: state.store.email,
              onChanged: (value) => getBloc<SignUpBloc>(
                context,
              ).onEmailChanged(emailString: value),
              labelText: 'Email',
              errorText: 'Enter a valid email id!',
              hintText: 'Enter your email',
              prefixIcon: Icons.email,
            ),

            PasswordTextFormField(
              value: state.store.password,
              onChanged: (value) => getBloc<SignUpBloc>(
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
                onPressed: () =>
                    getBloc<SignUpBloc>(context).onPasswordVisibilityChanged(),
              ),
              prefixIcon: Icons.lock,
            ),

            PasswordTextFormField(
              value: state.store.confirmPassword,
              onChanged: (value) => getBloc<SignUpBloc>(
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
                onPressed: () =>
                    getBloc<SignUpBloc>(context).onPasswordVisibilityChanged(),
              ),
              prefixIcon: Icons.lock,
              formFieldValidator: (value) {
                final result = state.store.password?.input == value?.input;
                return result ? null : 'Passwords do not match!';
              },
            ),
          ],
        ),
        DsButton.primary(
          data: 'Sign Up',
          onTap: _isFormValid(state)
              ? () => getBloc<SignUpBloc>(context).onCreateAccountClicked()
              : null,
        ),

        _FooterWidget(),
      ],
    ),
  );

  bool _isFormValid(SignUpState state) =>
      (state.store.firstName?.input.isNotEmpty ?? false) &&
      (state.store.lastName?.input.isNotEmpty ?? false) &&
      (state.store.email?.input.isNotEmpty ?? false) &&
      (state.store.password?.input.isNotEmpty ?? false) &&
      (state.store.confirmPassword?.input.isNotEmpty ?? false) &&
      (state.store.firstName?.isValid() ?? false) &&
      (state.store.lastName?.isValid() ?? false) &&
      (state.store.email?.isValid() ?? false) &&
      (state.store.password?.isValid() ?? false) &&
      (state.store.confirmPassword?.isValid() ?? false);
}

class _FooterWidget extends StatelessWidget {
  _FooterWidget();

  final _tapGestureRecognizer = TapGestureRecognizer();

  @override
  Widget build(BuildContext context) => RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      text: 'Already have an account?',
      style: DsTextStyle.bodySmall.copyWith(color: DsColors.textPrimary),
      children: [
        const TextSpan(text: ' '),
        TextSpan(
          text: 'Sign In',
          style: DsTextStyle.bodyBoldSmall.copyWith(
            color: DsColors.textLink,
            decoration: TextDecoration.underline,
          ),
          recognizer: _tapGestureRecognizer
            ..onTap = () => getBloc<SignUpBloc>(context).onSignInPressed(),
        ),
      ],
    ),
  );
}
