import 'package:dio/dio.dart';
import 'package:doc_helper_app/core/local_storage/hive/hive_box_handler.dart';
import 'package:doc_helper_app/env/config_options.dart';
import 'package:doc_helper_app/env/env_config.dart';
import 'package:doc_helper_app/network/dio/i_dio_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@module
abstract class InjectionRegisterModule {
  @preResolve
  @singleton
  Future<Dio> baseDio(IDioProvider dioProvider) async => dioProvider.baseDio;

  @singleton
  @Named('baseUrl')
  String get baseUrl => configOptions.baseUrl;

  @singleton
  Env get env => Env(configOptions.env);

  @singleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @preResolve
  @lazySingleton
  Future<HiveBoxHandler> get hiveBoxHandler async {
    final appStorageBox = await Hive.openBox('app_storage');

    return HiveBoxHandler(appStorageBox: appStorageBox);
  }
}
