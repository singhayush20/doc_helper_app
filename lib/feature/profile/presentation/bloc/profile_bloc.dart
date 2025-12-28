import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/feature/auth/domain/interfaces/i_auth_facade.dart';
import 'package:doc_helper_app/feature/billing/domain/entities/billing_entity.dart';
import 'package:doc_helper_app/feature/billing/domain/interfaces/i_billing_facade.dart';
import 'package:doc_helper_app/feature/plan/domain/interface/i_usage_facade.dart';
import 'package:doc_helper_app/feature/plan/domain/models/usage_info.dart';
import 'package:doc_helper_app/feature/user/domain/entity/user.dart';
import 'package:doc_helper_app/feature/user/domain/interface/i_user_facade.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'profile_bloc.freezed.dart';

part 'profile_event.dart';

part 'profile_state.dart';

@injectable
class ProfileBloc extends BaseBloc<ProfileEvent, ProfileState> {
  ProfileBloc(
    this._userFacade,
    this._authFacade,
    this._usageFacade,
    this._billingFacade,
  ) : super(const ProfileState.initial(store: ProfileStateStore()));

  final IUserFacade _userFacade;
  final IAuthFacade _authFacade;
  final IUsageFacade _usageFacade;
  final IBillingFacade _billingFacade;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_OnLogoutPressed>(_onLogoutPressed);
    on<_OnResetPasswordPressed>(_onResetPasswordPressed);
  }

  Future<void> _onStarted(_, Emitter<ProfileState> emit) async {
    invalidateLoader(emit, loading: true);

    Either<ServerException, AppUser?>? userInfoOrFailure;
    Either<ServerException, UsageInfo?>? usageInfoOrFailure;
    Either<ServerException, SubscriptionResponse?>? subscriptionInfoOrFailure;

    await Future.wait([
      (() async => userInfoOrFailure = await _userFacade.getUserInfo())(),
      (() async => usageInfoOrFailure = await _usageFacade.getUsageInfo())(),
      (() async => subscriptionInfoOrFailure = await _billingFacade
          .getCurrentSubscriptionDetails())(),
    ]);

    userInfoOrFailure?.fold((exception) => handleException(emit, exception), (
      userInfo,
    ) {
      emit(
        ProfileState.onUserInfoFetch(
          store: state.store.copyWith(
            userInfo: userInfo,
            usageInfo: usageInfoOrFailure?.getOrElse(() => null),
            subscriptionInfo: subscriptionInfoOrFailure?.getOrElse(() => null),
            loading: false,
          ),
        ),
      );
    });
  }

  Future<void> _onLogoutPressed(_, Emitter<ProfileState> emit) async {
    invalidateLoader(emit, loading: true);
    final signOutResponseOrFailure = await _authFacade.signOut();
    signOutResponseOrFailure.fold(
      (exception) => handleException(emit, exception),
      (_) => emit(
        ProfileState.onLogout(store: state.store.copyWith(loading: false)),
      ),
    );
  }

  void _onResetPasswordPressed(_, Emitter<ProfileState> emit) {
    invalidateLoader(emit, loading: false);
    emit(ProfileState.onResetPasswordPress(store: state.store));
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const ProfileEvent.started());
  }

  void onLogoutPressed() {
    add(const ProfileEvent.onLogoutPressed());
  }

  void onPasswordResetPressed() =>
      add(const ProfileEvent.onResetPasswordPressed());
}
