import 'package:doc_helper_app/core/router/route_mapper.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/auth/presentation/ui/password_reset/password_reset_page.dart';
import 'package:doc_helper_app/feature/auth/presentation/ui/sign_in_page.dart';
import 'package:doc_helper_app/feature/auth/presentation/ui/sign_up/signup_page.dart';
import 'package:doc_helper_app/feature/home/presentation/ui/home_page.dart';
import 'package:doc_helper_app/feature/splash_screen/presentation/ui/splash_page.dart';
import 'package:go_router/go_router.dart';

import 'auth_notifier.dart';

GoRouter buildRouter(AuthNotifier authNotifier) => GoRouter(
  initialLocation: '/splash',
  refreshListenable: authNotifier,
  redirect: (context, state) {
    final authed = authNotifier.isAuthenticated;
    final loc = state.uri.toString();

    // Let splash run its logic
    if (loc == '/splash') return null;

    // Define public routes (routes accessible without authentication)
    final publicRoutes = ['/signIn', '/signUp', '/passwordReset'];
    final isPublicRoute = publicRoutes.contains(loc);

    if (!authed && !isPublicRoute) {
      return '/signIn';
    }

    // Optional: If authenticated and on sign-in page, redirect to home
    if (authed && loc == '/signIn') {
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
    GoRoute(
      name: Routes.home,
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);

final router = buildRouter(getIt<AuthNotifier>());
