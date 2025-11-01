part of 'email_verification_page.dart';

class _EmailVerificationForm extends StatelessWidget {
  const _EmailVerificationForm();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<EmailVerificationBloc, EmailVerificationState>(
        builder: (context, state) => Padding(
          padding: EdgeInsets.symmetric(
            vertical: DsSpacing.radialSpace20,
            horizontal: DsSpacing.radialSpace12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: DsSpacing.verticalSpace16,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DsImage(
                mediaUrl: ImageKeys.emailVerificationIllustration,
                height: 150.h,
                fit: BoxFit.contain,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: DsSpacing.verticalSpace4,
                children: [
                  const DsText.titleLarge(data: 'Verify your email address'),
                  const DsText.bodyLarge(
                    data: 'You will receive an OTP on the email you entered',
                  ),
                ],
              ),
              DsPinField(
                otp: state.store.otp,
                onChanged: (newValue) => getBloc<EmailVerificationBloc>(
                  context,
                ).onOtpChanged(otpString: newValue),
              ),
              if ((state.store.timerValue ?? 0) == 0) ...[
                DsTextButton.primary(
                  data: 'Resent OTP',
                  underline: true,
                  onTap: () => getBloc<EmailVerificationBloc>(
                    context,
                  ).onResendOTPPressed(),
                ),
              ] else ...[
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Resend otp in',
                    style: DsTextStyle.titleMedium,
                    children: [
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: formatDuration(state.store.timerValue ?? 0),
                        style: DsTextStyle.titleMedium.copyWith(
                          color: DsColors.textLink,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              DsButton.primary(
                data: 'Verify account',
                onTap: (state.store.otp?.isValid() ?? false)
                    ? () => getBloc<EmailVerificationBloc>(
                        context,
                      ).onVerifyOTPPressed()
                    : null,
              ),
            ],
          ),
        ),
      );
}
