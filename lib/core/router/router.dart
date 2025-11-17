import 'package:doc_helper_app/core/router/route_mapper.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/auth/presentation/ui/email_verification/email_verification_page.dart';
import 'package:doc_helper_app/feature/auth/presentation/ui/password_reset/password_reset_page.dart';
import 'package:doc_helper_app/feature/auth/presentation/ui/sign_in_page.dart';
import 'package:doc_helper_app/feature/auth/presentation/ui/sign_up/signup_page.dart';
import 'package:doc_helper_app/feature/home/presentation/ui/home_page.dart';
import 'package:doc_helper_app/feature/main/presentation/ui/landing_page.dart';
import 'package:doc_helper_app/feature/profile/presentation/ui/profile_page.dart';
import 'package:doc_helper_app/feature/splash_screen/presentation/ui/splash_page.dart';
import 'package:doc_helper_app/feature/user_docs/presentation/ui/user_docs_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_notifier.dart';

// Create GlobalKeys for each navigation branch
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellHome',
);
final _shellNavigatorDocsKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellDocs',
);
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellProfile',
);

GoRouter buildRouter(AuthNotifier authNotifier) => GoRouter(
  initialLocation: '/splash',
  refreshListenable: authNotifier,
  redirect: (context, state) {
    final authed = authNotifier.isAuthenticated;
    final currentRoute = state.uri.toString();

    // Always allow splash to handle its own logic
    if (currentRoute == '/splash') return null;

    // Define public routes (routes accessible without authentication)
    final publicRoutes = ['/signIn', '/signUp', '/passwordReset'];
    final isPublicRoute = publicRoutes.contains(currentRoute);

    // If trying to access shell routes or other protected routes without auth
    if (!authed && !isPublicRoute) {
      return '/signIn';
    }

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
      name: Routes.signUp,
      path: '/signUp',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      name: Routes.passwordReset,
      path: '/passwordReset',
      builder: (context, state) => const PasswordResetPage(),
    ),
    GoRoute(
      name: Routes.emailVerification,
      path: '/emailVerification',
      builder: (context, state) => const EmailVerificationPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          LandingPage(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              name: Routes.home,
              path: '/home',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomePage()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorDocsKey,
          routes: [
            GoRoute(
              name: Routes.docs,
              path: '/docs',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: UserDocsPage()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfileKey,
          routes: [
            GoRoute(
              name: Routes.profile,
              path: '/profile',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ProfilePage()),
            ),
          ],
        ),
      ],
    ),
  ],
);

final router = buildRouter(getIt<AuthNotifier>());
