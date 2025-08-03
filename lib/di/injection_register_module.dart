import 'package:dio/dio.dart';
import 'package:doc_helper_app/env/config_options.dart';
import 'package:doc_helper_app/env/env_config.dart';
import 'package:doc_helper_app/network/dio/i_dio_provider.dart';
import 'package:injectable/injectable.dart';

@module
abstract class InjectionRegisterModule {
  @preResolve
  @singleton
  Future<Dio> baseDio(IDioProvider dioProvider) async => dioProvider.baseDio;

  @singleton
  String get baseUrl => configOptions.baseUrl;

  @singleton
  Env get env => Env(configOptions.env);
}
