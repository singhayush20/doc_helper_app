import 'package:doc_helper_app/common/extensions.dart';
import 'package:doc_helper_app/core/routes/route_models.dart';
import 'package:doc_helper_app/core/routes/router.dart';
import 'package:flutter/cupertino.dart';

class RouteNavigationObserver extends RouteObserver {
  factory RouteNavigationObserver() => _singleton;

  RouteNavigationObserver._();

  static final RouteNavigationObserver _singleton = RouteNavigationObserver._();

  final _navigationStack = <RouteId?>[];

  bool get pastOnboardingFlow => _navigationStack.contains(RouteId.dashboard);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeId = _getRouteIdFromString(route.settings.name);
    checkAndResolveRouteTracker(routeId);
    if (routeId != null) {
      _navigationStack.removeLast();
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeId = _getRouteIdFromString(route.settings.name);
    if (routeId != null) {
      _navigationStack.removeLast();
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final oldRouteId = _getRouteIdFromString(oldRoute?.settings.name);
    final newRouteId = _getRouteIdFromString(newRoute?.settings.name);
    if (oldRouteId != null && newRouteId != null) {
      final oldRouteIndex = _navigationStack.indexOf(oldRouteId);
      if (oldRouteIndex >= 0) {
        _navigationStack.replaceRange(oldRouteIndex, oldRouteIndex - 1, [
          newRouteId,
        ]);
      }
    }
  }

  void checkAndResolveRouteTracker(RouteId? routeId) {
    if (routeId == RouteId.dashboard) {
      routeTracker.reset();
    }
  }

  RouteId? _getRouteIdFromString(String? name) =>
      RouteId.values.firstWhereOrNull((e) => e.name == name);
}

final routeNavigationObserver = RouteNavigationObserver();
