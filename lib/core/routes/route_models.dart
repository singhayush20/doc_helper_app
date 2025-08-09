import 'dart:async';

import 'package:doc_helper_app/core/routes/router.dart';

/**
 * Stores metadata about which route initiated a navigation to a child route.
 */
class RouteInitiatorMetaData {
  RouteInitiatorMetaData({required this.parentRouteId, this.data});

  final RouteId parentRouteId;
  final dynamic data;
}

/**
 *  Encapsulates the result of a navigation operation that can be communicated
 *  back to the parent route.
 */
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

  // Tracks parent-child relationships using RouteId as keys
  final Map<RouteId, RouteInitiatorMetaData> initiatorMap = {};
  // Manages async communication channels using composite keys
  final Map<String, Completer<RouteCompleterMetaData>> completerMap = {};

  // Establishes parent-child relationship when navigation occurs.
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

  // Creates an async communication channel between parent and child routes.
  // Completer Pattern: Uses Completer<T> to create a Future<T> that can be
  // completed manually.
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

  // Sends results from child route back to parent route.
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

  // Broadcasts results to all parents waiting for a specific child route's
  // completion.
  void resolveCompleterForAll({
    required RouteId child,
    required RouteCompleterStatus status,
    dynamic data,
  }) {
    final completers = _getCompleterForAll(child: child);
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

  List<Completer<RouteCompleterMetaData>?> _getCompleterForAll({
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
