import 'package:dio/dio.dart';
import 'package:doc_helper_app/network/dio/i_dio_provider.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: IDioProvider)
class DioProvider implements IDioProvider {
  @factoryMethod
  factory DioProvider(@Named('baseUrl') String baseUrl) =>
      DioProvider._internal(baseUrl: baseUrl);

  DioProvider._internal({required this.baseUrl});

  final String baseUrl;

  @override
  Future<Dio> get baseDio => _createDio();

  Future<Dio> _createDio() async {
    final dio = Dio(BaseOptions(baseUrl: baseUrl));
    return dio;
  }
}
