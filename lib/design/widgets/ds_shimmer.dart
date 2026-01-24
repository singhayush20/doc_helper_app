import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class DsShimmer extends StatelessWidget {
  const DsShimmer({
    super.key,
    required this.child,
    this.enabled = true,
    this.color = DsColors.white,
  });

  final Widget child;
  final bool enabled;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      Shimmer(color: color, enabled: enabled, child: child);
}
