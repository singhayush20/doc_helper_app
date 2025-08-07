import 'dart:async';

import 'package:doc_helper_app/core/routes/router.dart';

class RouteInitiatorMetaData {
  RouteInitiatorMetaData({required this.parentRouteId, this.data});

  final RouteId parentRouteId;
  final dynamic data;
}

class RouteCompleterMetaData {
  RouteCompleterMetaData({required this.status, this.data});

  final RouteCompleterStatus status;
  final dynamic data;
}

enum RouteCompleterStatus { success, error }

final routeTracker = RouteTracker();

class RouteTracker {
  factory RouteTracker() => _singleton;

  RouteTracker._internal();

  static final RouteTracker _singleton = RouteTracker._internal();

  final Map<RouteId, RouteInitiatorMetaData> initiatorMap = {};
  final Map<String, Completer<RouteCompleterMetaData>> completerMap = {};

  void pushInitiatorForChild({
    required RouteId child,
    required RouteId parent,
  }) {
    initiatorMap
      ..remove(child)
      ..putIfAbsent(child, () => RouteInitiatorMetaData(parentRouteId: parent));
  }

  RouteInitiatorMetaData? getInitatorDataFor({required RouteId child}) =>
      initiatorMap[child];

  void attachCompleterFor({
    required RouteId parent,
    required RouteId child,
    required Completer<RouteCompleterMetaData> completer,
  }) {
    final key = _getKey(parent: parent, child: child);
    completerMap
      ..remove(key)
      ..putIfAbsent(key, () => completer);
  }

  void resolveCompleterFor({
    required RouteId parent,
    required RouteId child,
    required RouteCompleterStatus status,
    dynamic data,
  }) {
    final completer = _getCompleterFor(parent: parent, child: child);
    final completerData = RouteCompleterMetaData(status: status, data: data);
    completer?.complete(completerData);
  }

  void resolveCompleterForAll({
    required RouteId child,
    required RouteCompleterStatus status,
    dynamic data,
  }) {
    final completers = _getCompleterforAll(child: child);
    final completerData = RouteCompleterMetaData(status: status, data: data);

    for (final completer in completers) {
      completer?.complete(completerData);
    }
  }

  Completer<RouteCompleterMetaData>? _getCompleterFor({
    required RouteId parent,
    required RouteId child,
  }) {
    final key = _getKey(parent: parent, child: child);
    final completer = completerMap[key];
    return completer;
  }

  List<Completer<RouteCompleterMetaData>?> _getCompleterforAll({
    required RouteId child,
  }) {
    final completers = <Completer<RouteCompleterMetaData>?>[];
    for (final key in completerMap.keys) {
      if (key.endsWith(child.name)) {
        completers.add(completerMap[key]);
      }
    }

    return completers;
  }

  void reset() {
    initiatorMap.clear();
    completerMap.clear();
  }
}

String _getKey({required RouteId parent, required RouteId child}) =>
    '${parent.name}__${child.name}';
