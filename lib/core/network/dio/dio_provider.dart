import 'package:dio/dio.dart';
import 'package:doc_helper_app/core/local_storage/i_local_storage_facade.dart';
import 'package:doc_helper_app/core/network/dio/i_dio_provider.dart';
import 'package:doc_helper_app/core/network/logger_interceptor.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: IDioProvider)
class DioProvider implements IDioProvider {
  @factoryMethod
  factory DioProvider(
    @Named('baseUrl') String baseUrl,
    ILocalStorageFacade localStorageFacade,
  ) => DioProvider._internal(
    baseUrl: baseUrl,
    localStorageFacade: localStorageFacade,
  );

  DioProvider._internal({
    required this.baseUrl,
    required this.localStorageFacade,
  });

  final String baseUrl;
  final ILocalStorageFacade localStorageFacade;

  @override
  Future<Dio> get baseDio => _createDio();

  Future<Dio> _createDio() async {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        validateStatus: (status) =>
            status != null && status >= 200 && status < 300,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = localStorageFacade.getAuthToken();
          options.headers['Authorization'] = 'Bearer $token';
          handler.next(options);
        },
      ),
    );
    dio.interceptors.add(LoggerInterceptor());
    return dio;
  }
}
