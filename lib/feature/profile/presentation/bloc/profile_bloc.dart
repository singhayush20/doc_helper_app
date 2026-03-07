import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/core/global_store/global_state_impl.dart';
import 'package:doc_helper_app/core/global_store/global_store.dart';
import 'package:doc_helper_app/feature/auth/domain/interfaces/i_auth_facade.dart';
import 'package:doc_helper_app/feature/billing/domain/entities/billing_entity.dart';
import 'package:doc_helper_app/feature/features_page/domain/entity/features.dart';
import 'package:doc_helper_app/feature/plan/domain/models/usage_info.dart';
import 'package:doc_helper_app/feature/user/domain/entity/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'profile_bloc.freezed.dart';

part 'profile_event.dart';

part 'profile_state.dart';

@injectable
class ProfileBloc extends BaseBloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._authFacade)
    : super(const ProfileState.initial(store: ProfileStateStore())) {
    _globalStoreSubscription = globalState.globalStoreStream.listen(
      _globalStoreUpdated,
    );
  }

  final IAuthFacade _authFacade;

  StreamSubscription<GlobalStore>? _globalStoreSubscription;

  @override
  void handleEvents() {
    on<_Started>(_onStarted);
    on<_OnLogoutPressed>(_onLogoutPressed);
    on<_OnResetPasswordPressed>(_onResetPasswordPressed);
    on<_OnManageSubscriptionTapped>(_onManageSubscriptionTapped);
    on<_OnGlobalStoreUpdated>(_onGlobalStoreUpdated);
    on<_OnProfileRefreshed>(_onProfileRefreshed);
  }

  Future<void> _onStarted(_, Emitter<ProfileState> emit) async {
    emit(
      ProfileState.onUserInfoFetch(
        store: state.store.copyWith(
          userInfo: globalState.store.userInfo,
          usageInfo: globalState.store.usageInfo,
          subscriptionInfo: globalState.store.subscriptionResponse,
          productFeaturesUsageInfo: globalState.store.productFeaturesUsageInfo,
          loading: false,
        ),
      ),
    );
  }

  Future<void> _onLogoutPressed(_, Emitter<ProfileState> emit) async {
    invalidateLoader(emit, loading: true);
    final signOutResponseOrFailure = await _authFacade.signOut();
    signOutResponseOrFailure.fold(
      (exception) => handleException(emit, exception),
      (_) {
        globalState.clear();
        emit(
          ProfileState.onLogout(store: state.store.copyWith(loading: false)),
        );
      },
    );
  }

  void _onResetPasswordPressed(_, Emitter<ProfileState> emit) {
    invalidateLoader(emit, loading: false);
    emit(ProfileState.onResetPasswordPress(store: state.store));
  }

  void _onManageSubscriptionTapped(_, Emitter<ProfileState> emit) {
    invalidateLoader(emit, loading: false);
    emit(ProfileState.onManageSubscriptionTap(store: state.store));
  }

  void _onGlobalStoreUpdated(_, Emitter<ProfileState> emit) {
    emit(
      ProfileState.onGlobalStoreUpdate(
        store: state.store.copyWith(
          userInfo: globalState.store.userInfo,
          usageInfo: globalState.store.usageInfo,
          subscriptionInfo: globalState.store.subscriptionResponse,
        ),
      ),
    );
  }

  Future<void> _onProfileRefreshed(_, Emitter<ProfileState> emit) async {
    invalidateLoader(emit, loading: false);
    final userDataOrFailure = await globalState.fetchUserData();
    userDataOrFailure.fold(
      (exception) => handleException(emit, exception),
      (_) => emit(
        ProfileState.onProfileRefreshed(
          store: state.store.copyWith(
            userInfo: globalState.store.userInfo,
            usageInfo: globalState.store.usageInfo,
            subscriptionInfo: globalState.store.subscriptionResponse,
            productFeaturesUsageInfo: globalState.store.productFeaturesUsageInfo,
            loading: false,
          ),
        ),
      ),
    );
  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const ProfileEvent.started());
  }

  @override
  Future<void> close() async {
    await _globalStoreSubscription?.cancel();
    super.close();
  }

  void onLogoutPressed() {
    add(const ProfileEvent.onLogoutPressed());
  }

  void onPasswordResetPressed() =>
      add(const ProfileEvent.onResetPasswordPressed());

  void onManageSubscriptionTapped() =>
      add(const ProfileEvent.onManageSubscriptionTapped());

  void _globalStoreUpdated(GlobalStore updatedStore) {
    add(ProfileEvent.onGlobalStoreUpdated(store: updatedStore));
  }

  void onProfileRefreshed() {
    add(const ProfileEvent.onProfileRefreshed());
  }
}
