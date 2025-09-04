import 'api_client.dart';

class ApiManager {
  late final ApiClient _apiClient;

  /// create api client instance
  ApiManager() {
    _apiClient = DioClient();
  }

  /// return api client instance
  ApiClient call() {
    return _apiClient;
  }
}
