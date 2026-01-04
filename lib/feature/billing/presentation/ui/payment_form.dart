part of 'payment_page.dart';

class _PaymentForm extends StatelessWidget {
  const _PaymentForm();

  @override
  Widget build(BuildContext context) => BlocBuilder<PaymentBloc, PaymentState>(
    builder: (context, state) =>
        DsShimmer(enabled: state.store.loading, child: SizedBox()),
  );
}
