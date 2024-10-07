class RouteManager {
  static final RouteManager _instance = RouteManager._internal();

  factory RouteManager() {
    return _instance;
  }

  RouteManager._internal();

  // Base URL da API
  // String _baseUrl = "http://localhost:8080/";
  String _baseUrl = "http://191.252.3.43:60061/";
  // String _baseUrl = "http://187.122.102.36:60061/";
  //  String _baseUrl = "http://localhost:60061/";

  void updateBaseUrl(String newUrl) {
    _baseUrl = newUrl.endsWith('/') ? newUrl : '$newUrl/';
  }

  String makeApiUrl(String path) {
    return '$_baseUrl$path';
  }
}
