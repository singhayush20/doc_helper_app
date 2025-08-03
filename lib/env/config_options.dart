import 'package:doc_helper_app/env/env_config.dart';

abstract class IConfigOptions {
  String get baseUrl;
  String get env;
}

class DevConfigOptions implements IConfigOptions {
  @override
  String get baseUrl => 'http://localhost:8085';

  @override
  String get env => Env.dev;
}

class ProdConfigOptions implements IConfigOptions {
  @override
  String get baseUrl => 'https://api.example.com';

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
