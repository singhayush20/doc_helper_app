part of 'splash_page.dart';

class _SplashForm extends StatelessWidget {
  const _SplashForm();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [DsColors.gradientEnd, DsColors.gradientStart],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Container(
              padding: EdgeInsets.all(DsSpacing.radialSpace24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  DsBorderRadius.borderRadius22,
                ),
                gradient: const LinearGradient(
                  colors: [DsColors.primaryLight, DsColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.description_outlined,
                color: DsColors.onPrimary,
                size: 64.sp,
              ),
            ),
            DsSpacing.verticalSpaceSizedBox24,
            const DsText.titleLarge(
              data: 'DocuHelper',
              color: DsColors.textOnDark,
            ),
            DsSpacing.verticalSpaceSizedBox8,
            const DsText.bodyLarge(
              data: 'Your AI-powered document assistant.',
              color: DsColors.textOnDark,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _CustomDot(),
                DsSpacing.horizontalSpaceSizedBox8,
                const _CustomDot(),
                DsSpacing.horizontalSpaceSizedBox8,
                const _CustomDot(),
              ],
            ),
            DsSpacing.verticalSpaceSizedBox48,
          ],
        ),
      ),
    ),
  );
}

class _CustomDot extends StatelessWidget {
  const _CustomDot();

  @override
  Widget build(BuildContext context) => Container(
    width: 8.r,
    height: 8.r,
    decoration: BoxDecoration(
      color: DsColors.white.withAlpha(50),
      shape: BoxShape.circle,
    ),
  );
}
