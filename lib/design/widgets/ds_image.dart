import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DsImage extends StatelessWidget {
  const DsImage({
    super.key,
    required this.mediaUrl,
    this.fit,
    this.width,
    this.height,
  });

  final String mediaUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;

  bool _isNetworkUrl(String url) =>
      url.startsWith('http://') || url.startsWith('https://');

  bool _isSvg(String url) => url.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    if (_isNetworkUrl(mediaUrl)) {
      if (_isSvg(mediaUrl)) {
        return SvgPicture.network(
          mediaUrl,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          placeholderBuilder: (context) => const SizedBox(),
          errorBuilder: (context, url, error) => const Icon(Icons.error),
        );
      } else {
        return CachedNetworkImage(
          imageUrl: mediaUrl,
          width: width,
          height: height,
          fit: fit,
          placeholder: (context, url) => const SizedBox(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
      }
    } else {
      if (_isSvg(mediaUrl)) {
        return SvgPicture.asset(
          mediaUrl,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          errorBuilder: (context, url, error) => const Icon(Icons.error),
        );
      } else {
        return Image.asset(
          mediaUrl,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, url, error) => const Icon(Icons.error),
        );
      }
    }
  }
}
