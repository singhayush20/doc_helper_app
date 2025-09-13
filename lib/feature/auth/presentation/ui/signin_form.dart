part of 'sign_in_page.dart';

class _SignInForm extends StatelessWidget {
  const _SignInForm();

  @override
  Widget build(BuildContext context) => BlocBuilder<SignInBloc, SignInState>(
    builder: (context, state) => SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DsSpacing.radialSpace16,
          vertical: DsSpacing.radialSpace20,
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
              child: DsImage(mediaUrl: ImageKeys.docHelper, height: 150.h),
            ),
            const DsText.titleMedium(data: 'Doc Assistant'),
            DsSpacing.verticalSpaceSizedBox24,
            Column(
              spacing: DsSpacing.verticalSpace16,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const DsText.titleSmall(data: 'Login to your account'),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      DsBorderRadius.borderRadius8,
                    ),
                    border: Border.all(
                      color: DsColors.borderStrong,
                      width: DsBorderWidth.borderWidth2,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(DsSpacing.radialSpace16),
                    child: Column(
                      spacing: DsSpacing.verticalSpace16,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          errorText:
                              'Password must be minimum 6 characters long!',
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
                  ),
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
            Row(
              children: [
                DsTextButton.primary(
                  data: 'New user? Sign Up!',
                  onTap: () => getBloc<SignInBloc>(context).onSignUpPressed(),
                  underline: true,
                ),
                const Spacer(),
                DsTextButton.primary(
                  data: 'Forgot Password?',
                  onTap: () =>
                      getBloc<SignInBloc>(context).onForgotPasswordPressed(),
                  underline: true,
                ),
              ],
            ),
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
