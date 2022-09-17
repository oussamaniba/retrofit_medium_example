import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:retrofit_example/api/endpoints.dart';
import 'package:retrofit_example/data/posts.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: EndPoints.baseUrl)
abstract class RestClientApi {
  factory RestClientApi(Dio dio, {String baseUrl}) = _RestClientApi;

  @GET("${EndPoints.posts}{id}")
  Future<Posts> getPostWithPath(@Path() id);

  @PUT("${EndPoints.posts}{id}")
  Future<Posts> getPostWithPut(@Path() id);

  @POST(EndPoints.posts)
  Future<Posts> getPostWithPost(@Body() id);
}

class ApiService {
  ApiService._();
  static final ApiService _apiService = ApiService._();
  static ApiService get instance => _apiService;

  RestClientApi get restClient => RestClientApi(_buildDioClient(EndPoints.baseUrl));

  Dio _buildDioClient(String baseUrl) {
    final dio = Dio()..options = BaseOptions(baseUrl: baseUrl);
    dio.interceptors.addAll([
      LogInterceptor(),
    ]);
    return dio;
  }
}
