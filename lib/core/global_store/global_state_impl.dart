import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/common/constants/enums.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/core/global_store/global_store.dart';
import 'package:doc_helper_app/core/global_store/i_global_state.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/env/env_config.dart';
import 'package:doc_helper_app/feature/billing/domain/interfaces/i_billing_facade.dart';
import 'package:doc_helper_app/feature/plan/domain/interface/i_usage_facade.dart';
import 'package:doc_helper_app/feature/plan/domain/models/usage_info.dart';
import 'package:doc_helper_app/feature/user/domain/entity/user.dart';
import 'package:doc_helper_app/feature/user/domain/interface/i_user_facade.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

import '../../feature/billing/domain/entities/billing_entity.dart'
    show SubscriptionResponse;

@Singleton(as: IGlobalState, env: injectionEnv)
class GlobalState implements IGlobalState {
  GlobalState(this._userFacade, this._usageFacade, this._billingFacade)
    : _globalStore = const GlobalStore(),
      _globalStoreSubject = BehaviorSubject<GlobalStore>();

  final IUserFacade _userFacade;
  final IUsageFacade _usageFacade;
  final IBillingFacade _billingFacade;

  GlobalStore _globalStore;
  final BehaviorSubject<GlobalStore> _globalStoreSubject;

  @override
  Future<Either<ServerException, Unit>> fetchUserData() async {
    Either<ServerException, AppUser?>? userInfoOrFailure;
    Either<ServerException, UsageInfo?>? usageInfoOrFailure;
    Either<ServerException, SubscriptionResponse?>? subscriptionInfoOrFailure;

    await Future.wait([
      (() async => userInfoOrFailure = await _userFacade.getUserInfo())(),
      (() async => usageInfoOrFailure = await _usageFacade.getUsageInfo())(),
      (() async => subscriptionInfoOrFailure = await _billingFacade
          .getCurrentSubscriptionDetails())(),
    ]);

    final failures = <ServerException>[];

    userInfoOrFailure?.fold(failures.add, (_) {});
    usageInfoOrFailure?.fold(failures.add, (_) {});
    subscriptionInfoOrFailure?.fold(failures.add, (_) {});

    if (failures.isNotEmpty) {
      return left(
        const ServerException(exceptionType: ServerExceptionType.unknown),
      );
    }

    if (failures.isNotEmpty) {
      return left(failures.first);
    }

    _globalStore = _globalStore.copyWith(
      userInfo: userInfoOrFailure?.getOrElse(() => null),
      usageInfo: usageInfoOrFailure?.getOrElse(() => null),
      subscriptionResponse: subscriptionInfoOrFailure?.getOrElse(() => null),
    );

    _globalStoreSubject.add(_globalStore);

    return right(unit);
  }

  @override
  GlobalStore get store => _globalStore;

  @override
  Future<void> clear() async {
    _globalStore = const GlobalStore();
    _globalStoreSubject.add(_globalStore);
  }

  @override
  Stream<GlobalStore> get globalStoreStream => _globalStoreSubject.stream;
}

IGlobalState get globalState => getIt<IGlobalState>();
