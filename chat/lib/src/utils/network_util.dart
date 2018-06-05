import 'dart:async';
import 'package:http/http.dart' as http;

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  Future<http.Response> get(String url, Map headers) {
    return http.get(url, headers: headers).then((http.Response response) {
      return handleResponse(response);
    });
  }

  Future<http.Response> post(String url, {Map headers, body, encoding}) {
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      return handleResponse(response);
    });
  }

  Future<http.Response> delete(String url, {Map headers}) {
    return http
        .delete(
      url,
      headers: headers,
    )
        .then((http.Response response) {
      return handleResponse(response);
    });
  }

  Future<http.Response> put(String url, {Map headers, body, encoding}) {
    return http
        .put(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      return handleResponse(response);
    });
  }

  http.Response handleResponse(http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode == 401) {
      throw new Exception("Unauthorized");
    } else if (statusCode != 200) {
      throw new Exception("Error while fetching data");
    }

    return response;
  }
}
