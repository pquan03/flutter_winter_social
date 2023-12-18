import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Repository {
  // static const String baseUrl = 'https://test-server-insta-demo1.onrender.com/api';
  static const String baseUrl = 'http://192.168.110.100:5000/api';
  final Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    HttpHeaders.acceptHeader: 'application/json',
  };
  Future<dynamic> postApi(String url, Object? data, String? token) async {
    final tokenRes = await http
        .post(Uri.parse('$baseUrl/$url'), body: jsonEncode(data), headers: {
      ...headers,
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    print('tokenRes: ${tokenRes.body}');
    return jsonDecode(tokenRes.body);
  }

  Future<dynamic> getApi(String url, String? token) async {
    print('token: $token');
    final tokenRes = await http.get(Uri.parse('$baseUrl/$url'), headers: {
      ...headers,
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    print('tokenRes: ${jsonDecode(tokenRes.body)}');
    return jsonDecode(tokenRes.body);
  }

  Future<dynamic> putApi(String url, Object? data, String? token) async {
    final tokenRes = await http
        .put(Uri.parse('$baseUrl/$url'), body: jsonEncode(data), headers: {
      ...headers,
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    print('tokenRes: ${tokenRes.body}');
    return jsonDecode(tokenRes.body);
  }

  Future<dynamic> patchApi(String url, Object? data, String? token) async {
    final tokenRes = await http
        .patch(Uri.parse('$baseUrl/$url'), body: jsonEncode(data), headers: {
      ...headers,
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    print('tokenRes: ${tokenRes.body}');
    return jsonDecode(tokenRes.body);
  }

  Future<dynamic> delApi(String url, String? token) async {
    final tokenRes = await http.delete(Uri.parse('$baseUrl/$url'), headers: {
      ...headers,
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
    return jsonDecode(tokenRes.body);
  }
}
