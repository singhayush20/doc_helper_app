import 'package:dio/dio.dart';

abstract class IDioProvider {
  Future<Dio> get baseDio;
}
