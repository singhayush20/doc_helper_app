import 'dart:ui';

import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ui_config_entities.freezed.dart';

@liteFreezed
abstract class TextInfo with _$TextInfo {
  const factory TextInfo({
    String? data,
    Color? color,
  }) = _TextInfo;
}

@liteFreezed
abstract class ButtonInfo with _$ButtonInfo {
  const factory ButtonInfo({
    String? text,
    String? leadingIcon,
    String? trailingIcon,
    ComponentAction? onClick,
  }) = _ButtonInfo;
}

@liteFreezed
abstract class ComponentAction with _$ComponentAction {
  const factory ComponentAction({
    String? webViewUrl,
    String? routeName,
    BottomSheet? bottomSheet,
    Modal? modal,
  }) = _ComponentAction;
}

@liteFreezed
abstract class Modal with _$Modal {
  const factory Modal({
    TextInfo? title,
    TextInfo? description,
    ButtonInfo? primaryButton,
    ButtonInfo? secondaryButton,
    bool? isClosable,
    String? iconUrl,
  }) = _Modal;
}

@liteFreezed
abstract class BottomSheet with _$BottomSheet {
  const factory BottomSheet({
    TextInfo? title,
    TextInfo? description,
    String? iconUrl,
    ButtonInfo? primaryButton,
    ButtonInfo? secondaryButton,
    bool? isClosable,
  }) = _BottomSheet;
}

@liteFreezed
abstract class FeatureCard with _$FeatureCard {
  const factory FeatureCard({
    TextInfo? title,
    TextInfo? description,
    String? iconUrl,
    Color? backgroundColor,
    ComponentAction? onClick,
  }) = _FeatureCard;
}

@liteFreezed
abstract class Banner with _$Banner {
  const factory Banner({
    TextInfo? title,
    TextInfo? description,
    String? leadingImageUrl,
    ButtonInfo? buttonInfo,
    ComponentAction? onClick,
  }) = _Banner;
}

@liteFreezed
abstract class UIComponent with _$UIComponent {
  const factory UIComponent({
    FeatureCard? card,
    BottomSheet? bottomSheet,
    Modal? modal,
    Banner? banner,
  }) = _UIComponent;
}
