import 'package:doc_helper_app/core/router/route_mapper.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/auth/presentation/ui/password_reset/password_reset_page.dart';
import 'package:doc_helper_app/feature/auth/presentation/ui/sign_in_page.dart';
import 'package:doc_helper_app/feature/auth/presentation/ui/sign_up/signup_page.dart';
import 'package:doc_helper_app/feature/docs/presentation/ui/docs_page.dart';
import 'package:doc_helper_app/feature/home/presentation/ui/home_page.dart';
import 'package:doc_helper_app/feature/main/presentation/ui/landing_page.dart';
import 'package:doc_helper_app/feature/profile/presentation/ui/profile_page.dart';
import 'package:doc_helper_app/feature/splash_screen/presentation/ui/splash_page.dart';
import 'package:go_router/go_router.dart';

import 'auth_notifier.dart';

GoRouter buildRouter(AuthNotifier authNotifier) => GoRouter(
  initialLocation: '/splash',
  refreshListenable: authNotifier,
  redirect: (context, state) {
    final authed = authNotifier.isAuthenticated;
    final loc = state.uri.toString();

    // Always allow splash to handle its own logic
    if (loc == '/splash') return null;

    // Define public routes (routes accessible without authentication)
    final publicRoutes = ['/signIn', '/signUp', '/passwordReset'];
    final isPublicRoute = publicRoutes.contains(loc);

    // If trying to access shell routes or other protected routes without auth
    if (!authed && !isPublicRoute) {
      return '/signIn';
    }

    // If authenticated and trying to access auth pages, redirect to home
    if (authed && (isPublicRoute || loc == '/')) {
      return '/home';
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
    ShellRoute(
      builder: (context, state, child) => LandingPage(child: child),
      routes: [
        GoRoute(
          name: Routes.home,
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          name: Routes.docs,
          path: '/docs',
          builder: (context, state) => const DocsPage(),
        ),
        GoRoute(
          name: Routes.profile,
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
  ],
);

final router = buildRouter(getIt<AuthNotifier>());
