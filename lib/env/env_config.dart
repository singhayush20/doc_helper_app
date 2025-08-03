class Env {
  const Env(this.name);

  final String name;

  static const String dev = 'dev';
  static const String prod = 'prod';
  static const String test = 'test';
}

const injectionEnv = [Env.dev, Env.prod];
