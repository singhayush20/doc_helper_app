import 'package:doc_helper_app/env/env_config.dart';

abstract class IConfigOptions {
  String get baseUrl;
  String get env;
}

class DevConfigOptions implements IConfigOptions {
  @override
  // String get baseUrl => 'http://172.21.160.1:8086';
  String get baseUrl => 'https://2a483df9f2da.ngrok-free.app';

  @override
  String get env => Env.dev;
}

class ProdConfigOptions implements IConfigOptions {
  @override
  String get baseUrl => 'https://972e01ea4169.ngrok-free.app';

  @override
  String get env => Env.prod;
}

IConfigOptions configOptions = DevConfigOptions();

void initConfig({required String env}) {
  if (env == Env.prod) {
    configOptions = ProdConfigOptions();
  } else {
    configOptions = DevConfigOptions();
  }
}
