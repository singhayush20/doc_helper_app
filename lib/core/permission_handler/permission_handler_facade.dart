import 'dart:async';

import 'package:doc_helper_app/core/permission_handler/i_permission_handler_facade.dart';
import 'package:doc_helper_app/env/env_config.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@Injectable(as: IPermissionHandlerFacade, env: injectionEnv)
class PermissionHandlerFacade
    with WidgetsBindingObserver
    implements IPermissionHandlerFacade {
  PermissionHandlerFacade() {
    WidgetsBinding.instance.addObserver(this);
  }

  VoidCallback? _onGrantedCallback;
  Permission? _permissionToCheck;

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed &&
        _permissionToCheck != null &&
        _onGrantedCallback != null) {
      final status = await _permissionToCheck!.status;
      if (status.isGranted) {
        _onGrantedCallback!();
      }
      _permissionToCheck = null;
      _onGrantedCallback = null;
    }
  }

  @override
  Future<void> handlePermission({
    required Permission permission,
    required VoidCallback onGranted,
    required VoidCallback onDenied,
    required ValueChanged<OpenAppSettingsCallback> onPermanentlyDenied,
    VoidCallback? onRestricted,
  }) async {
    final status = await permission.status;
    _handleStatus(
      status,
      permission: permission,
      onGranted: onGranted,
      onDenied: onDenied,
      onPermanentlyDenied: onPermanentlyDenied,
      onRestricted: onRestricted,
    );
  }

  Future<void> _handleStatus(
    PermissionStatus status, {
    required Permission permission,
    required VoidCallback onGranted,
    required VoidCallback onDenied,
    required ValueChanged<OpenAppSettingsCallback> onPermanentlyDenied,
    VoidCallback? onRestricted,
  }) async {
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
        onGranted();
        break;
      case PermissionStatus.denied:
        final newStatus = await permission.request();
        _handleStatus(
          newStatus,
          permission: permission,
          onGranted: onGranted,
          onDenied: onDenied,
          onPermanentlyDenied: onPermanentlyDenied,
          onRestricted: onRestricted,
        );
        break;
      case PermissionStatus.permanentlyDenied:
        onPermanentlyDenied(() async {
          _permissionToCheck = permission;
          _onGrantedCallback = onGranted;
          await openAppSettings();
        });
        break;
      case PermissionStatus.restricted:
        if (onRestricted != null) {
          onRestricted();
        } else {
          onDenied();
        }
        break;
    }
  }

  @override
  Future<void> handlePermissions({
    required List<Permission> permissions,
    required ValueChanged<Map<Permission, PermissionStatus>> onResult,
  }) async {
    final statuses = await permissions.request();
    onResult(statuses);
  }
}
