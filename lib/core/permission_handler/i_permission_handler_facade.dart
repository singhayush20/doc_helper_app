import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

typedef OpenAppSettingsCallback = Future<void> Function();

abstract class IPermissionHandlerFacade {
  Future<void> handlePermission({
    required Permission permission,
    required VoidCallback onGranted,
    required VoidCallback onDenied,
    required ValueChanged<OpenAppSettingsCallback> onPermanentlyDenied,
    VoidCallback? onRestricted,
  });

  Future<void> handlePermissions({
    required List<Permission> permissions,
    required ValueChanged<Map<Permission, PermissionStatus>> onResult,
  });
}
