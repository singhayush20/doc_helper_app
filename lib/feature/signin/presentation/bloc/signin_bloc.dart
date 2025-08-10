import 'package:doc_helper_app/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/common/utils/app_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'signin_bloc.freezed.dart';
part 'signin_event.dart';
part 'signin_state.dart';

@injectable
class SignInBloc extends BaseBloc<SignInEvent, SignInState> {
  SignInBloc() : super(const SignInState.initial(store: SignInStateStore()));

  @override
  void handleEvents() {
    // TODO: implement handleEvents
  }

  @override
  void started({Map<String, dynamic>? args}) {
    // TODO: implement started
  }
}
