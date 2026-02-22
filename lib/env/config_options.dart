import 'package:doc_helper_app/env/env_config.dart';

abstract class IConfigOptions {
  String get baseUrl;
  String get env;
  String get cdnUrl;
}

class DevConfigOptions implements IConfigOptions {
  @override
  String get baseUrl => 'http://172.21.160.1:8086';

  @override
  String get env => Env.dev;

  @override
  // TODO: implement cdnUrl
  String get cdnUrl =>
      'https://res.cloudinary.com/dollqnkui/image/upload/v1771701798/';
}

class ProdConfigOptions implements IConfigOptions {
  @override
  String get baseUrl => 'http://192.168.1.1:8086';

  @override
  String get env => Env.prod;

  @override
  // TODO: implement cdnUrl
  String get cdnUrl =>
      'https://res.cloudinary.com/dollqnkui/image/upload/v1771701798/';
}

IConfigOptions configOptions = DevConfigOptions();

void initConfig({required String env}) {
  if (env == Env.prod) {
    configOptions = ProdConfigOptions();
  } else {
    configOptions = DevConfigOptions();
  }
}
