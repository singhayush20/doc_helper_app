import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

const String _resetColor = '\x1B[0m';
const String _redColor = '\x1B[31m';
const String _greenColor = '\x1B[32m';
const String _yellowColor = '\x1B[33m';
const String _blueColor = '\x1B[34m';
const String _cyanColor = '\x1B[36m';

class LoggerInterceptor extends Interceptor {
  // Option to log request as cURL command

  LoggerInterceptor({
    bool? showRequest,
    bool? showResponse,
    bool? showError,
    bool? showRequestHeader,
    bool? showRequestBody,
    bool? showResponseHeader,
    bool? showResponseBody,
    bool? showErrorHeader,
    bool? showErrorBody,
    bool? showCurl,
  }) : _showRequest = showRequest ?? true,
       _showResponse = showResponse ?? true,
       _showError = showError ?? true,
       _showRequestHeader = showRequestHeader ?? true,
       _showRequestBody = showRequestBody ?? true,
       _showResponseHeader = showResponseHeader ?? true,
       _showResponseBody = showResponseBody ?? true,
       _showErrorHeader = showErrorHeader ?? true,
       _showErrorBody = showErrorBody ?? true,
       _showCurl = showCurl ?? false;
  final bool _showRequest;
  final bool _showResponse;
  final bool _showError;
  final bool _showRequestHeader;
  final bool _showRequestBody;
  final bool _showResponseHeader;
  final bool _showResponseBody;
  final bool _showErrorHeader;
  final bool _showErrorBody;
  final bool _showCurl;

  void _log(String message, String color) {
    if (kDebugMode) {
      debugPrint('$color$message$_resetColor');
    }
  }

  String _formatJson(dynamic json) {
    if (json == null) return 'null';
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  String _generateCurlCommand(RequestOptions options) {
    var command = 'curl';
    command += ' -X ${options.method}';

    options.headers.forEach((key, value) {
      if (key.toLowerCase() != 'content-length') {
        command += ' -H \'$key: $value\'';
      }
    });

    if (options.data != null) {
      if (options.data is Map || options.data is List) {
        command += ' -d \'${_formatJson(options.data)}\'';
      } else {
        command += ' -d \'${options.data.toString()}\'';
      }
    }
    command += ' "${options.uri.toString()}"';
    return command;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_showRequest && kDebugMode) {
      _log(
        '╔═════════════════════════ REQUEST ══════════════════════════',
        _blueColor,
      );
      _log('║ ${_blueColor}URI:$_resetColor ${options.uri}', _blueColor);
      _log('║ ${_blueColor}Method:$_resetColor ${options.method}', _blueColor);
      _log(
        '''║ ${_blueColor}Response Type:$_resetColor ${options.responseType.toString()}''',
        _blueColor,
      );
      _log(
        '''║ ${_blueColor}Follow Redirects:$_resetColor ${options.followRedirects}''',
        _blueColor,
      );
      _log(
        '''║ ${_blueColor}Connect Timeout:$_resetColor ${options.connectTimeout}''',
        _blueColor,
      );
      _log(
        '''║ ${_blueColor}Receive Timeout:$_resetColor ${options.receiveTimeout}''',
        _blueColor,
      );
      _log(
        '║ ${_blueColor}Extra:$_resetColor ${_formatJson(options.extra)}',
        _blueColor,
      );

      if (_showRequestHeader) {
        _log('║ ${_blueColor}Headers:', _blueColor);
        options.headers.forEach((key, v) => _log('║   $key: $v', _blueColor));
      }
      if (_showRequestBody && options.data != null) {
        _log('║ ${_blueColor}Body:', _blueColor);
        _log('║   ${_formatJson(options.data)}', _blueColor);
      }
      if (_showCurl) {
        _log('║ ${_cyanColor}cURL Command:', _blueColor);
        _log('║   ${_generateCurlCommand(options)}', _blueColor);
      }
      _log(
        '╚════════════════════════════════════════════════════════════',
        _blueColor,
      );
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_showResponse && kDebugMode) {
      _log(
        '╔═════════════════════════ RESPONSE ═════════════════════════',
        _greenColor,
      );
      _log(
        '║ ${_greenColor}URI:$_resetColor ${response.requestOptions.uri}',
        _greenColor,
      );
      _log(
        '║ ${_greenColor}Status Code:$_resetColor ${response.statusCode}',
        _greenColor,
      );
      _log(
        '║ ${_greenColor}Status Message:$_resetColor ${response.statusMessage}',
        _greenColor,
      );
      _log(
        '║ ${_greenColor}Is Redirect:$_resetColor ${response.isRedirect}',
        _greenColor,
      );

      if (_showResponseHeader) {
        _log('║ ${_greenColor}Headers:', _greenColor);
        response.headers.forEach(
          (key, v) => _log('║   $key: ${v.join(', ')}', _greenColor),
        );
      }
      if (_showResponseBody && response.data != null) {
        _log('║ ${_greenColor}Body:', _greenColor);
        _log('║   ${_formatJson(response.data)}', _greenColor);
      }
      _log(
        '╚═══════════════════════════════════════════════════════════',
        _greenColor,
      );
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_showError && kDebugMode) {
      _log(
        '╔══════════════════════════ ERROR ═══════════════════════════',
        _redColor,
      );
      _log(
        '║ ${_redColor}URI:$_resetColor ${err.requestOptions.uri}',
        _redColor,
      );
      _log('║ ${_redColor}Error Type:$_resetColor ${err.type}', _redColor);
      _log(
        '║ ${_redColor}Error Message:$_resetColor ${err.message}',
        _redColor,
      );

      if (err.response != null) {
        _log(
          '║ ${_redColor}Status Code:$_resetColor ${err.response?.statusCode}',
          _redColor,
        );
        _log(
          '''║ ${_redColor}Status Message:$_resetColor ${err.response?.statusMessage}''',
          _redColor,
        );
        if (_showErrorHeader && err.response?.headers != null) {
          _log('║ ${_redColor}Response Headers:', _redColor);
          err.response!.headers.forEach(
            (key, v) => _log('║   $key: ${v.join(', ')}', _redColor),
          );
        }
        if (_showErrorBody && err.response?.data != null) {
          _log('║ ${_redColor}Response Body:', _redColor);
          _log('║   ${_formatJson(err.response!.data)}', _redColor);
        }
      } else {
        _log(
          '║ ${_yellowColor}No Response from server for this error.',
          _redColor,
        );
      }
      _log('║ ${_redColor}Stack Trace:', _redColor);
      err.stackTrace.toString().split('\n').forEach((line) {
        _log('║   $line', _redColor);
      });
      _log(
        '╚═══════════════════════════════════════════════════════════',
        _redColor,
      );
    }
    super.onError(err, handler);
  }
}
