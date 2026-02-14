import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/feature/ui_component/data/models/ui_config_dtos.dart';
import 'package:doc_helper_app/feature/ui_component/domain/entities/ui_config_entities.dart';

extension TextInfoDtoX on TextInfoDto {
  TextInfo toDomain() => TextInfo(
    data: data,
    color: getColorFromCode(colorCode: color),
  );
}

extension ComponentActionDtoX on ComponentActionDto {
  ComponentAction toDomain() => ComponentAction(
    webViewUrl: webViewUrl,
    routeName: routeName,
    bottomSheet: bottomSheet?.toDomain(),
    modal: modal?.toDomain(),
  );
}

extension ButtonInfoDtoX on ButtonInfoDto {
  ButtonInfo toDomain() => ButtonInfo(
    text: text,
    leadingIcon: leadingIcon,
    trailingIcon: trailingIcon,
    onClick: onClick?.toDomain(),
  );
}

extension ModalDtoX on ModalDto {
  Modal toDomain() => Modal(
    title: title?.toDomain(),
    description: description?.toDomain(),
    primaryButton: primaryButton?.toDomain(),
    secondaryButton: secondaryButton?.toDomain(),
    isClosable: isClosable,
    iconUrl: iconUrl,
  );
}

extension BottomSheetDtoX on BottomSheetDto {
  BottomSheet toDomain() => BottomSheet(
    title: title?.toDomain(),
    description: description?.toDomain(),
    iconUrl: iconUrl,
    primaryButton: primaryButton?.toDomain(),
    secondaryButton: secondaryButton?.toDomain(),
    isClosable: isClosable,
  );
}

extension FeatureCardDtoX on FeatureCardDto {
  FeatureCard toDomain() => FeatureCard(
    title: title?.toDomain(),
    description: description?.toDomain(),
    iconUrl: iconUrl,
    backgroundColor: getColorFromCode(colorCode: backgroundColor),
    onClick: onClick?.toDomain(),
  );
}

extension BannerDtoX on BannerDto {
  Banner toDomain() => Banner(
    title: title?.toDomain(),
    description: description?.toDomain(),
    leadingImageUrl: leadingImageUrl,
    buttonInfo: buttonInfo?.toDomain(),
    onClick: onClick?.toDomain(),
  );
}

extension UIComponentDtoX on UIComponentDto {
  UIComponent toDomain() => UIComponent(
    card: card?.toDomain(),
    bottomSheet: bottomSheet?.toDomain(),
    modal: modal?.toDomain(),
    banner: banner?.toDomain(),
  );
}
