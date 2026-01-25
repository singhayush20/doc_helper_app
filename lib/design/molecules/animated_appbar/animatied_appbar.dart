import 'package:doc_helper_app/design/atoms/typography/ds_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnimatedAppbar extends StatefulWidget implements PreferredSizeWidget{
  const AnimatedAppbar({
    super.key,
    this.titleText,
    this.backgroundColor,
    this.centerTitle = false,
    this.actions,
    this.leading,
    this.backButtonRequired = true,
    this.onBackPressed,
  });

  final String? titleText;
  final Color? backgroundColor;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool backButtonRequired;
  final VoidCallback? onBackPressed;

  @override
  State<AnimatedAppbar> createState() => _AnimatedAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AnimatedAppbarState extends State<AnimatedAppbar>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Color?>? _backgroundColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _backgroundColor = ColorTween(
      begin: Colors.transparent,
      end: widget.backgroundColor,
    ).animate(CurvedAnimation(parent: _controller!, curve: Curves.easeInOut));
  }

  void _updateScrollState(double pixels) {
    if (pixels > 10 &&
        _controller?.status != AnimationStatus.forward &&
        _controller?.value != 1.0) {
      _controller?.forward();
    } else if (pixels <= 10 &&
        _controller?.status != AnimationStatus.reverse &&
        _controller?.value != 0.0) {
      _controller?.reverse();
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _backgroundColor!,
    builder: (context, _) {
      Brightness currentStatusBarIconBrightness;
      Brightness currentStatusBarBrightness;
      if ((_controller?.value ?? 1) < 0.5) {
        currentStatusBarIconBrightness = Brightness.dark;
        currentStatusBarBrightness = Brightness.light;
      } else {
        currentStatusBarIconBrightness = Brightness.light;
        currentStatusBarBrightness = Brightness.dark;
      }
      return AppBar(
        title: widget.titleText != null
            ? DsText.titleLarge(data: widget.titleText ?? '')
            : null,
        backgroundColor: _backgroundColor?.value,
        centerTitle: widget.centerTitle,
        automaticallyImplyLeading: widget.backButtonRequired,
        leading: !widget.backButtonRequired
            ? widget.leading
            : IconButton(
                onPressed: () {
                  if (widget.onBackPressed != null) {
                    widget.onBackPressed?.call();
                  } else {
                    if (context.canPop()) {
                      GoRouter.of(context).pop();
                    }
                  }
                },
                icon: const Icon(Icons.arrow_back),
              ),
        actions: [...?widget.actions],
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle
            ?.copyWith(
              statusBarIconBrightness: currentStatusBarIconBrightness,
              statusBarBrightness: currentStatusBarBrightness,
            ),
        notificationPredicate: (ScrollNotification notification) {
          if (notification.depth == 0) {
            _updateScrollState(notification.metrics.pixels);
          }
          return false;
        },
      );
    },
  );

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
