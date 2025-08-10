import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/ServerException.dart';
import 'package:doc_helper_app/feature/auth/domain/entities/user.dart';
import 'package:doc_helper_app/feature/auth/domain/interfaces/i_auth_facade.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@singleton
class AuthNotifier extends ChangeNotifier {
  AuthNotifier(this._authFacade) {
    _sub = _authFacade.authStateChanges().listen((userOrFailure) {
      _current = userOrFailure.getOrElse(() => null);
      notifyListeners();
    });
  }
  final IAuthFacade _authFacade;
  late final StreamSubscription<Either<ServerException, AppUser?>> _sub;
  AppUser? _current;

  bool get isAuthenticated => _current != null;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
