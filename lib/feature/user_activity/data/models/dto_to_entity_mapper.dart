import 'package:doc_helper_app/core/extensions/extensions.dart';
import 'package:doc_helper_app/feature/user_activity/data/models/user_activity_dto.dart';
import 'package:doc_helper_app/feature/user_activity/domain/entities/user_activity_enum.dart';
import 'package:doc_helper_app/feature/user_activity/domain/entities/user_activity_model.dart';

extension UserActivityInfoDtoX on UserActivityInfoDto {
  UserActivityInfo toDomain() => UserActivityInfo(
    userActivities:
        userActivities?.map((dto) => dto?.toDomain()).toList() ?? [],
  );
}

extension UserActivityDtoX on UserActivityDto {
  UserActivity toDomain() => UserActivity(
    documentId: documentId,
    dominantAt: dominantAt,
    fileName: fileName,
    lastAction: UserActivityType.values.by(lastAction),
    dominantActivity: UserActivityType.values.by(dominantActivity),
  );
}
