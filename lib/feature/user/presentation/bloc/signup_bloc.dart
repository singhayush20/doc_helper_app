import 'package:doc_helper_app/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/common/utils/app_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'signup_event.dart';
part 'signup_state.dart';
part 'signup_bloc.freezed.dart';

@injectable
class SignUpBloc extends BaseBloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpState.initial(store: SignUpStateStore()));

  @override
  void handleEvents() {}

  @override
  void started(Map<String, dynamic>? args) {}
}
