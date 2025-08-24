import 'package:doc_helper_app/core/router/route_mapper.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/auth/presentation/ui/sign_in_page.dart';
import 'package:doc_helper_app/feature/home/presentation/ui/home_page.dart';
import 'package:doc_helper_app/feature/splash_screen/presentation/ui/splash_page.dart';
import 'package:go_router/go_router.dart';

import 'auth_notifier.dart';

GoRouter buildRouter(AuthNotifier authNotifier) => GoRouter(
  initialLocation: '/splash',
  refreshListenable: authNotifier, // re-run redirect on auth change
  redirect: (context, state) {
    final authed = authNotifier.isAuthenticated;
    final loc = state.uri.toString();

    // Let splash run its logic (async init / reading DI) to choose next route.
    if (loc == '/splash') return null;

    // Public routes: splash, signIn
    final isOnSignIn = loc == '/signIn';

    // If not authenticated, force sign-in for any protected route.
    if (!authed && !isOnSignIn) return '/signIn';

    return null;
  },
  routes: [
    GoRoute(
      name: Routes.splash,
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      name: Routes.signIn,
      path: '/signIn',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      name: Routes.home,
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);

final router = buildRouter(getIt<AuthNotifier>());
