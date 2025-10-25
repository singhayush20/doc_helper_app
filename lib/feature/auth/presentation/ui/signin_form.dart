part of 'sign_in_page.dart';

class _SignInForm extends StatelessWidget {
  const _SignInForm();

  @override
  Widget build(BuildContext context) => BlocBuilder<SignInBloc, SignInState>(
    builder: (context, state) => SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DsSpacing.radialSpace16,
          vertical: DsSpacing.radialSpace24,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  DsBorderRadius.borderRadius22,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: DsImage(mediaUrl: ImageKeys.docHelperLogo, height: 200.h),
            ),
            const DsText.titleLarge(data: 'DocuHelper'),
            DsSpacing.verticalSpaceSizedBox24,
            Column(
              spacing: DsSpacing.verticalSpace16,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const DsText.titleSmall(data: 'Login to your account'),
                Column(
                  spacing: DsSpacing.verticalSpace16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EmailTextFormField(
                      value: state.store.email,
                      prefixIcon: Icons.email,
                      labelText: 'Email Address',
                      hintText: 'Enter your email address',
                      errorText: 'Enter a valid email id!',
                      onChanged: (value) => getBloc<SignInBloc>(
                        context,
                      ).onEmailChanged(emailString: value),
                    ),
                    PasswordTextFormField(
                      value: state.store.password,
                      prefixIcon: Icons.password,
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      onChanged: (value) => getBloc<SignInBloc>(
                        context,
                      ).onPasswordChanged(passwordString: value),
                      errorText: 'Password must be minimum 6 characters long!',
                      suffixIconWidget: IconButton(
                        icon: state.store.isPasswordVisible
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: () => getBloc<SignInBloc>(
                          context,
                        ).onPasswordVisibilityChanged(),
                      ),
                      obscureText: !state.store.isPasswordVisible,
                    ),
                  ],
                ),
                DsButton.primary(
                  data: 'Sign In',
                  onTap:
                      (_enableNextButton(
                            email: state.store.email,
                            password: state.store.password,
                          )) &&
                          !state.store.loading
                      ? () => getBloc<SignInBloc>(context).onLoginPressed()
                      : null,
                ),
              ],
            ),
            _FooterButtons(),
          ],
        ),
      ),
    ),
  );

  bool _enableNextButton({EmailAddress? email, Password? password}) =>
      (email?.input.isNotEmpty ?? false) &&
      (password?.input.isNotEmpty ?? false) &&
      (email?.isValid() ?? false) &&
      (password?.isValid() ?? false);
}

class _FooterButtons extends StatelessWidget {
  _FooterButtons();

  final _tapRecognizer = TapGestureRecognizer();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      RichText(
        text: TextSpan(
          text: 'New User?',
          style: DsTextStyle.bodySmall,
          children: [
            const TextSpan(text: ' '),
            TextSpan(
              text: 'Sign Up',
              style: DsTextStyle.bodyBoldSmall.copyWith(
                color: DsColors.textLink,
              ),
              recognizer: _tapRecognizer
                ..onTap = () => getBloc<SignInBloc>(context).onSignUpPressed(),
            ),
          ],
        ),
      ),
      const Spacer(),
      DsTextButton.primary(
        data: 'Forgot Password?',
        onTap: () => getBloc<SignInBloc>(context).onForgotPasswordPressed(),
        underline: false,
      ),
    ],
  );
}
