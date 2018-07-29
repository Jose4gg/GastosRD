import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  static final http.Client _client = http.Client();
  static final HttpClient _httpClient = new HttpClient();

  static final JsonDecoder _decoder = new JsonDecoder();

  static Future<dynamic> get(String url, {Map headers}) async {
    return await _client.get(url, headers: headers)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  // Future<dynamic> post(String url, dynamic body) async {
  //   return await _client
  //       .post(url, body: utf8.encode(json.encode(body)))
  //       .then((http.Response response) {
  //     final String res = response.body;
  //     final int statusCode = response.statusCode;
  //     if (statusCode < 200 || statusCode > 400 || json == null) {
  //       throw new Exception("Error while fetching data");
  //     }
  //     return _decoder.convert(res);
  //   });
  // }

  static Future<dynamic> post(String url, {Map headers, body, encoding}) async {
    HttpClientRequest request = await _httpClient.postUrl(Uri.parse(url)); 
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    String reply;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      reply = await response.transform(utf8.decoder).join();
      Map data = _decoder.convert(reply);
      data.addAll(_decoder.convert(_checkError(response.statusCode)));
      return data;
    } else {
      reply = _checkError(response.statusCode, json: json);
    }
    _httpClient.close();
    return _decoder.convert(reply);
  }

  static String _checkError(int statusCode, {JsonCodec json}) {
    String reply;

    if (statusCode == 200) {
      reply = _errorJsonString(false, "");
    } else if (statusCode == 401) {
      reply = _errorJsonString(true, "Unauthorized");
    } else if (statusCode == 400) {
      reply = _errorJsonString(true, "Bad Request");
    } else if (statusCode == 404) {
      reply = _errorJsonString(true, "Endpoint not found");
    } else if (statusCode < 200 || statusCode > 400 || json == null) {
      reply = _errorJsonString(true, "Error while fetching data");
    }
    
    return reply;
  }

  static String _errorJsonString(bool status, String message) {
    return '{ "error": { "status": $status, "message": "$message" } }';
  }
}