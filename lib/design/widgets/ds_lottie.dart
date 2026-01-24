import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DsLottie extends StatelessWidget {
  const DsLottie({
    super.key,
    required this.lottieUrl,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.repeat = true,
    this.reverse = false,
    this.animate = true,
  });

  final String lottieUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool repeat;
  final bool reverse;
  final bool animate;

  bool _isNetworkUrl(String url) =>
      url.startsWith('http://') || url.startsWith('https://');

  bool _isLottie(String url) {
    final lowerUrl = url.toLowerCase();
    return lowerUrl.endsWith('.json');
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLottie(lottieUrl)) {
      return SizedBox(
        width: width,
        height: height,
        child: const Icon(Icons.error),
      );
    }

    if (_isNetworkUrl(lottieUrl)) {
      return Lottie.network(
        lottieUrl,
        width: width,
        height: height,
        fit: fit,
        repeat: repeat,
        reverse: reverse,
        animate: animate,
        errorBuilder: (context, error, stackTrace) => SizedBox(
          width: width,
          height: height,
          child: const Icon(Icons.error),
        ),
      );
    } else {
      return Lottie.asset(
        lottieUrl,
        width: width,
        height: height,
        fit: fit,
        repeat: repeat,
        reverse: reverse,
        animate: animate,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error parsing lottie file: $error');
          return SizedBox(
          width: width,
          height: height,
          child: const Icon(Icons.error),
        );
        },
      );
    }
  }
}
