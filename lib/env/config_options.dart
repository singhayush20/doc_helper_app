import 'package:doc_helper_app/env/env_config.dart';

abstract class IConfigOptions {
  String get baseUrl;
  String get env;
}

class DevConfigOptions implements IConfigOptions {
  @override
  String get baseUrl => 'http://192.168.1.6:8086';

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
