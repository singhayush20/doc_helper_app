import 'package:dio/dio.dart';
import 'package:doc_helper_app/core/local_storage/i_local_storage_facade.dart';
import 'package:doc_helper_app/core/network/dio/i_dio_provider.dart';
import 'package:doc_helper_app/core/network/logger_interceptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        onRequest: (options, handler) async {
          final user = FirebaseAuth.instance.currentUser;
          String? token;

          if (user != null) {
            token = await user.getIdToken();
          }
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
        onError: (DioException e, handler) async {
          // Handle expired token
          if (e.response?.statusCode == 401) {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              try {
                final newToken = await user.getIdToken(true);
                final cloneReq = e.requestOptions;
                cloneReq.headers['Authorization'] = 'Bearer $newToken';
                final response = await dio.fetch(cloneReq);
                return handler.resolve(response);
              } catch (refreshError) {
                await FirebaseAuth.instance.signOut();
                await localStorageFacade.clear();
              }
            }
          }

          handler.next(e);
        },
      ),
    );

    dio.interceptors.add(LoggerInterceptor());
    return dio;
  }
}
