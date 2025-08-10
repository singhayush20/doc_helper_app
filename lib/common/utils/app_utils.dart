import 'package:freezed_annotation/freezed_annotation.dart';

const liteFreezed = Freezed(
  toJson: false,
  fromJson: false,
  map: FreezedMapOptions.none,
  when: FreezedWhenOptions.none,
  copyWith: true,
  equal: true,
);
