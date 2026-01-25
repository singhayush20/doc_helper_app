import 'package:flutter/material.dart';

class DsMenuAction {

  const DsMenuAction({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isDestructive = false,
  });
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isDestructive;
}
