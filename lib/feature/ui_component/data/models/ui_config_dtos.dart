import 'package:freezed_annotation/freezed_annotation.dart';

part 'ui_config_dtos.g.dart';

@JsonSerializable()
class TextInfoDto {
  const TextInfoDto({required this.data, required this.color});

  factory TextInfoDto.fromJson(Map<String, dynamic> json) =>
      _$TextInfoDtoFromJson(json);

  final String? data;
  final String? color;
}

@JsonSerializable()
class ButtonInfoDto {
  const ButtonInfoDto({
    required this.leadingIcon,
    required this.trailingIcon,
    required this.onClick,
    required this.buttonData,
    required this.buttonColor,
  });

  factory ButtonInfoDto.fromJson(Map<String, dynamic> json) =>
      _$ButtonInfoDtoFromJson(json);

  final TextInfoDto? buttonData;
  final String? leadingIcon;
  final String? trailingIcon;
  final ComponentActionDto? onClick;
  final String? buttonColor;
}

@JsonSerializable()
class ComponentActionDto {
  const ComponentActionDto({
    required this.webViewUrl,
    required this.routeName,
    required this.bottomSheet,
    required this.modal,
  });

  factory ComponentActionDto.fromJson(Map<String, dynamic> json) =>
      _$ComponentActionDtoFromJson(json);

  final String? webViewUrl;
  final String? routeName;
  final BottomSheetDto? bottomSheet;
  final ModalDto? modal;
}

@JsonSerializable()
class ModalDto {
  const ModalDto({
    required this.title,
    required this.description,
    required this.primaryButton,
    required this.secondaryButton,
    required this.isClosable,
    required this.iconUrl,
  });

  factory ModalDto.fromJson(Map<String, dynamic> json) =>
      _$ModalDtoFromJson(json);

  final TextInfoDto? title;
  final TextInfoDto? description;
  final ButtonInfoDto? primaryButton;
  final ButtonInfoDto? secondaryButton;
  final bool? isClosable;
  final String? iconUrl;
}

@JsonSerializable()
class BottomSheetDto {
  const BottomSheetDto({
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.primaryButton,
    required this.secondaryButton,
    required this.isClosable,
  });

  factory BottomSheetDto.fromJson(Map<String, dynamic> json) =>
      _$BottomSheetDtoFromJson(json);

  final TextInfoDto? title;
  final TextInfoDto? description;
  final String? iconUrl;
  final ButtonInfoDto? primaryButton;
  final ButtonInfoDto? secondaryButton;
  final bool? isClosable;
}

@JsonSerializable()
class FeatureCardDto {
  const FeatureCardDto({
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.backgroundColor,
    required this.onClick,
  });

  factory FeatureCardDto.fromJson(Map<String, dynamic> json) =>
      _$FeatureCardDtoFromJson(json);

  final TextInfoDto? title;
  final TextInfoDto? description;
  final String? iconUrl;
  final String? backgroundColor;
  final ComponentActionDto? onClick;
}

@JsonSerializable()
class BannerDto {
  const BannerDto({
    required this.title,
    required this.description,
    required this.leadingImageUrl,
    required this.buttonInfo,
    required this.onClick,
    required this.backgroundColor
  });

  factory BannerDto.fromJson(Map<String, dynamic> json) =>
      _$BannerDtoFromJson(json);

  final TextInfoDto? title;
  final TextInfoDto? description;
  final String? leadingImageUrl;
  final ButtonInfoDto? buttonInfo;
  final ComponentActionDto? onClick;
  final String? backgroundColor;
}

@JsonSerializable()
class UIComponentDto {
  const UIComponentDto({
    required this.card,
    required this.bottomSheet,
    required this.modal,
    required this.banner,
  });

  factory UIComponentDto.fromJson(Map<String, dynamic> json) =>
      _$UIComponentDtoFromJson(json);

  final FeatureCardDto? card;
  final BottomSheetDto? bottomSheet;
  final ModalDto? modal;
  final BannerDto? banner;
}
