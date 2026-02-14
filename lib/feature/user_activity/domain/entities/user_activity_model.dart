import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/user_activity/domain/entities/user_activity_enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_activity_model.freezed.dart';

@liteFreezed
abstract class UserActivityInfo with _$UserActivityInfo {
  const factory UserActivityInfo({final List<UserActivity?>? userActivities}) =
      _UserActivityInfo;
}

@liteFreezed
abstract class UserActivity with _$UserActivity {
  const factory UserActivity({
    final int? documentId,
    final DateTime? dominantAt,
    final UserActivityType? lastAction,
    final UserActivityType? dominantActivity,
    final String? fileName,
  }) = _UserActivity;
}
