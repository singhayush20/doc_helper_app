part of 'splash_page.dart';

class _SplashForm extends StatelessWidget {
  const _SplashForm({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: Center(child: DsText.titleLarge(data: 'Doc Helper')),
  );
}
