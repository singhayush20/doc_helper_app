import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';

import 'global_store.dart';

abstract class IGlobalState {
  Future<Either<ServerException,Unit>> fetchUserData();

  GlobalStore get store;

  Stream<GlobalStore> get globalStoreStream;

  Future<void> clear();
}